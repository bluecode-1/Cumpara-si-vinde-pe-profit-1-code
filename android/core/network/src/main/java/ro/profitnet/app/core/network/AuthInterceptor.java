package ro.profitnet.app.core.network;

import androidx.annotation.NonNull;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;
import ro.profitnet.app.core.security.SessionManager;

/**
 * Attaches the access token to every authenticated request. Public endpoints are marked on the
 * Retrofit interface with {@link #NO_AUTH_HEADER_LINE}; the marker is stripped before the
 * request leaves the device and no token is sent to them.
 */
public final class AuthInterceptor implements Interceptor {

    public static final String NO_AUTH_HEADER = "X-ProfitNet-No-Auth";
    /** Value for Retrofit's {@code @Headers}. */
    public static final String NO_AUTH_HEADER_LINE = NO_AUTH_HEADER + ": true";

    static final String AUTHORIZATION = "Authorization";
    static final String BEARER_PREFIX = "Bearer ";

    private final SessionManager sessionManager;

    public AuthInterceptor(SessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }

    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        Request request = chain.request();
        if (request.header(NO_AUTH_HEADER) != null) {
            return chain.proceed(request.newBuilder().removeHeader(NO_AUTH_HEADER).build());
        }
        String accessToken = sessionManager.getAccessToken();
        if (accessToken == null) {
            return chain.proceed(request);
        }
        return chain.proceed(request.newBuilder()
                .header(AUTHORIZATION, BEARER_PREFIX + accessToken)
                .build());
    }
}
