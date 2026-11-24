package ro.profitnet.app.core.network.mapper;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.Money;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.core.model.SellerType;
import ro.profitnet.app.core.model.TokenPair;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.core.model.UserLimits;
import ro.profitnet.app.core.model.VerificationTier;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.CategoryDto;
import ro.profitnet.app.core.network.dto.ConsentDto;
import ro.profitnet.app.core.network.dto.ConsentUpdateDto;
import ro.profitnet.app.core.network.dto.GeoPointDto;
import ro.profitnet.app.core.network.dto.LimitsDto;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.dto.MoneyDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.TokenPairDto;

/**
 * DTO to domain mapping. Each method returns {@code null} when a field the contract marks as
 * required is missing, so callers can report a contract violation instead of crashing.
 * Unknown enum values (added by a newer server) are tolerated.
 */
public final class ModelMappers {

    private ModelMappers() {
    }

    @Nullable
    public static OtpChallenge toOtpChallenge(@Nullable OtpChallengeDto dto) {
        if (dto == null || dto.challengeId == null) {
            return null;
        }
        return new OtpChallenge(dto.challengeId,
                dto.retryAfterSeconds == null ? 0 : dto.retryAfterSeconds);
    }

    @Nullable
    public static TokenPair toTokenPair(@Nullable TokenPairDto dto) {
        if (dto == null || dto.accessToken == null || dto.refreshToken == null) {
            return null;
        }
        return new TokenPair(dto.accessToken, dto.refreshToken,
                dto.expiresInSeconds == null ? 0 : dto.expiresInSeconds);
    }

    @Nullable
    public static AuthSession toAuthSession(@Nullable AuthSessionDto dto) {
        TokenPair tokens = toTokenPair(dto);
        User user = dto == null ? null : toUser(dto.user);
        if (tokens == null || user == null) {
            return null;
        }
        return new AuthSession(tokens, user, Boolean.TRUE.equals(dto.isNewUser));
    }

    @Nullable
    public static User toUser(@Nullable MeDto dto) {
        if (dto == null || dto.id == null) {
            return null;
        }
        return User.builder(dto.id)
                .displayName(dto.displayName)
                .phone(dto.phone)
                .city(dto.city)
                .locale(dto.locale)
                .currency(dto.currency)
                .verificationTier(enumOrNull(VerificationTier.class, dto.verificationTier))
                .sellerType(enumOrNull(SellerType.class, dto.sellerType))
                .homeLocation(toGeoPoint(dto.homeLocation))
                .limits(toLimits(dto.limits))
                .onboardingCompleted(Boolean.TRUE.equals(dto.onboardingCompleted))
                .build();
    }

    @Nullable
    public static GeoPoint toGeoPoint(@Nullable GeoPointDto dto) {
        if (dto == null || dto.lat == null || dto.lng == null) {
            return null;
        }
        try {
            return new GeoPoint(dto.lat, dto.lng);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    public static GeoPointDto toDto(GeoPoint point) {
        return new GeoPointDto(point.getLat(), point.getLng());
    }

    @Nullable
    private static UserLimits toLimits(@Nullable LimitsDto dto) {
        if (dto == null) {
            return null;
        }
        Money maxTransaction = toMoney(dto.maxTransaction);
        Money monthlyVolume = toMoney(dto.monthlyVolume);
        if (maxTransaction == null || monthlyVolume == null) {
            return null;
        }
        return new UserLimits(maxTransaction, monthlyVolume);
    }

    @Nullable
    public static Money toMoney(@Nullable MoneyDto dto) {
        if (dto == null || dto.amountMinor == null || dto.currency == null
                || dto.amountMinor < 0) {
            return null;
        }
        return new Money(dto.amountMinor, dto.currency);
    }

    /** Entries with missing required fields or an unknown purpose are skipped. */
    public static List<Consent> toConsents(@Nullable List<ConsentDto> dtos) {
        List<Consent> consents = new ArrayList<>();
        if (dtos == null) {
            return consents;
        }
        for (ConsentDto dto : dtos) {
            if (dto == null || dto.granted == null || dto.policyVersion == null) {
                continue;
            }
            ConsentPurpose purpose = enumOrNull(ConsentPurpose.class, dto.purpose);
            if (purpose != null) {
                consents.add(new Consent(purpose, dto.granted, dto.policyVersion, dto.updatedAt));
            }
        }
        return consents;
    }

    public static List<ConsentUpdateDto> toConsentUpdates(List<Consent> consents) {
        List<ConsentUpdateDto> dtos = new ArrayList<>(consents.size());
        for (Consent consent : consents) {
            dtos.add(new ConsentUpdateDto(consent.getPurpose().name(), consent.isGranted(),
                    consent.getPolicyVersion()));
        }
        return dtos;
    }

    /** Entries with missing required fields are skipped. */
    public static List<Category> toCategories(@Nullable List<CategoryDto> dtos) {
        List<Category> categories = new ArrayList<>();
        if (dtos == null) {
            return categories;
        }
        for (CategoryDto dto : dtos) {
            if (dto == null || dto.id == null || dto.slug == null || dto.name == null) {
                continue;
            }
            categories.add(new Category(dto.id, dto.parentId, dto.slug, dto.name, dto.iconKey,
                    Boolean.TRUE.equals(dto.isVehicle)));
        }
        return categories;
    }

    @Nullable
    private static <E extends Enum<E>> E enumOrNull(Class<E> type, @Nullable String name) {
        if (name == null) {
            return null;
        }
        try {
            return Enum.valueOf(type, name);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
