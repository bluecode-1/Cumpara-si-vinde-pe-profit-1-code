package ro.profitnet.app;

import java.util.Locale;

import javax.inject.Inject;

import ro.profitnet.app.core.common.navigation.DeepLinks;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;
import ro.profitnet.app.core.security.SessionManager;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/**
 * Start-destination rules:
 * <ul>
 *   <li>no session: onboarding from the welcome screen;</li>
 *   <li>session and onboarding completed: Home;</li>
 *   <li>session and onboarding not completed: onboarding, resumed at the saved step.</li>
 * </ul>
 * Blocking (Keystore and database access): call it off the main thread.
 */
public class StartDestinationResolver {

    private final SessionManager sessionManager;
    private final OnboardingProgressDao progressDao;

    @Inject
    public StartDestinationResolver(SessionManager sessionManager,
            OnboardingProgressDao progressDao) {
        this.sessionManager = sessionManager;
        this.progressDao = progressDao;
    }

    public StartDestination resolve() {
        if (!sessionManager.hasSession()) {
            return StartDestination.onboarding();
        }
        OnboardingProgressEntity entity = progressDao.get();
        OnboardingStep step = OnboardingStep.fromName(entity == null ? null : entity.step);
        switch (step) {
            case COMPLETED:
                return StartDestination.home();
            case NAME:
            case LOCATION:
            case INTERESTS:
                return StartDestination.resumeOnboarding(deepLinkFor(step));
            default:
                // Signed in but no later step was saved: the first authenticated step.
                return StartDestination.resumeOnboarding(deepLinkFor(OnboardingStep.CONSENTS));
        }
    }

    private static String deepLinkFor(OnboardingStep step) {
        return DeepLinks.onboardingStep(step.name().toLowerCase(Locale.ROOT));
    }
}
