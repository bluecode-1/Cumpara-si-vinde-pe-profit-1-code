package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** DSA traceability data; present only for professional sellers. */
public final class TraderInfoDto {

    @SerializedName("legalName")
    public String legalName;

    @SerializedName("registrationNumber")
    public String registrationNumber;

    @SerializedName("address")
    public String address;

    @SerializedName("contactEmail")
    public String contactEmail;
}
