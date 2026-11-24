package ro.profitnet.app.core.network.fake;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okio.Buffer;

/**
 * Debug-only stand-in for the backend (demo mode, spec section 5). It answers every request
 * locally from the shared fixtures in {@code api/fixtures}; nothing reaches the network.
 *
 * <ul>
 *   <li>any phone number gets the "code sent" response;</li>
 *   <li>code {@code 123456} signs in, any other code returns {@code OTP_INVALID} (422);</li>
 *   <li>{@code PATCH /me} and {@code PUT /me/consents} keep their changes in memory for the
 *       lifetime of the process.</li>
 * </ul>
 *
 * <p>This class lives in {@code src/debug} and is not compiled into release builds.
 */
public final class FakeApiInterceptor implements Interceptor {

    public static final String VALID_CODE = "123456";

    private static final MediaType JSON = MediaType.get("application/json; charset=utf-8");
    private static final MediaType PROBLEM_JSON =
            MediaType.get("application/problem+json; charset=utf-8");

    private static final String FIXTURE_OTP_REQUEST = "auth_otp_request.202.json";
    private static final String FIXTURE_OTP_VERIFY = "auth_otp_verify.200.json";
    private static final String FIXTURE_REFRESH = "auth_refresh.200.json";
    private static final String FIXTURE_CATEGORIES = "categories.200.json";
    private static final String FIXTURE_ME_NEW = "me.new.200.json";
    private static final String FIXTURE_CONSENTS = "me_consents.200.json";
    private static final String FIXTURE_OTP_INVALID = "problem_otp_invalid.422.json";

    private final FixtureSource fixtures;
    private final long delayMillis;
    private final Gson gson = new Gson();
    private final Object stateLock = new Object();

    // In-memory state, guarded by stateLock. Loaded lazily from the fixtures.
    private JsonObject me;
    private JsonArray consents;
    private JsonArray interestCategoryIds = new JsonArray();

