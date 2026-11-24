package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/** The {@code Me} schema ({@code PublicUser} plus the private fields). */
public final class MeDto {

    @SerializedName("id")
    public String id;

    @SerializedName("displayName")
    public String displayName;

    @SerializedName("avatarUrl")
    public String avatarUrl;

    @SerializedName("city")
    public String city;

    @SerializedName("verificationTier")
    public String verificationTier;

    @SerializedName("sellerType")
    public String sellerType;

    @SerializedName("badges")
    public List<BadgeDto> badges;

    @SerializedName("completedTransactions")
    public Integer completedTransactions;

    @SerializedName("memberSince")
    public String memberSince;

    @SerializedName("traderInfo")
    public TraderInfoDto traderInfo;

    @SerializedName("phone")
    public String phone;

    @SerializedName("email")
    public String email;

    @SerializedName("emailVerified")
    public Boolean emailVerified;

    @SerializedName("locale")
    public String locale;

    @SerializedName("currency")
    public String currency;

    @SerializedName("homeLocation")
    public GeoPointDto homeLocation;

    @SerializedName("limits")
    public LimitsDto limits;

    @SerializedName("onboardingCompleted")
    public Boolean onboardingCompleted;
}
