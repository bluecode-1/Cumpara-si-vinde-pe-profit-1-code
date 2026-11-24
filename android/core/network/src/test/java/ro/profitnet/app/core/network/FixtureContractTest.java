package ro.profitnet.app.core.network;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.annotations.SerializedName;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.Money;
import ro.profitnet.app.core.model.SellerType;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.core.model.VerificationTier;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.CategoryDto;
import ro.profitnet.app.core.network.dto.ConsentDto;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.ProblemDto;
import ro.profitnet.app.core.network.dto.TokenPairDto;
import ro.profitnet.app.core.network.mapper.ModelMappers;

/**
 * Contract tests: every fixture in {@code api/fixtures} must decode into the hand-written DTOs
 * (same fixtures as the Flutter and iOS suites). Besides spot-checking values, each test
 * verifies that the DTO declares every property present in the fixture, so a field added to
 * the contract cannot be silently dropped by the client.
 */
public class FixtureContractTest {

    private static final Type CONSENT_LIST = new TypeToken<List<ConsentDto>>() { }.getType();
    private static final Type CATEGORY_LIST = new TypeToken<List<CategoryDto>>() { }.getType();

    /** Fixture file name to the type it must decode into. */
    private static final Map<String, Type> FIXTURE_TYPES = new HashMap<>();

    static {
        FIXTURE_TYPES.put("auth_otp_request.202.json", OtpChallengeDto.class);
        FIXTURE_TYPES.put("auth_otp_verify.200.json", AuthSessionDto.class);
        FIXTURE_TYPES.put("auth_refresh.200.json", TokenPairDto.class);
        FIXTURE_TYPES.put("categories.200.json", CATEGORY_LIST);
        FIXTURE_TYPES.put("me.new.200.json", MeDto.class);
        FIXTURE_TYPES.put("me.onboarded.200.json", MeDto.class);
        FIXTURE_TYPES.put("me_consents.200.json", CONSENT_LIST);
        FIXTURE_TYPES.put("problem_otp_invalid.422.json", ProblemDto.class);
        FIXTURE_TYPES.put("problem_rate_limited.429.json", ProblemDto.class);
    }

    private final Gson gson = new Gson();

    @Test
    public void everyFixtureFileIsCoveredByAContractTest() throws IOException {
        Set<String> onDisk;
        try (Stream<Path> files = Files.list(Fixtures.directory())) {
            onDisk = files.map(path -> path.getFileName().toString())
                    .filter(name -> name.endsWith(".json"))
                    .collect(Collectors.toSet());
        }
        assertFalse("No fixtures found in " + Fixtures.directory(), onDisk.isEmpty());
        assertEquals("A fixture was added or removed: update FIXTURE_TYPES and the DTOs",
                FIXTURE_TYPES.keySet(), onDisk);
    }

    @Test
    public void everyFixtureDecodesAndDtosDeclareAllFixtureProperties() throws IOException {
        for (Map.Entry<String, Type> entry : FIXTURE_TYPES.entrySet()) {
            String json = Fixtures.read(entry.getKey());
            assertNotNull(entry.getKey(), gson.fromJson(json, entry.getValue()));
            assertDeclared(entry.getKey(), JsonParser.parseString(json), entry.getValue());
        }
    }

    @Test
    public void otpRequestResponse() throws IOException {
        OtpChallengeDto dto = decode("auth_otp_request.202.json", OtpChallengeDto.class);

        assertEquals("0193f6a0-1c2d-7b3a-9e4f-5a6b7c8d9e01", dto.challengeId);
        assertEquals(Integer.valueOf(30), dto.retryAfterSeconds);
        assertEquals(30, ModelMappers.toOtpChallenge(dto).getRetryAfterSeconds());
    }

    @Test
    public void otpVerifyResponse() throws IOException {
        AuthSessionDto dto = decode("auth_otp_verify.200.json", AuthSessionDto.class);

        assertEquals("fixture.access.token", dto.accessToken);
        assertEquals("fixture-refresh-token-1", dto.refreshToken);
        assertEquals(Integer.valueOf(900), dto.expiresInSeconds);
        assertEquals(Boolean.TRUE, dto.isNewUser);
        assertNotNull(dto.user);
        assertEquals("+40712345678", dto.user.phone);

        AuthSession session = ModelMappers.toAuthSession(dto);
        assertNotNull(session);
        assertTrue(session.isNewUser());
        assertEquals("fixture.access.token", session.getTokens().getAccessToken());
        assertFalse(session.getUser().isOnboardingCompleted());
        assertEquals("", session.getUser().getDisplayName());
    }

    @Test
    public void refreshResponse() throws IOException {
        TokenPairDto dto = decode("auth_refresh.200.json", TokenPairDto.class);

        assertEquals("fixture.access.token.2", dto.accessToken);
        assertEquals("fixture-refresh-token-2", dto.refreshToken);
        assertEquals(900, ModelMappers.toTokenPair(dto).getExpiresInSeconds());
    }

    @Test
    public void newUser() throws IOException {
        MeDto dto = decode("me.new.200.json", MeDto.class);

        assertEquals("0193f6a0-2a00-7000-8000-000000000001", dto.id);
        assertEquals("", dto.displayName);
        assertNull(dto.avatarUrl);
        assertNull(dto.city);
        assertNull(dto.homeLocation);
        assertNull(dto.traderInfo);
        assertNull(dto.email);
        assertEquals(Boolean.FALSE, dto.emailVerified);
        assertEquals("2026-11-23", dto.memberSince);
        assertEquals(Integer.valueOf(0), dto.completedTransactions);
        assertTrue(dto.badges.isEmpty());
        assertEquals(Boolean.FALSE, dto.onboardingCompleted);

        User user = ModelMappers.toUser(dto);
        assertNotNull(user);
        assertEquals(VerificationTier.PHONE, user.getVerificationTier());
        assertEquals(SellerType.OCCASIONAL, user.getSellerType());
        assertEquals("ro", user.getLocale());
        assertEquals("RON", user.getCurrency());
        assertEquals(new Money(150000, "RON"), user.getLimits().getMaxTransaction());
        assertEquals(new Money(500000, "RON"), user.getLimits().getMonthlyVolume());
        assertNull(user.getHomeLocation());
    }

