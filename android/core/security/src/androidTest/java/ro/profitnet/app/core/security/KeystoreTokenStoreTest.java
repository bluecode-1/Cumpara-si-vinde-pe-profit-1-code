package ro.profitnet.app.core.security;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

import android.content.Context;
import android.content.SharedPreferences;

import androidx.test.core.app.ApplicationProvider;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

/** Needs a device: the Android Keystore is not available on the JVM. */
@RunWith(AndroidJUnit4.class)
public class KeystoreTokenStoreTest {

    private Context context;

    @Before
    public void setUp() {
        context = ApplicationProvider.getApplicationContext();
        new KeystoreTokenStore(context).clear();
    }

    @After
    public void tearDown() {
        new KeystoreTokenStore(context).clear();
    }

    @Test
    public void tokensSurviveANewInstance() {
        new KeystoreTokenStore(context).save("access-1", "refresh-1");

        KeystoreTokenStore reopened = new KeystoreTokenStore(context);

        assertEquals("access-1", reopened.getAccessToken());
        assertEquals("refresh-1", reopened.getRefreshToken());
    }

    @Test
    public void tokensAreNotStoredInClearText() {
        new KeystoreTokenStore(context).save("access-1", "refresh-1");

        SharedPreferences prefs = context.getSharedPreferences(
                KeystoreTokenStore.PREFS_NAME, Context.MODE_PRIVATE);
        for (Object value : prefs.getAll().values()) {
            assertNotNull(value);
            assertFalse(value.toString().contains("access-1"));
            assertFalse(value.toString().contains("refresh-1"));
        }
        assertFalse(prefs.getAll().isEmpty());
    }

    @Test
    public void clearRemovesTokens() {
        KeystoreTokenStore store = new KeystoreTokenStore(context);
        store.save("access-1", "refresh-1");

        store.clear();

        assertNull(new KeystoreTokenStore(context).getAccessToken());
        assertNull(new KeystoreTokenStore(context).getRefreshToken());
    }

    @Test
    public void tamperedValueIsTreatedAsNoSession() {
        new KeystoreTokenStore(context).save("access-1", "refresh-1");
        SharedPreferences prefs = context.getSharedPreferences(
                KeystoreTokenStore.PREFS_NAME, Context.MODE_PRIVATE);
        // Swap the two ciphertexts: the associated data no longer matches.
        String access = prefs.getString("access_token", null);
        String refresh = prefs.getString("refresh_token", null);
        prefs.edit().putString("access_token", refresh).putString("refresh_token", access).commit();

        KeystoreTokenStore reopened = new KeystoreTokenStore(context);

        assertNull(reopened.getAccessToken());
        assertNull(reopened.getRefreshToken());
    }
}
