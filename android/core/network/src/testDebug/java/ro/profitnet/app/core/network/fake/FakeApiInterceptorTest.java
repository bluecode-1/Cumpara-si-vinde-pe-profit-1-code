package ro.profitnet.app.core.network.fake;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import com.google.gson.Gson;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import org.junit.Before;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.network.ApiCaller;
import ro.profitnet.app.core.network.AuthInterceptor;
import ro.profitnet.app.core.network.Fixtures;
import ro.profitnet.app.core.network.InMemoryTokenStore;
import ro.profitnet.app.core.network.ProblemJsonParser;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.api.CatalogApi;
import ro.profitnet.app.core.network.api.MeApi;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.CategoryDto;
import ro.profitnet.app.core.network.dto.ConsentDto;
import ro.profitnet.app.core.network.dto.ConsentUpdateDto;
import ro.profitnet.app.core.network.dto.GeoPointDto;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.dto.MeUpdateDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.OtpRequestDto;
import ro.profitnet.app.core.network.dto.OtpVerifyRequestDto;
import ro.profitnet.app.core.network.dto.RefreshRequestDto;
import ro.profitnet.app.core.network.dto.TokenPairDto;
import ro.profitnet.app.core.security.SessionManager;

/** The demo-mode rules of spec section 5, exercised through the real Retrofit interfaces. */
public class FakeApiInterceptorTest {

    private SessionManager sessionManager;
    private FakeApiInterceptor fake;
    private AuthApi authApi;
    private MeApi meApi;
    private CatalogApi catalogApi;
    private ApiCaller apiCaller;

    @Before
    public void setUp() {
        sessionManager = new SessionManager(new InMemoryTokenStore());
        fake = new FakeApiInterceptor(Fixtures::read, 0);
        Gson gson = new Gson();
        OkHttpClient client = new OkHttpClient.Builder()
                .addInterceptor(new AuthInterceptor(sessionManager))
                .addInterceptor(fake)
                .build();
        Retrofit retrofit = new Retrofit.Builder()
                // Unresolvable on purpose: the fake must answer before any network access.
                .baseUrl("https://api.profitnet.invalid/v1/")
                .client(client)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();
        authApi = retrofit.create(AuthApi.class);
        meApi = retrofit.create(MeApi.class);
        catalogApi = retrofit.create(CatalogApi.class);
        apiCaller = new ApiCaller(new ProblemJsonParser(gson));
    }

    private void signIn() {
        AuthSessionDto session = apiCaller.execute(authApi.verifyOtp(
                new OtpVerifyRequestDto("challenge", FakeApiInterceptor.VALID_CODE))).getValue();
        sessionManager.saveTokens(session.accessToken, session.refreshToken);
    }

