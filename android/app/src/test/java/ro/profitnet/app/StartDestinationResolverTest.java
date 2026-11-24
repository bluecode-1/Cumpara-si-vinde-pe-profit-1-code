package ro.profitnet.app;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Test;

import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;
import ro.profitnet.app.core.security.SessionManager;
import ro.profitnet.app.core.security.TokenStore;

public class StartDestinationResolverTest {

    private final TokenStore tokenStore = mock(TokenStore.class);
    private final OnboardingProgressDao dao = mock(OnboardingProgressDao.class);
    private final StartDestinationResolver resolver =
            new StartDestinationResolver(new SessionManager(tokenStore), dao);

    private void givenSession() {
        when(tokenStore.getRefreshToken()).thenReturn("refresh");
    }

    private void givenStep(String step) {
        when(dao.get()).thenReturn(new OnboardingProgressEntity(0, step, null, null, 0L));
    }

    @Test
    public void noSessionStartsOnboardingEvenIfProgressExists() {
        when(tokenStore.getRefreshToken()).thenReturn(null);
        givenStep("COMPLETED");

        assertEquals(StartDestination.onboarding(), resolver.resolve());
        verify(dao, never()).get();
    }

    @Test
    public void sessionWithCompletedOnboardingOpensHome() {
        givenSession();
        givenStep("COMPLETED");

        assertEquals(StartDestination.home(), resolver.resolve());
    }

    @Test
    public void sessionWithUnfinishedOnboardingResumesAtSavedStep() {
        givenSession();
        for (String step : new String[] {"consents", "name", "location", "interests"}) {
            givenStep(step.toUpperCase(java.util.Locale.ROOT));

            assertEquals(StartDestination.resumeOnboarding("profitnet://onboarding/" + step),
                    resolver.resolve());
        }
    }

    @Test
    public void sessionWithoutUsableProgressResumesAtConsents() {
        givenSession();
        StartDestination consents =
                StartDestination.resumeOnboarding("profitnet://onboarding/consents");

        when(dao.get()).thenReturn(null);
        assertEquals(consents, resolver.resolve());

        givenStep("CODE");
        assertEquals(consents, resolver.resolve());

        givenStep("SOMETHING_FROM_A_NEWER_VERSION");
        assertEquals(consents, resolver.resolve());
    }
}
