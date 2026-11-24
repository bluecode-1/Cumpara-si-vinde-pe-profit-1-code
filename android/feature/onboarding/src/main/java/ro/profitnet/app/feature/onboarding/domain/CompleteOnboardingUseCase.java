package ro.profitnet.app.feature.onboarding.domain;

import java.util.ArrayList;
import java.util.Collection;

import javax.inject.Inject;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/** Saves the chosen interests (possibly none, when skipped) and completes onboarding. */
public class CompleteOnboardingUseCase {

    private final ProfileRepository profileRepository;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public CompleteOnboardingUseCase(ProfileRepository profileRepository,
            OnboardingProgressRepository progressRepository) {
        this.profileRepository = profileRepository;
        this.progressRepository = progressRepository;
    }

    public Result<Void> execute(Collection<String> interestCategoryIds) {
        Result<User> result =
                profileRepository.completeOnboarding(new ArrayList<>(interestCategoryIds));
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        progressRepository.save(progressRepository.load().withStep(OnboardingStep.COMPLETED));
        return Result.success(null);
    }
}
