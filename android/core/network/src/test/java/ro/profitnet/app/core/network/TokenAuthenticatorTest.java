package ro.profitnet.app.core.network;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import okhttp3.OkHttpClient;
import okhttp3.mockwebserver.Dispatcher;
import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import okhttp3.mockwebserver.RecordedRequest;
import okhttp3.mockwebserver.SocketPolicy;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.api.CatalogApi;
import ro.profitnet.app.core.network.api.MeApi;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.security.SessionManager;

public class TokenAuthenticatorTest {

    private static final String OLD_ACCESS = "old-access";
    private static final String OLD_REFRESH = "old-refresh";
    // Values of api/fixtures/auth_refresh.200.json
    private static final String NEW_ACCESS = "fixture.access.token.2";
    private static final String NEW_REFRESH = "fixture-refresh-token-2";

    private MockWebServer server;
    private SessionManager sessionManager;
    private AtomicInteger expiredCalls;
    private MeApi meApi;
    private CatalogApi catalogApi;
    private ApiCaller apiCaller;

    @Before
    public void setUp() throws IOException {
        server = new MockWebServer();
        server.start();

        sessionManager = new SessionManager(new InMemoryTokenStore());
        sessionManager.saveTokens(OLD_ACCESS, OLD_REFRESH);
        expiredCalls = new AtomicInteger();
        sessionManager.addSessionExpiredListener(expiredCalls::incrementAndGet);

        Gson gson = new Gson();
        // Same wiring as NetworkModule: the refresh API has no authenticator.
        OkHttpClient baseClient = new OkHttpClient.Builder()
                .readTimeout(5, TimeUnit.SECONDS)
                .build();
        AuthApi refreshApi = retrofit(baseClient, gson).create(AuthApi.class);
        OkHttpClient client = baseClient.newBuilder()
                .addInterceptor(new AuthInterceptor(sessionManager))
                .authenticator(new TokenAuthenticator(sessionManager, refreshApi))
                .build();
        Retrofit retrofit = retrofit(client, gson);
        meApi = retrofit.create(MeApi.class);
        catalogApi = retrofit.create(CatalogApi.class);
        apiCaller = new ApiCaller(new ProblemJsonParser(gson));
    }

    @After
    public void tearDown() throws IOException {
        server.shutdown();
    }

    private Retrofit retrofit(OkHttpClient client, Gson gson) {
        return new Retrofit.Builder()
                .baseUrl(server.url("/v1/"))
                .client(client)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();
    }

    private static MockResponse json(int code, String body) {
        return new MockResponse().setResponseCode(code)
                .setHeader("Content-Type", "application/json")
                .setBody(body);
    }

    private static MockResponse unauthorized() {
        return new MockResponse().setResponseCode(401)
                .setHeader("Content-Type", "application/problem+json")
                .setBody("{\"type\":\"about:blank\",\"title\":\"Unauthorized\","
                        + "\"status\":401,\"code\":\"UNAUTHORIZED\"}");
    }

    @Test
    public void attachesAccessTokenToAuthenticatedRequests() throws Exception {
        server.enqueue(json(200, Fixtures.read("me.new.200.json")));

        Response<MeDto> response = meApi.getMe().execute();

        assertTrue(response.isSuccessful());
        RecordedRequest request = server.takeRequest();
        assertEquals("/v1/me", request.getPath());
        assertEquals("Bearer " + OLD_ACCESS, request.getHeader("Authorization"));
    }

    @Test
    public void publicEndpointsGetNoTokenAndNoMarkerHeader() throws Exception {
        server.enqueue(json(200, Fixtures.read("categories.200.json")));

        assertTrue(catalogApi.listCategories().execute().isSuccessful());

        RecordedRequest request = server.takeRequest();
        assertNull(request.getHeader("Authorization"));
        assertNull(request.getHeader(AuthInterceptor.NO_AUTH_HEADER));
    }

    @Test
    public void on401RefreshesOnceAndRetriesWithNewToken() throws Exception {
        server.enqueue(unauthorized());
        server.enqueue(json(200, Fixtures.read("auth_refresh.200.json")));
        server.enqueue(json(200, Fixtures.read("me.onboarded.200.json")));

        Response<MeDto> response = meApi.getMe().execute();

        assertTrue(response.isSuccessful());
        assertEquals("Ioana", response.body().displayName);
        assertEquals(3, server.getRequestCount());

        RecordedRequest first = server.takeRequest();
        assertEquals("/v1/me", first.getPath());
        assertEquals("Bearer " + OLD_ACCESS, first.getHeader("Authorization"));

        RecordedRequest refresh = server.takeRequest();
        assertEquals("POST", refresh.getMethod());
        assertEquals("/v1/auth/refresh", refresh.getPath());
        assertNull(refresh.getHeader("Authorization"));
        assertEquals("{\"refreshToken\":\"" + OLD_REFRESH + "\"}", refresh.getBody().readUtf8());

        RecordedRequest retry = server.takeRequest();
        assertEquals("/v1/me", retry.getPath());
        assertEquals("Bearer " + NEW_ACCESS, retry.getHeader("Authorization"));

        assertEquals(NEW_ACCESS, sessionManager.getAccessToken());
        assertEquals(NEW_REFRESH, sessionManager.getRefreshToken());
        assertEquals(0, expiredCalls.get());
    }

