package ro.profitnet.app.feature.onboarding.domain;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.OtpChallenge;

/** Phone sign-in. Methods block; call them from a background executor. */
public interface AuthRepository {

    /** @param phone phone number in E.164. */
    Result<OtpChallenge> requestOtp(String phone);

    /** Exchanges the code for a session; on success the tokens are stored securely. */
    Result<AuthSession> verifyOtp(String challengeId, String code);
}
