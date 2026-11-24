package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** One item of the {@code PUT /me/consents} body. */
public final class ConsentUpdateDto {

    @SerializedName("purpose")
    public final String purpose;

    @SerializedName("granted")
    public final boolean granted;

    @SerializedName("policyVersion")
    public final String policyVersion;

    public ConsentUpdateDto(String purpose, boolean granted, String policyVersion) {
        this.purpose = purpose;
        this.granted = granted;
        this.policyVersion = policyVersion;
    }
}
