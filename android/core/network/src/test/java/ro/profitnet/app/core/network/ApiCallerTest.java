package ro.profitnet.app.core.network;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import com.google.gson.Gson;

import java.io.IOException;

import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.OtpRequestDto;
import ro.profitnet.app.core.network.dto.OtpVerifyRequestDto;

public class ApiCallerTest {

    private MockWebServer server;
    private AuthApi authApi;
    private ApiCaller apiCaller;

    @Before
    public void setUp() throws IOException {
        server = new MockWebServer();
        server.start();
        Gson gson = new Gson();
        authApi = new Retrofit.Builder()
                .baseUrl(server.url("/v1/"))
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build()
                .create(AuthApi.class);
        apiCaller = new ApiCaller(new ProblemJsonParser(gson));
    }

    @After
    public void tearDown() throws IOException {
        server.shutdown();
    }

    @Test
    public void successReturnsBodyAndSendsContractRequest() throws Exception {
        server.enqueue(new MockResponse().setResponseCode(202)
                .setBody(Fixtures.read("auth_otp_request.202.json")));

        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto("+40712345678")));

        assertTrue(result.isSuccess());
        assertEquals(Integer.valueOf(30), result.getValue().retryAfterSeconds);
        okhttp3.mockwebserver.RecordedRequest request = server.takeRequest();
        assertEquals("POST", request.getMethod());
        assertEquals("/v1/auth/otp/request", request.getPath());
        assertEquals("{\"phone\":\"+40712345678\"}", request.getBody().readUtf8());
    }

    @Test
    public void problemJsonBecomesAppErrorWithCodeAndStatus() throws Exception {
        server.enqueue(new MockResponse().setResponseCode(422)
                .setHeader("Content-Type", "application/problem+json")
                .setBody(Fixtures.read("problem_otp_invalid.422.json")));

        Result<AuthSessionDto> result =
                apiCaller.execute(authApi.verifyOtp(new OtpVerifyRequestDto("c", "000000")));

        assertEquals(new AppError(AppError.CODE_OTP_INVALID, 422), result.getError());
    }

    @Test
    public void rateLimitProblemIsMapped() throws Exception {
        server.enqueue(new MockResponse().setResponseCode(429)
                .setHeader("Content-Type", "application/problem+json")
                .setBody(Fixtures.read("problem_rate_limited.429.json")));

        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto("+40712345678")));

        assertEquals(new AppError(AppError.CODE_RATE_LIMITED, 429), result.getError());
    }

    @Test
    public void errorWithoutProblemBodyIsUnknownWithStatus() {
        server.enqueue(new MockResponse().setResponseCode(502).setBody("<html>Bad gateway</html>"));

        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto("+40712345678")));

        assertEquals(new AppError(AppError.CODE_UNKNOWN, 502), result.getError());
    }

    @Test
    public void connectionFailureIsNetworkError() throws IOException {
        server.shutdown();

        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto("+40712345678")));

        assertEquals(AppError.network(), result.getError());
    }

    @Test
    public void malformedSuccessBodyIsUnknownError() {
        server.enqueue(new MockResponse().setResponseCode(200).setBody("{not json"));

        Result<AuthSessionDto> result =
                apiCaller.execute(authApi.verifyOtp(new OtpVerifyRequestDto("c", "123456")));

        assertEquals(AppError.CODE_UNKNOWN, result.getError().getCode());
    }

    @Test
    public void emptySuccessIsAccepted() {
        server.enqueue(new MockResponse().setResponseCode(204));

        Result<Void> result = apiCaller.executeEmpty(authApi.logout());

        assertTrue(result.isSuccess());
        assertNull(result.getValue());
    }

    @Test
    public void certificatePinnerIsDisabledWithoutPinsAndBuiltWithPins() {
        assertEquals(okhttp3.CertificatePinner.DEFAULT,
                CertificatePinnerFactory.create("https://api.profitnet.example/v1/", ""));
        okhttp3.CertificatePinner pinner = CertificatePinnerFactory.create(
                "https://api.profitnet.example/v1/",
                "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=, "
                        + "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=");
        assertEquals(2, pinner.getPins().size());
        assertEquals("api.profitnet.example", pinner.getPins().iterator().next().getPattern());
    }
}
