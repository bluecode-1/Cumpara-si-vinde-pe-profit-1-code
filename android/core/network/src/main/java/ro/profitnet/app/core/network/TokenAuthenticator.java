package ro.profitnet.app.core.network;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.IOException;

import okhttp3.Authenticator;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.Route;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.dto.RefreshRequestDto;
import ro.profitnet.app.core.network.dto.TokenPairDto;
import ro.profitnet.app.core.security.SessionManager;

/**
 * Handles 401 responses: refreshes the token pair once, serialized across concurrent requests
 * (single flight), then repeats the failed request once with the new access token.
 *
 * <ul>
 *   <li>If another request already refreshed while this one waited, the new token is reused
 *       without a second refresh call.</li>
 *   <li>If the server rejects the refresh token, the session is cleared and listeners are told
 *       (the UI goes back to the welcome screen).</li>
 *   <li>If the refresh call fails for connectivity reasons, the {@link IOException} is passed on
 *       and the session is kept: being offline must not sign the user out.</li>
 * </ul>
 *
 * <p>The {@link AuthApi} given here must be backed by a client <em>without</em> this
 * authenticator, otherwise a failing refresh would recurse.
 */
public final class TokenAuthenticator implements Authenticator {

    private final SessionManager sessionManager;
    private final AuthApi refreshApi;
    private final Object refreshLock = new Object();

    public TokenAuthenticator(SessionManager sessionManager, AuthApi refreshApi) {
        this.sessionManager = sessionManager;
        this.refreshApi = refreshApi;
    }

    @Nullable
    @Override
    public Request authenticate(@Nullable Route route, @NonNull Response response)
            throws IOException {
        Request failedRequest = response.request();
        String failedHeader = failedRequest.header(AuthInterceptor.AUTHORIZATION);
        if (failedHeader == null || !failedHeader.startsWith(AuthInterceptor.BEARER_PREFIX)) {
            // A public endpoint answered 401: there is nothing to refresh.
            return null;
        }
        if (attemptCount(response) > 1) {
            // The request was already repeated once with a fresh token: give up.
            return null;
        }
        String failedToken = failedHeader.substring(AuthInterceptor.BEARER_PREFIX.length());

        synchronized (refreshLock) {
            String currentToken = sessionManager.getAccessToken();
            if (currentToken != null && !currentToken.equals(failedToken)) {
                // Another request refreshed the session while this one was waiting.
                return withToken(failedRequest, currentToken);
            }
            String refreshToken = sessionManager.getRefreshToken();
            if (refreshToken == null) {
                // The session is already gone (sign-out or an earlier failed refresh).
                return null;
            }

            retrofit2.Response<TokenPairDto> refreshResponse;
            try {
                refreshResponse = refreshApi.refresh(new RefreshRequestDto(refreshToken)).execute();
            } catch (RuntimeException e) {
                // Unreadable refresh response: treat it as a rejected refresh.
                sessionManager.expire();
                return null;
            }
            TokenPairDto tokens = refreshResponse.body();
            if (!refreshResponse.isSuccessful() || tokens == null
                    || tokens.accessToken == null || tokens.refreshToken == null) {
                sessionManager.expire();
                return null;
            }
            sessionManager.saveTokens(tokens.accessToken, tokens.refreshToken);
            return withToken(failedRequest, tokens.accessToken);
        }
    }

    private static Request withToken(Request request, String accessToken) {
        return request.newBuilder()
                .header(AuthInterceptor.AUTHORIZATION, AuthInterceptor.BEARER_PREFIX + accessToken)
                .build();
    }

    /** Number of responses received for this call so far, including the current one. */
    private static int attemptCount(Response response) {
        int count = 1;
        Response prior = response.priorResponse();
        while (prior != null) {
            count++;
            prior = prior.priorResponse();
        }
        return count;
    }
}
