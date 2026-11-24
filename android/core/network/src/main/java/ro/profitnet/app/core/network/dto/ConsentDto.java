package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code Consent} schema. */
public final class ConsentDto {

    @SerializedName("purpose")
    public String purpose;

    @SerializedName("granted")
    public Boolean granted;

    @SerializedName("policyVersion")
    public String policyVersion;

    @SerializedName("updatedAt")
    public String updatedAt;
}