    /**
     * @param delayMillis artificial latency per request, so loading states are visible.
     */
    public FakeApiInterceptor(FixtureSource fixtures, long delayMillis) {
        this.fixtures = fixtures;
        this.delayMillis = delayMillis;
    }

    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        Request request = chain.request();
        simulateLatency();
        String route = request.method() + " " + pathAfterVersion(request);
        switch (route) {
            case "POST /auth/otp/request":
                return json(request, 202, fixtures.read(FIXTURE_OTP_REQUEST));
            case "POST /auth/otp/verify":
                return verifyOtp(request);
            case "POST /auth/refresh":
                return json(request, 200, fixtures.read(FIXTURE_REFRESH));
            case "GET /categories":
                return json(request, 200, fixtures.read(FIXTURE_CATEGORIES));
            default:
                break;
        }
        // Everything below requires a bearer token.
        if (request.header("Authorization") == null) {
            return problem(request, 401, "UNAUTHORIZED", "Unauthorized");
        }
        switch (route) {
            case "POST /auth/logout":
                return empty(request, 204);
            case "GET /me":
                synchronized (stateLock) {
                    return json(request, 200, gson.toJson(me()));
                }
            case "PATCH /me":
                return patchMe(request);
            case "GET /me/consents":
                synchronized (stateLock) {
                    return json(request, 200, gson.toJson(consents()));
                }
            case "PUT /me/consents":
                return putConsents(request);
            default:
                return problem(request, 404, "NOT_FOUND", "Not found");
        }
    }

    private Response verifyOtp(Request request) throws IOException {
        JsonObject body = readObject(request);
        String code = body == null ? null : stringOrNull(body.get("code"));
        if (!VALID_CODE.equals(code)) {
            return new Response.Builder()
                    .request(request)
                    .protocol(Protocol.HTTP_1_1)
                    .code(422)
                    .message("Unprocessable Entity")
                    .body(ResponseBody.create(fixtures.read(FIXTURE_OTP_INVALID), PROBLEM_JSON))
                    .build();
        }
        JsonObject session = JsonParser.parseString(fixtures.read(FIXTURE_OTP_VERIFY))
                .getAsJsonObject();
        synchronized (stateLock) {
            // Reflect changes made earlier in this run (e.g. sign out, then sign in again).
            session.add("user", me().deepCopy());
            session.addProperty("isNewUser", !isOnboardingCompleted(me()));
        }
        return json(request, 200, gson.toJson(session));
    }

    private Response patchMe(Request request) throws IOException {
        JsonObject update = readObject(request);
        if (update == null) {
            return problem(request, 400, "VALIDATION_FAILED", "Bad request");
        }
        synchronized (stateLock) {
            JsonObject current = me();
            for (String field : new String[] {
                    "displayName", "locale", "currency", "homeLocation", "onboardingCompleted"}) {
                if (update.has(field) && !update.get(field).isJsonNull()) {
                    current.add(field, update.get(field).deepCopy());
                }
            }
            JsonElement interests = update.get("interestCategoryIds");
            if (interests != null && interests.isJsonArray()) {
                interestCategoryIds = interests.getAsJsonArray().deepCopy();
            }
            return json(request, 200, gson.toJson(current));
        }
    }

    private Response putConsents(Request request) throws IOException {
        JsonElement body = readJson(request);
        if (body == null || !body.isJsonArray()) {
            return problem(request, 400, "VALIDATION_FAILED", "Bad request");
        }
        String now = Instant.now().truncatedTo(ChronoUnit.SECONDS).toString();
        synchronized (stateLock) {
            JsonArray current = consents();
            for (JsonElement element : body.getAsJsonArray()) {
                if (!element.isJsonObject()) {
                    continue;
                }
                JsonObject update = element.getAsJsonObject();
                String purpose = stringOrNull(update.get("purpose"));
                if (purpose == null) {
                    continue;
                }
                JsonObject target = null;
                for (JsonElement existing : current) {
                    if (purpose.equals(stringOrNull(existing.getAsJsonObject().get("purpose")))) {
                        target = existing.getAsJsonObject();
                        break;
                    }
                }
                if (target == null) {
                    target = new JsonObject();
                    target.addProperty("purpose", purpose);
                    current.add(target);
                }
                JsonElement granted = update.get("granted");
                target.addProperty("granted",
                        granted != null && granted.isJsonPrimitive() && granted.getAsBoolean());
                target.add("policyVersion", update.get("policyVersion"));
                target.addProperty("updatedAt", now);
            }
        }
        return empty(request, 204);
    }

    /** Exposed for tests: ids last sent as {@code interestCategoryIds}. */
    public JsonArray getInterestCategoryIds() {
        synchronized (stateLock) {
            return interestCategoryIds.deepCopy();
        }
    }

    private JsonObject me() throws IOException {
        if (me == null) {
            me = JsonParser.parseString(fixtures.read(FIXTURE_ME_NEW)).getAsJsonObject();
        }
        return me;
    }

    private JsonArray consents() throws IOException {
        if (consents == null) {
            // Start from the fixture's shape, but with nothing granted yet.
            consents = JsonParser.parseString(fixtures.read(FIXTURE_CONSENTS)).getAsJsonArray();
            for (JsonElement element : consents) {
                element.getAsJsonObject().addProperty("granted", false);
            }
        }
        return consents;
    }

    private static boolean isOnboardingCompleted(JsonObject user) {
        JsonElement value = user.get("onboardingCompleted");
        return value != null && value.isJsonPrimitive() && value.getAsBoolean();
    }

    private void simulateLatency() throws IOException {
        if (delayMillis <= 0) {
            return;
        }
        try {
            Thread.sleep(delayMillis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new InterruptedIOException("Interrupted");
        }
    }

    /** Request path without the {@code /v1} version prefix, e.g. {@code /me/consents}. */
    private static String pathAfterVersion(Request request) {
        String path = request.url().encodedPath();
        if (path.startsWith("/v1/") || path.equals("/v1")) {
            path = path.substring(3);
        }
        if (path.length() > 1 && path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }
        return path;
    }

    @Nullable
    private static JsonObject readObject(Request request) throws IOException {
        JsonElement element = readJson(request);
        return element != null && element.isJsonObject() ? element.getAsJsonObject() : null;
    }

    @Nullable
    private static JsonElement readJson(Request request) throws IOException {
        if (request.body() == null) {
            return null;
        }
        Buffer buffer = new Buffer();
        request.body().writeTo(buffer);
        try {
            return JsonParser.parseString(buffer.readUtf8());
        } catch (JsonParseException e) {
            return null;
        }
    }

    @Nullable
    private static String stringOrNull(@Nullable JsonElement element) {
        return element != null && element.isJsonPrimitive() ? element.getAsString() : null;
    }

    private static Response json(Request request, int code, String body) {
        return new Response.Builder()
                .request(request)
                .protocol(Protocol.HTTP_1_1)
                .code(code)
                .message("OK")
                .body(ResponseBody.create(body, JSON))
                .build();
    }

    private static Response empty(Request request, int code) {
        return new Response.Builder()
                .request(request)
                .protocol(Protocol.HTTP_1_1)
                .code(code)
                .message("No Content")
                .body(ResponseBody.create("", null))
                .build();
    }

    private static Response problem(Request request, int status, String code, String title) {
        JsonObject problem = new JsonObject();
        problem.addProperty("type", "about:blank");
        problem.addProperty("title", title);
        problem.addProperty("status", status);
        problem.addProperty("code", code);
        return new Response.Builder()
                .request(request)
                .protocol(Protocol.HTTP_1_1)
                .code(status)
                .message(title)
                .body(ResponseBody.create(problem.toString(), PROBLEM_JSON))
                .build();
    }
}