    @Test
    public void retriesOnlyOnceWhenTheFreshTokenIsAlsoRejected() throws Exception {
        server.enqueue(unauthorized());
        server.enqueue(json(200, Fixtures.read("auth_refresh.200.json")));
        server.enqueue(unauthorized());

        Result<MeDto> result = apiCaller.execute(meApi.getMe());

        assertTrue(result.isFailure());
        assertEquals(new AppError(AppError.CODE_UNAUTHORIZED, 401), result.getError());
        // original + refresh + one retry, and no second refresh
        assertEquals(3, server.getRequestCount());
    }

    @Test
    public void rejectedRefreshClearsSessionAndNotifies() throws Exception {
        server.enqueue(unauthorized());
        server.enqueue(unauthorized()); // the refresh call itself is rejected

        Result<MeDto> result = apiCaller.execute(meApi.getMe());

        assertTrue(result.isFailure());
        assertEquals(401, result.getError().getHttpStatus());
        assertEquals(2, server.getRequestCount());
        assertFalse(sessionManager.hasSession());
        assertNull(sessionManager.getAccessToken());
        assertNull(sessionManager.getRefreshToken());
        assertEquals(1, expiredCalls.get());
    }

    @Test
    public void malformedRefreshResponseClearsSession() throws Exception {
        server.enqueue(unauthorized());
        server.enqueue(json(200, "{\"accessToken\":\"only-access\"}"));

        Result<MeDto> result = apiCaller.execute(meApi.getMe());

        assertTrue(result.isFailure());
        assertFalse(sessionManager.hasSession());
        assertEquals(1, expiredCalls.get());
    }

    @Test
    public void connectivityFailureDuringRefreshKeepsSession() throws Exception {
        server.enqueue(unauthorized());
        server.enqueue(new MockResponse().setSocketPolicy(SocketPolicy.DISCONNECT_AFTER_REQUEST));

        Result<MeDto> result = apiCaller.execute(meApi.getMe());

        assertTrue(result.isFailure());
        assertEquals(AppError.CODE_NETWORK, result.getError().getCode());
        assertTrue(sessionManager.hasSession());
        assertEquals(OLD_REFRESH, sessionManager.getRefreshToken());
        assertEquals(0, expiredCalls.get());
    }

    @Test
    public void concurrent401sShareASingleRefresh() throws Exception {
        final int parallelCalls = 4;
        final String refreshBody = Fixtures.read("auth_refresh.200.json");
        final String meBody = Fixtures.read("me.onboarded.200.json");
        final AtomicInteger refreshCalls = new AtomicInteger();
        final CountDownLatch allRejected = new CountDownLatch(parallelCalls);
        server.setDispatcher(new Dispatcher() {
            @NonNull
            @Override
            public MockResponse dispatch(@NonNull RecordedRequest request)
                    throws InterruptedException {
                if ("/v1/auth/refresh".equals(request.getPath())) {
                    refreshCalls.incrementAndGet();
                    // Hold the refresh until every call has been rejected, so that they all
                    // queue up behind the single in-flight refresh.
                    allRejected.await(5, TimeUnit.SECONDS);
                    return json(200, refreshBody);
                }
                if (("Bearer " + NEW_ACCESS).equals(request.getHeader("Authorization"))) {
                    return json(200, meBody);
                }
                allRejected.countDown();
                return unauthorized();
            }
        });

        List<Boolean> outcomes = Collections.synchronizedList(new ArrayList<>());
        List<Thread> threads = new ArrayList<>();
        for (int i = 0; i < parallelCalls; i++) {
            Thread thread = new Thread(() -> {
                try {
                    outcomes.add(meApi.getMe().execute().isSuccessful());
                } catch (IOException e) {
                    outcomes.add(false);
                }
            });
            threads.add(thread);
            thread.start();
        }
        for (Thread thread : threads) {
            thread.join(10_000);
        }

        assertEquals(parallelCalls, outcomes.size());
        assertFalse(outcomes.contains(false));
        assertEquals(1, refreshCalls.get());
        assertEquals(NEW_ACCESS, sessionManager.getAccessToken());
        assertEquals(0, expiredCalls.get());
    }

    @Test
    public void public401IsNotRefreshed() throws Exception {
        server.enqueue(unauthorized());

        Response<?> response = catalogApi.listCategories().execute();

        assertEquals(401, response.code());
        assertEquals(1, server.getRequestCount());
        assertTrue(sessionManager.hasSession());
    }
}
