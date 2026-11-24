package ro.profitnet.app.feature.onboarding.domain;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.PhoneNumberNormalizer;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;

/**
 * Validates the phone number and asks the server to send a code. An invalid number fails with
 * {@link OnboardingErrors#PHONE_INVALID} without any server call.
 */
public class RequestOtpUseCase {

    private final AuthRepository authRepository;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public RequestOtpUseCase(AuthRepository authRepository,
            OnboardingProgressRepository progressRepository) {
        this.authRepository = authRepository;
        this.progressRepository = progressRepository;
    }

    public Result<OtpRequest> execute(String phoneInput) {
        String phone = PhoneNumberNormalizer.normalize(phoneInput);
        if (phone == null) {
            return Result.failure(AppError.local(OnboardingErrors.PHONE_INVALID));
        }
        Result<OtpChallenge> result = authRepository.requestOtp(phone);
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        progressRepository.save(progressRepository.load()
                .withPhone(phone)
                .withStep(OnboardingStep.CODE));
        return Result.success(new OtpRequest(phone, result.getValue()));
    }
}
