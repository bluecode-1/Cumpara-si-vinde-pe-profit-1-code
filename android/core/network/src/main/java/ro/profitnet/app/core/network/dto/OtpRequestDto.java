package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** Body of {@code POST /auth/otp/request}. */
public final class OtpRequestDto {

    @SerializedName("phone")
    public final String phone;

    public OtpRequestDto(String phone) {
        this.phone = phone;
    }
}
