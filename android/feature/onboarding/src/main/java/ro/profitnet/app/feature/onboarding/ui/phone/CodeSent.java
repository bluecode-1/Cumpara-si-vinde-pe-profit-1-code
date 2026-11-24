package ro.profitnet.app.feature.onboarding.ui.phone;

import java.util.Objects;

/** One-shot event: a code was sent, continue to the code screen with these arguments. */
public final class CodeSent {

    private final String phone;
    private final String challengeId;
    private final int retryAfterSeconds;

    public CodeSent(String phone, String challengeId, int retryAfterSeconds) {
        this.phone = Objects.requireNonNull(phone, "phone");
        this.challengeId = Objects.requireNonNull(challengeId, "challengeId");
        this.retryAfterSeconds = retryAfterSeconds;
    }

    /** Phone number in E.164. */
    public String getPhone() {
        return phone;
    }

    public String getChallengeId() {
        return challengeId;
    }

    public int getRetryAfterSeconds() {
        return retryAfterSeconds;
    }
}
