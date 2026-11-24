package ro.profitnet.app.feature.onboarding.domain;

import java.util.regex.Pattern;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/**
 * Verifies the SMS code. On success the session is stored (by the repository) and the local
 * progress moves to the consents step, or straight to completed for a returning user.
 */
public class VerifyOtpUseCase {

    public static final int CODE_LENGTH = 6;

    private static final Pattern CODE = Pattern.compile("^[0-9]{" + CODE_LENGTH + "}$");

    private final AuthRepository authRepository;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public VerifyOtpUseCase(AuthRepository authRepository,
            OnboardingProgressRepository progressRepository) {
        this.authRepository = authRepository;
        this.progressRepository = progressRepository;
    }

    public static boolean isCompleteCode(String code) {
        return code != null && CODE.matcher(code).matches();
    }

    public Result<AuthSession> execute(String challengeId, String code) {
        if (!isCompleteCode(code)) {
            return Result.failure(AppError.local(AppError.CODE_OTP_INVALID));
        }
        Result<AuthSession> result = authRepository.verifyOtp(challengeId, code);
        if (result.isSuccess()) {
            User user = result.getValue().getUser();
            progressRepository.save(progressRepository.load()
                    .withDisplayName(user.getDisplayName())
                    .withStep(user.isOnboardingCompleted()
                            ? OnboardingStep.COMPLETED
                            : OnboardingStep.CONSENTS));
        }
        return result;
    }
}
