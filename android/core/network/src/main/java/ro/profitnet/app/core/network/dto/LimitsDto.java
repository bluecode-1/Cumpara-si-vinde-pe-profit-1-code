package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code Me.limits} object. */
public final class LimitsDto {

    @SerializedName("maxTransaction")
    public MoneyDto maxTransaction;

    @SerializedName("monthlyVolume")
    public MoneyDto monthlyVolume;
}
