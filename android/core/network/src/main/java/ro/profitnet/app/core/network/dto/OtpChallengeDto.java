package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** Response of {@code POST /auth/otp/request} (202). */
public final class OtpChallengeDto {

    @SerializedName("challengeId")
    public String challengeId;

    @SerializedName("retryAfterSeconds")
    public Integer retryAfterSeconds;
}
