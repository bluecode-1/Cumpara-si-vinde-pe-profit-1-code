package ro.profitnet.app.feature.onboarding.domain;

import javax.inject.Inject;

import ro.profitnet.app.feature.onboarding.domain.model.OnboardingProgress;

/** Reads the locally saved progress (e.g. to prefill the phone number). */
public class GetOnboardingProgressUseCase {

    private final OnboardingProgressRepository progressRepository;

    @Inject
    public GetOnboardingProgressUseCase(OnboardingProgressRepository progressRepository) {
        this.progressRepository = progressRepository;
    }

    public OnboardingProgress execute() {
        return progressRepository.load();
    }
}
