package ro.profitnet.app.core.security;

/**
 * Persistent storage for the session tokens. Implementations must be safe to call from any
 * thread and must never write the tokens anywhere in clear text.
 */
public interface TokenStore {

    /** @return the access token, or {@code null} when there is no session. */
    String getAccessToken();

    /** @return the refresh token, or {@code null} when there is no session. */
    String getRefreshToken();

    /** Stores both tokens, replacing any previous pair. */
    void save(String accessToken, String refreshToken);

    /** Removes both tokens. */
    void clear();
}
