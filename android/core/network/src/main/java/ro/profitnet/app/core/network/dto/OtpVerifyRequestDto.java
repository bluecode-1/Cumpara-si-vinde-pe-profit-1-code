package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** Body of {@code POST /auth/otp/verify}. */
public final class OtpVerifyRequestDto {

    @SerializedName("challengeId")
    public final String challengeId;

    @SerializedName("code")
    public final String code;

    public OtpVerifyRequestDto(String challengeId, String code) {
        this.challengeId = challengeId;
        this.code = code;
    }
}
