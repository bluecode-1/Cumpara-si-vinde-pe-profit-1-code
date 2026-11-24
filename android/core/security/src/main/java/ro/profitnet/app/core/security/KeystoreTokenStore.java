package ro.profitnet.app.core.security;

import android.content.Context;
import android.content.SharedPreferences;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Base64;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.KeyStore;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

/**
 * {@link TokenStore} that encrypts the tokens with an AES-256/GCM key held in the Android
 * Keystore (the key material never leaves the Keystore) and keeps only the ciphertext in a
 * private SharedPreferences file. The preference key is bound into the ciphertext as
 * associated data, so a stored value cannot be swapped between entries.
 *
 * <p>The deprecated androidx.security:security-crypto library is deliberately not used.
 *
 * <p>If a value cannot be decrypted (key invalidated, restored data from another device) the
 * session is treated as absent and wiped, which sends the user back to sign-in.
 */
public final class KeystoreTokenStore implements TokenStore {

    static final String PREFS_NAME = "profitnet_session";
    static final String KEY_ALIAS = "profitnet_session_key";

    private static final String ANDROID_KEYSTORE = "AndroidKeyStore";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int KEY_SIZE_BITS = 256;
    private static final int GCM_TAG_BITS = 128;
    private static final String PREF_ACCESS = "access_token";
    private static final String PREF_REFRESH = "refresh_token";

    private final SharedPreferences prefs;
    private final Object lock = new Object();

    // Decrypted copies kept in memory so that the interceptor does not hit the Keystore on
    // every request. Guarded by "lock".
    private boolean loaded;
    private String accessToken;
    private String refreshToken;

    public KeystoreTokenStore(Context context) {
        this.prefs = context.getApplicationContext()
                .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
    }

    @Override
    public String getAccessToken() {
        synchronized (lock) {
            ensureLoaded();
            return accessToken;
        }
    }

    @Override
    public String getRefreshToken() {
        synchronized (lock) {
            ensureLoaded();
            return refreshToken;
        }
    }

    @Override
    public void save(String newAccessToken, String newRefreshToken) {
        if (newAccessToken == null || newRefreshToken == null) {
            throw new IllegalArgumentException("Tokens must not be null");
        }
        synchronized (lock) {
            try {
                String encryptedAccess = encrypt(PREF_ACCESS, newAccessToken);
                String encryptedRefresh = encrypt(PREF_REFRESH, newRefreshToken);
                // commit(): the tokens must be on disk before the caller carries on.
                prefs.edit()
                        .putString(PREF_ACCESS, encryptedAccess)
                        .putString(PREF_REFRESH, encryptedRefresh)
                        .commit();
            } catch (GeneralSecurityException e) {
                // The Keystore is unusable: keep the session in memory only for this process
                // rather than writing the tokens unencrypted.
                prefs.edit().clear().commit();
            }
            accessToken = newAccessToken;
            refreshToken = newRefreshToken;
            loaded = true;
        }
    }

    @Override
    public void clear() {
        synchronized (lock) {
            prefs.edit().clear().commit();
            accessToken = null;
            refreshToken = null;
            loaded = true;
        }
    }

    private void ensureLoaded() {
        if (loaded) {
            return;
        }
        String encryptedAccess = prefs.getString(PREF_ACCESS, null);
        String encryptedRefresh = prefs.getString(PREF_REFRESH, null);
        if (encryptedAccess != null && encryptedRefresh != null) {
            try {
                accessToken = decrypt(PREF_ACCESS, encryptedAccess);
                refreshToken = decrypt(PREF_REFRESH, encryptedRefresh);
            } catch (GeneralSecurityException | IllegalArgumentException e) {
                accessToken = null;
                refreshToken = null;
                prefs.edit().clear().commit();
            }
        }
        loaded = true;
    }

    private String encrypt(String name, String plainText) throws GeneralSecurityException {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        // The Keystore generates a fresh random IV for every encryption.
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateKey());
        cipher.updateAAD(name.getBytes(StandardCharsets.UTF_8));
        byte[] iv = cipher.getIV();
        byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
        ByteBuffer buffer = ByteBuffer.allocate(1 + iv.length + cipherText.length);
        buffer.put((byte) iv.length);
        buffer.put(iv);
        buffer.put(cipherText);
        return Base64.encodeToString(buffer.array(), Base64.NO_WRAP);
    }

    private String decrypt(String name, String encoded) throws GeneralSecurityException {
        byte[] data = Base64.decode(encoded, Base64.NO_WRAP);
        if (data.length < 2) {
            throw new GeneralSecurityException("Stored value is too short");
        }
        int ivLength = data[0];
        if (ivLength <= 0 || data.length <= 1 + ivLength) {
            throw new GeneralSecurityException("Stored value is malformed");
        }
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, getOrCreateKey(),
                new GCMParameterSpec(GCM_TAG_BITS, data, 1, ivLength));
        cipher.updateAAD(name.getBytes(StandardCharsets.UTF_8));
        byte[] plain = cipher.doFinal(data, 1 + ivLength, data.length - 1 - ivLength);
        return new String(plain, StandardCharsets.UTF_8);
    }

    private SecretKey getOrCreateKey() throws GeneralSecurityException {
        try {
            KeyStore keyStore = KeyStore.getInstance(ANDROID_KEYSTORE);
            keyStore.load(null);
            java.security.Key existing = keyStore.getKey(KEY_ALIAS, null);
            if (existing instanceof SecretKey) {
                return (SecretKey) existing;
            }
        } catch (java.io.IOException e) {
            throw new GeneralSecurityException(e);
        }
        KeyGenerator generator =
                KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, ANDROID_KEYSTORE);
        generator.init(new KeyGenParameterSpec.Builder(KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(KEY_SIZE_BITS)
                .build());
        return generator.generateKey();
    }
}
