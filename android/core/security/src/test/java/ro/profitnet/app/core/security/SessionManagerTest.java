package ro.profitnet.app.core.security;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.concurrent.atomic.AtomicInteger;

import org.junit.Test;

public class SessionManagerTest {

    private static final class InMemoryTokenStore implements TokenStore {
        private String access;
        private String refresh;

        @Override
        public String getAccessToken() {
            return access;
        }

        @Override
        public String getRefreshToken() {
            return refresh;
        }

        @Override
        public void save(String accessToken, String refreshToken) {
            access = accessToken;
            refresh = refreshToken;
        }

        @Override
        public void clear() {
            access = null;
            refresh = null;
        }
    }

    @Test
    public void savingTokensCreatesSession() {
        SessionManager manager = new SessionManager(new InMemoryTokenStore());
        assertFalse(manager.hasSession());

        manager.saveTokens("a", "r");

        assertTrue(manager.hasSession());
        assertEquals("a", manager.getAccessToken());
        assertEquals("r", manager.getRefreshToken());
    }

    @Test
    public void expireClearsTokensAndNotifiesListeners() {
        SessionManager manager = new SessionManager(new InMemoryTokenStore());
        AtomicInteger calls = new AtomicInteger();
        manager.addSessionExpiredListener(calls::incrementAndGet);
        manager.saveTokens("a", "r");

        manager.expire();

        assertFalse(manager.hasSession());
        assertNull(manager.getAccessToken());
        assertEquals(1, calls.get());
    }

    @Test
    public void clearDoesNotNotifyListeners() {
        SessionManager manager = new SessionManager(new InMemoryTokenStore());
        AtomicInteger calls = new AtomicInteger();
        manager.addSessionExpiredListener(calls::incrementAndGet);
        manager.saveTokens("a", "r");

        manager.clear();

        assertFalse(manager.hasSession());
        assertEquals(0, calls.get());
    }

    @Test
    public void removedListenerIsNotNotified() {
        SessionManager manager = new SessionManager(new InMemoryTokenStore());
        AtomicInteger calls = new AtomicInteger();
        SessionManager.SessionExpiredListener listener = calls::incrementAndGet;
        manager.addSessionExpiredListener(listener);
        manager.removeSessionExpiredListener(listener);

        manager.expire();

        assertEquals(0, calls.get());
    }
}
