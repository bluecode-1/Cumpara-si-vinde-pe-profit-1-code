package ro.profitnet.app.feature.onboarding.domain.model;

import java.util.Objects;

import ro.profitnet.app.core.model.OtpChallenge;

/** A code that was sent: the normalized phone number and the server's challenge. */
public final class OtpRequest {

    private final String phone;
    private final OtpChallenge challenge;

    public OtpRequest(String phone, OtpChallenge challenge) {
        this.phone = Objects.requireNonNull(phone, "phone");
        this.challenge = Objects.requireNonNull(challenge, "challenge");
    }

    /** Phone number in E.164. */
    public String getPhone() {
        return phone;
    }

    public OtpChallenge getChallenge() {
        return challenge;
    }
}
