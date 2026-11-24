package ro.profitnet.app.core.model;

import java.util.Objects;

/** The signed-in user (the {@code Me} schema of the API). Immutable; built with {@link Builder}. */
public final class User {

    private final String id;
    private final String displayName;
    private final String phone;
    private final String city;
    private final String locale;
    private final String currency;
    private final VerificationTier verificationTier;
    private final SellerType sellerType;
    private final GeoPoint homeLocation;
    private final UserLimits limits;
    private final boolean onboardingCompleted;

    private User(Builder builder) {
        this.id = Objects.requireNonNull(builder.id, "id");
        this.displayName = builder.displayName == null ? "" : builder.displayName;
        this.phone = builder.phone;
        this.city = builder.city;
        this.locale = builder.locale;
        this.currency = builder.currency;
        this.verificationTier = builder.verificationTier;
        this.sellerType = builder.sellerType;
        this.homeLocation = builder.homeLocation;
        this.limits = builder.limits;
        this.onboardingCompleted = builder.onboardingCompleted;
    }

    public String getId() {
        return id;
    }

    /** Never {@code null}; empty until the user picks a name during onboarding. */
    public String getDisplayName() {
        return displayName;
    }

    public String getPhone() {
        return phone;
    }

    /** May be {@code null}. */
    public String getCity() {
        return city;
    }

    public String getLocale() {
        return locale;
    }

    public String getCurrency() {
        return currency;
    }

    public VerificationTier getVerificationTier() {
        return verificationTier;
    }

    public SellerType getSellerType() {
        return sellerType;
    }

    /** May be {@code null} until the user sets a home area. */
    public GeoPoint getHomeLocation() {
        return homeLocation;
    }

    /** May be {@code null} if the server did not send limits. */
    public UserLimits getLimits() {
        return limits;
    }

    public boolean isOnboardingCompleted() {
        return onboardingCompleted;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof User)) {
            return false;
        }
        User other = (User) o;
        return onboardingCompleted == other.onboardingCompleted
                && id.equals(other.id)
                && displayName.equals(other.displayName)
                && Objects.equals(phone, other.phone)
                && Objects.equals(city, other.city)
                && Objects.equals(locale, other.locale)
                && Objects.equals(currency, other.currency)
                && verificationTier == other.verificationTier
                && sellerType == other.sellerType
                && Objects.equals(homeLocation, other.homeLocation)
                && Objects.equals(limits, other.limits);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, displayName, phone, city, locale, currency, verificationTier,
                sellerType, homeLocation, limits, onboardingCompleted);
    }

    public static Builder builder(String id) {
        return new Builder(id);
    }

    public static final class Builder {
        private final String id;
        private String displayName;
        private String phone;
        private String city;
        private String locale;
        private String currency;
        private VerificationTier verificationTier;
        private SellerType sellerType;
        private GeoPoint homeLocation;
        private UserLimits limits;
        private boolean onboardingCompleted;

        private Builder(String id) {
            this.id = id;
        }

        public Builder displayName(String value) {
            this.displayName = value;
            return this;
        }

        public Builder phone(String value) {
            this.phone = value;
            return this;
        }

        public Builder city(String value) {
            this.city = value;
            return this;
        }

        public Builder locale(String value) {
            this.locale = value;
            return this;
        }

        public Builder currency(String value) {
            this.currency = value;
            return this;
        }

        public Builder verificationTier(VerificationTier value) {
            this.verificationTier = value;
            return this;
        }

        public Builder sellerType(SellerType value) {
            this.sellerType = value;
            return this;
        }

        public Builder homeLocation(GeoPoint value) {
            this.homeLocation = value;
            return this;
        }

        public Builder limits(UserLimits value) {
            this.limits = value;
            return this;
        }

        public Builder onboardingCompleted(boolean value) {
            this.onboardingCompleted = value;
            return this;
        }

        public User build() {
            return new User(this);
        }
    }
}
