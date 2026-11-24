package ro.profitnet.app.core.network;

import ro.profitnet.app.core.security.TokenStore;

/** Thread-safe in-memory {@link TokenStore} for JVM tests. */
public final class InMemoryTokenStore implements TokenStore {

    private String accessToken;
    private String refreshToken;

    @Override
    public synchronized String getAccessToken() {
        return accessToken;
    }

    @Override
    public synchronized String getRefreshToken() {
        return refreshToken;
    }

    @Override
    public synchronized void save(String newAccessToken, String newRefreshToken) {
        accessToken = newAccessToken;
        refreshToken = newRefreshToken;
    }

    @Override
    public synchronized void clear() {
        accessToken = null;
        refreshToken = null;
    }
}