    @Test
    public void onboardedUser() throws IOException {
        MeDto dto = decode("me.onboarded.200.json", MeDto.class);

        assertEquals(2, dto.badges.size());
        assertEquals("PUNCTUAL", dto.badges.get(0).attribute);
        assertEquals(Integer.valueOf(23), dto.badges.get(0).confirmations);
        assertEquals(Integer.valueOf(34), dto.completedTransactions);

        User user = ModelMappers.toUser(dto);
        assertNotNull(user);
        assertEquals("Ioana", user.getDisplayName());
        assertEquals("Cluj-Napoca", user.getCity());
        assertEquals(new GeoPoint(46.77, 23.6), user.getHomeLocation());
        assertTrue(user.isOnboardingCompleted());
    }

    @Test
    public void consents() throws IOException {
        List<ConsentDto> dtos = gson.fromJson(Fixtures.read("me_consents.200.json"), CONSENT_LIST);

        assertEquals(6, dtos.size());
        List<Consent> consents = ModelMappers.toConsents(dtos);
        assertEquals(6, consents.size());
        Set<ConsentPurpose> purposes = new HashSet<>();
        for (Consent consent : consents) {
            purposes.add(consent.getPurpose());
            assertEquals("2026-11", consent.getPolicyVersion());
            assertEquals("2026-11-23T10:00:00Z", consent.getUpdatedAt());
        }
        assertEquals(new HashSet<>(Arrays.asList(ConsentPurpose.values())), purposes);
        assertTrue(consents.get(0).isGranted());
        assertEquals(ConsentPurpose.MARKETING, consents.get(2).getPurpose());
        assertFalse(consents.get(2).isGranted());
    }

    @Test
    public void categories() throws IOException {
        List<CategoryDto> dtos = gson.fromJson(Fixtures.read("categories.200.json"), CATEGORY_LIST);

        assertEquals(8, dtos.size());
        List<Category> categories = ModelMappers.toCategories(dtos);
        assertEquals(8, categories.size());
        Category first = categories.get(0);
        assertEquals("0193f6a0-3c00-7000-8000-000000000001", first.getId());
        assertEquals("haine", first.getSlug());
        assertEquals("Haine și încălțăminte", first.getName());
        assertEquals("clothing", first.getIconKey());
        assertTrue(first.isTopLevel());
        assertFalse(first.isVehicle());
        assertTrue(categories.get(7).isVehicle());
    }

    @Test
    public void otpInvalidProblem() throws IOException {
        String json = Fixtures.read("problem_otp_invalid.422.json");
        ProblemDto dto = gson.fromJson(json, ProblemDto.class);

        assertEquals("OTP_INVALID", dto.code);
        assertEquals(Integer.valueOf(422), dto.status);
        assertEquals("https://api.profitnet.example/problems/otp-invalid", dto.type);
        assertEquals(new AppError(AppError.CODE_OTP_INVALID, 422),
                new ProblemJsonParser(gson).parse(422, json));
    }

    @Test
    public void rateLimitedProblem() throws IOException {
        String json = Fixtures.read("problem_rate_limited.429.json");
        ProblemDto dto = gson.fromJson(json, ProblemDto.class);

        assertEquals("RATE_LIMITED", dto.code);
        assertEquals(Integer.valueOf(429), dto.status);
        assertEquals(new AppError(AppError.CODE_RATE_LIMITED, 429),
                new ProblemJsonParser(gson).parse(429, json));
    }

    private <T> T decode(String fileName, Class<T> type) throws IOException {
        T value = gson.fromJson(Fixtures.read(fileName), type);
        assertNotNull(fileName, value);
        return value;
    }

    /** Fails if the JSON contains a property that the target type does not declare. */
    private static void assertDeclared(String where, JsonElement json, Type type) {
        if (json.isJsonArray()) {
            Type elementType = Object.class;
            if (type instanceof ParameterizedType) {
                elementType = ((ParameterizedType) type).getActualTypeArguments()[0];
            }
            JsonArray array = json.getAsJsonArray();
            for (int i = 0; i < array.size(); i++) {
                assertDeclared(where + "[" + i + "]", array.get(i), elementType);
            }
        } else if (json.isJsonObject() && type instanceof Class) {
            Map<String, Field> fields = serializedFields((Class<?>) type);
            for (Map.Entry<String, JsonElement> entry : json.getAsJsonObject().entrySet()) {
                Field field = fields.get(entry.getKey());
                if (field == null) {
                    fail(where + ": property '" + entry.getKey() + "' is not declared by "
                            + ((Class<?>) type).getSimpleName());
                }
                assertDeclared(where + "." + entry.getKey(), entry.getValue(),
                        field.getGenericType());
            }
        }
    }

    private static Map<String, Field> serializedFields(Class<?> type) {
        Map<String, Field> fields = new HashMap<>();
        for (Class<?> c = type; c != null && c != Object.class; c = c.getSuperclass()) {
            for (Field field : c.getDeclaredFields()) {
                if (Modifier.isStatic(field.getModifiers())) {
                    continue;
                }
                SerializedName name = field.getAnnotation(SerializedName.class);
                fields.put(name != null ? name.value() : field.getName(), field);
            }
        }
        return fields;
    }
}