    @Test
    public void anyPhoneGetsTheCodeSentResponse() {
        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto("+40799999999")));

        assertTrue(result.isSuccess());
        assertEquals("0193f6a0-1c2d-7b3a-9e4f-5a6b7c8d9e01", result.getValue().challengeId);
        assertEquals(Integer.valueOf(30), result.getValue().retryAfterSeconds);
    }

    @Test
    public void code123456SignsIn() {
        Result<AuthSessionDto> result = apiCaller.execute(
                authApi.verifyOtp(new OtpVerifyRequestDto("challenge", "123456")));

        assertTrue(result.isSuccess());
        assertEquals("fixture.access.token", result.getValue().accessToken);
        assertEquals(Boolean.TRUE, result.getValue().isNewUser);
        assertEquals(Boolean.FALSE, result.getValue().user.onboardingCompleted);
    }

    @Test
    public void anyOtherCodeIsOtpInvalid422() {
        for (String code : Arrays.asList("000000", "654321", "12345", "")) {
            Result<AuthSessionDto> result = apiCaller.execute(
                    authApi.verifyOtp(new OtpVerifyRequestDto("challenge", code)));

            assertEquals(code, new AppError(AppError.CODE_OTP_INVALID, 422), result.getError());
        }
    }

    @Test
    public void refreshReturnsTheFixturePair() {
        Result<TokenPairDto> result =
                apiCaller.execute(authApi.refresh(new RefreshRequestDto("fixture-refresh-token-1")));

        assertEquals("fixture.access.token.2", result.getValue().accessToken);
    }

    @Test
    public void categoriesArePublic() {
        Result<List<CategoryDto>> result = apiCaller.execute(catalogApi.listCategories());

        assertEquals(8, result.getValue().size());
    }

    @Test
    public void authenticatedEndpointsRejectMissingToken() {
        assertEquals(new AppError(AppError.CODE_UNAUTHORIZED, 401),
                apiCaller.execute(meApi.getMe()).getError());
        assertEquals(401, apiCaller.executeEmpty(authApi.logout()).getError().getHttpStatus());
    }

    @Test
    public void patchMeKeepsChangesInMemory() {
        signIn();
        MeUpdateDto name = new MeUpdateDto();
        name.displayName = "Ioana";
        MeDto afterName = apiCaller.execute(meApi.updateMe(name)).getValue();
        assertEquals("Ioana", afterName.displayName);

        MeUpdateDto finish = new MeUpdateDto();
        finish.homeLocation = new GeoPointDto(46.77, 23.6);
        finish.interestCategoryIds = Arrays.asList("a", "b");
        finish.onboardingCompleted = true;
        apiCaller.execute(meApi.updateMe(finish));

        MeDto me = apiCaller.execute(meApi.getMe()).getValue();
        assertEquals("Ioana", me.displayName);
        assertEquals(Double.valueOf(46.77), me.homeLocation.lat);
        assertEquals(Double.valueOf(23.6), me.homeLocation.lng);
        assertEquals(Boolean.TRUE, me.onboardingCompleted);
        assertEquals("+40712345678", me.phone);
        assertEquals(2, fake.getInterestCategoryIds().size());

        // Signing in again in the same run returns the updated, onboarded account.
        AuthSessionDto again = apiCaller.execute(
                authApi.verifyOtp(new OtpVerifyRequestDto("challenge", "123456"))).getValue();
        assertEquals(Boolean.TRUE, again.user.onboardingCompleted);
        assertEquals(Boolean.FALSE, again.isNewUser);
    }

    @Test
    public void putConsentsKeepsChangesInMemory() {
        signIn();
        for (ConsentDto consent : apiCaller.execute(meApi.listConsents()).getValue()) {
            assertFalse(consent.purpose, consent.granted);
        }

        Result<Void> put = apiCaller.executeEmpty(meApi.setConsents(Arrays.asList(
                new ConsentUpdateDto("TERMS", true, "2026-11"),
                new ConsentUpdateDto("PRIVACY", true, "2026-11"),
                new ConsentUpdateDto("MARKETING", false, "2026-11"))));
        assertTrue(put.isSuccess());

        List<ConsentDto> consents = apiCaller.execute(meApi.listConsents()).getValue();
        assertEquals(6, consents.size());
        for (ConsentDto consent : consents) {
            boolean expected = "TERMS".equals(consent.purpose) || "PRIVACY".equals(consent.purpose);
            assertEquals(consent.purpose, expected, consent.granted);
            assertEquals("2026-11", consent.policyVersion);
        }

        apiCaller.executeEmpty(meApi.setConsents(
                Collections.singletonList(new ConsentUpdateDto("LOCATION", true, "2026-11"))));
        long granted = apiCaller.execute(meApi.listConsents()).getValue().stream()
                .filter(consent -> consent.granted).count();
        assertEquals(3, granted);
    }

    @Test
    public void logoutSucceedsWithToken() {
        signIn();

        assertTrue(apiCaller.executeEmpty(authApi.logout()).isSuccess());
    }
}
