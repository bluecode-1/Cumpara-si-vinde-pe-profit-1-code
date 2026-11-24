package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code Money} schema. */
public final class MoneyDto {

    @SerializedName("amountMinor")
    public Long amountMinor;

    @SerializedName("currency")
    public String currency;
}
