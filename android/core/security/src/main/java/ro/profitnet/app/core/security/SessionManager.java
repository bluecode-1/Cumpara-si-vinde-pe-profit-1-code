package ro.profitnet.app.core.security;

import java.util.concurrent.CopyOnWriteArraySet;

/**
 * Single entry point for the local session: reads and writes go through here so that the rest
 * of the app can be told when the session ends unexpectedly (refresh token rejected).
 */
public final class SessionManager {

    /** Notified when the session is dropped because it could not be refreshed. */
    public interface SessionExpiredListener {
        /** Called on the thread that detected the expiry (usually a network thread). */
        void onSessionExpired();
    }

    private final TokenStore tokenStore;
    private final CopyOnWriteArraySet<SessionExpiredListener> listeners =
            new CopyOnWriteArraySet<>();

    public SessionManager(TokenStore tokenStore) {
        this.tokenStore = tokenStore;
    }

    public boolean hasSession() {
        return tokenStore.getRefreshToken() != null;
    }

    public String getAccessToken() {
        return tokenStore.getAccessToken();
    }

    public String getRefreshToken() {
        return tokenStore.getRefreshToken();
    }

    public void saveTokens(String accessToken, String refreshToken) {
        tokenStore.save(accessToken, refreshToken);
    }

    /** Deliberate sign-out: clears the tokens without notifying expiry listeners. */
    public void clear() {
        tokenStore.clear();
    }

    /** The server rejected the refresh token: clear the tokens and tell the UI. */
    public void expire() {
        tokenStore.clear();
        for (SessionExpiredListener listener : listeners) {
            listener.onSessionExpired();
        }
    }

    public void addSessionExpiredListener(SessionExpiredListener listener) {
        listeners.add(listener);
    }

    public void removeSessionExpiredListener(SessionExpiredListener listener) {
        listeners.remove(listener);
    }
}
