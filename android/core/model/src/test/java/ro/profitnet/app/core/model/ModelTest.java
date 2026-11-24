package ro.profitnet.app.core.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class ModelTest {

    @Test
    public void moneyRejectsNegativeAmountsAndMissingCurrency() {
        assertThrows(IllegalArgumentException.class, () -> new Money(-1, "RON"));
        assertThrows(NullPointerException.class, () -> new Money(1, null));
    }

    @Test
    public void moneyHasValueEquality() {
        assertEquals(new Money(150000, "RON"), new Money(150000, "RON"));
        assertNotEquals(new Money(150000, "RON"), new Money(150000, "EUR"));
        assertEquals(new Money(1, "RON").hashCode(), new Money(1, "RON").hashCode());
    }

    @Test
    public void geoPointRejectsOutOfRangeCoordinates() {
        assertThrows(IllegalArgumentException.class, () -> new GeoPoint(90.01, 0));
        assertThrows(IllegalArgumentException.class, () -> new GeoPoint(0, -180.5));
        assertThrows(IllegalArgumentException.class, () -> new GeoPoint(Double.NaN, 0));
        assertEquals(new GeoPoint(46.77, 23.6), new GeoPoint(46.77, 23.60));
    }

    @Test
    public void onlyTermsAndPrivacyAreRequired() {
        for (ConsentPurpose purpose : ConsentPurpose.values()) {
            boolean expected = purpose == ConsentPurpose.TERMS || purpose == ConsentPurpose.PRIVACY;
            assertEquals(purpose.name(), expected, purpose.isRequired());
        }
    }

    @Test
    public void localConsentDecisionHasNoServerTimestamp() {
        Consent consent = Consent.decision(ConsentPurpose.MARKETING, false, "2026-11");
        assertFalse(consent.isGranted());
        assertNull(consent.getUpdatedAt());
        assertEquals("2026-11", consent.getPolicyVersion());
    }

    @Test
    public void userDefaultsDisplayNameToEmpty() {
        User user = User.builder("id-1").build();
        assertEquals("", user.getDisplayName());
        assertFalse(user.isOnboardingCompleted());
        assertNull(user.getHomeLocation());
    }

    @Test
    public void categoryWithoutParentIsTopLevel() {
        assertTrue(new Category("1", null, "haine", "Haine", "clothing", false).isTopLevel());
        assertFalse(new Category("2", "1", "rochii", "Rochii", null, false).isTopLevel());
    }

    @Test
    public void tokenPairDoesNotLeakSecretsInToString() {
        String text = new TokenPair("secret-access", "secret-refresh", 900).toString();
        assertFalse(text.contains("secret-access"));
        assertFalse(text.contains("secret-refresh"));
    }

    @Test
    public void otpChallengeClampsNegativeRetry() {
        assertEquals(0, new OtpChallenge("c", -5).getRetryAfterSeconds());
    }
}
