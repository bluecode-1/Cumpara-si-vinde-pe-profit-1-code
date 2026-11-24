package ro.profitnet.app.feature.onboarding.domain;

import ro.profitnet.app.feature.onboarding.domain.model.OnboardingProgress;

/** Local persistence of the flow's progress. Methods block; call them off the main thread. */
public interface OnboardingProgressRepository {

    /** @return the saved progress, or {@link OnboardingProgress#initial()} if none. */
    OnboardingProgress load();

    void save(OnboardingProgress progress);
}
