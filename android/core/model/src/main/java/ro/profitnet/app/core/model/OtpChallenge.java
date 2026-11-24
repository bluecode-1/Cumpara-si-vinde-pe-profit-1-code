package ro.profitnet.app.core.model;

import java.util.Objects;

/** A pending SMS code challenge. */
public final class OtpChallenge {

    private final String challengeId;
    private final int retryAfterSeconds;

    public OtpChallenge(String challengeId, int retryAfterSeconds) {
        this.challengeId = Objects.requireNonNull(challengeId, "challengeId");
        this.retryAfterSeconds = Math.max(0, retryAfterSeconds);
    }

    public String getChallengeId() {
        return challengeId;
    }

    /** Seconds the user must wait before asking for another code. */
    public int getRetryAfterSeconds() {
        return retryAfterSeconds;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof OtpChallenge)) {
            return false;
        }
        OtpChallenge other = (OtpChallenge) o;
        return retryAfterSeconds == other.retryAfterSeconds
                && challengeId.equals(other.challengeId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(challengeId, retryAfterSeconds);
    }
}
