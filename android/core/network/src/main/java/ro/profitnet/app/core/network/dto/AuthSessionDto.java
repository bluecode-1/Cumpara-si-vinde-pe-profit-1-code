package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code AuthSession} schema: a token pair plus the account. */
public final class AuthSessionDto extends TokenPairDto {

    @SerializedName("user")
    public MeDto user;

    @SerializedName("isNewUser")
    public Boolean isNewUser;
}
