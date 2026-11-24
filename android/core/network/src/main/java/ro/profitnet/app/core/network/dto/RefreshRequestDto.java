package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** Body of {@code POST /auth/refresh}. */
public final class RefreshRequestDto {

    @SerializedName("refreshToken")
    public final String refreshToken;

    public RefreshRequestDto(String refreshToken) {
        this.refreshToken = refreshToken;
    }
}
