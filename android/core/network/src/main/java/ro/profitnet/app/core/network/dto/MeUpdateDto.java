package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * The {@code MeUpdate} schema, body of {@code PATCH /me}. Fields left {@code null} are omitted
 * from the JSON, so only the set fields are changed.
 */
public final class MeUpdateDto {

    @SerializedName("displayName")
    public String displayName;

    @SerializedName("avatarMediaId")
    public String avatarMediaId;

    @SerializedName("locale")
    public String locale;

    @SerializedName("currency")
    public String currency;

    @SerializedName("homeLocation")
    public GeoPointDto homeLocation;

    @SerializedName("interestCategoryIds")
    public List<String> interestCategoryIds;

    @SerializedName("onboardingCompleted")
    public Boolean onboardingCompleted;
}
