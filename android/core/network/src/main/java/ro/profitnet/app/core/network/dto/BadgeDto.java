package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code Badge} schema. */
public final class BadgeDto {

    @SerializedName("attribute")
    public String attribute;

    @SerializedName("confirmations")
    public Integer confirmations;
}
