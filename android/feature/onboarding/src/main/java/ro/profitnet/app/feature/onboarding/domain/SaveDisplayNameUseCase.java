package ro.profitnet.app.feature.onboarding.domain;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.DisplayNameValidator;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/**
 * Validates (2–40 characters) and saves the display name. An invalid name fails with
 * {@link OnboardingErrors#NAME_INVALID} without any server call.
 */
public class SaveDisplayNameUseCase {

    private final ProfileRepository profileRepository;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public SaveDisplayNameUseCase(ProfileRepository profileRepository,
            OnboardingProgressRepository progressRepository) {
        this.profileRepository = profileRepository;
        this.progressRepository = progressRepository;
    }

    public Result<Void> execute(String nameInput) {
        String name = DisplayNameValidator.normalize(nameInput);
        if (name == null) {
            return Result.failure(AppError.local(OnboardingErrors.NAME_INVALID));
        }
        Result<User> result = profileRepository.updateDisplayName(name);
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        progressRepository.save(progressRepository.load()
                .withDisplayName(name)
                .withStep(OnboardingStep.LOCATION));
        return Result.success(null);
    }
}
