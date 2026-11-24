package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code TokenPair} schema. */
public class TokenPairDto {

    @SerializedName("accessToken")
    public String accessToken;

    @SerializedName("refreshToken")
    public String refreshToken;

    @SerializedName("expiresInSeconds")
    public Integer expiresInSeconds;
}
