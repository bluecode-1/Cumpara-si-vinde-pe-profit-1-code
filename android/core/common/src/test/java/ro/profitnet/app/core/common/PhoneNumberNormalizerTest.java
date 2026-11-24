package ro.profitnet.app.core.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class PhoneNumberNormalizerTest {

    private static final String E164 = "+40712345678";

    @Test
    public void acceptsNationalFormWithLeadingZero() {
        assertEquals(E164, PhoneNumberNormalizer.normalize("0712345678"));
    }

    @Test
    public void acceptsNationalFormWithoutLeadingZero() {
        assertEquals(E164, PhoneNumberNormalizer.normalize("712345678"));
    }

    @Test
    public void acceptsInternationalForm() {
        assertEquals(E164, PhoneNumberNormalizer.normalize("+40712345678"));
    }

    @Test
    public void acceptsAllFormsWithSpaces() {
        assertEquals(E164, PhoneNumberNormalizer.normalize("0712 345 678"));
        assertEquals(E164, PhoneNumberNormalizer.normalize("712 345 678"));
        assertEquals(E164, PhoneNumberNormalizer.normalize("+40 712 345 678"));
        assertEquals(E164, PhoneNumberNormalizer.normalize("  +40 7 1 2 3 4 5 6 7 8  "));
        assertEquals(E164, PhoneNumberNormalizer.normalize("0712 345 678"));
    }

    @Test
    public void rejectsNullEmptyAndBlank() {
        assertNull(PhoneNumberNormalizer.normalize(null));
        assertNull(PhoneNumberNormalizer.normalize(""));
        assertNull(PhoneNumberNormalizer.normalize("   "));
    }

    @Test
    public void rejectsWrongLength() {
        assertNull(PhoneNumberNormalizer.normalize("071234567"));
        assertNull(PhoneNumberNormalizer.normalize("07123456789"));
        assertNull(PhoneNumberNormalizer.normalize("71234567"));
        assertNull(PhoneNumberNormalizer.normalize("+4071234567"));
        assertNull(PhoneNumberNormalizer.normalize("+407123456789"));
    }

    @Test
    public void rejectsNonMobileNumbers() {
        // Landlines and other ranges do not start with 7.
        assertNull(PhoneNumberNormalizer.normalize("0212345678"));
        assertNull(PhoneNumberNormalizer.normalize("0312345678"));
        assertNull(PhoneNumberNormalizer.normalize("+40212345678"));
        assertNull(PhoneNumberNormalizer.normalize("612345678"));
    }

    @Test
    public void rejectsOtherPrefixesAndCountries() {
        assertNull(PhoneNumberNormalizer.normalize("0040712345678"));
        assertNull(PhoneNumberNormalizer.normalize("40712345678"));
        assertNull(PhoneNumberNormalizer.normalize("+400712345678"));
        assertNull(PhoneNumberNormalizer.normalize("+44712345678"));
        assertNull(PhoneNumberNormalizer.normalize("+712345678"));
    }

    @Test
    public void rejectsLettersAndPunctuation() {
        assertNull(PhoneNumberNormalizer.normalize("0712-345-678"));
        assertNull(PhoneNumberNormalizer.normalize("0712.345.678"));
        assertNull(PhoneNumberNormalizer.normalize("(0712) 345 678"));
        assertNull(PhoneNumberNormalizer.normalize("07123456ab"));
        assertNull(PhoneNumberNormalizer.normalize("0712345678 ext 2"));
    }

    @Test
    public void rejectsNonAsciiDigits() {
        // Arabic-Indic digits must not be sent to the server as a "valid" number.
        assertNull(PhoneNumberNormalizer.normalize("07١٢345678"));
    }

    @Test
    public void isValidMirrorsNormalize() {
        assertTrue(PhoneNumberNormalizer.isValid("0712 345 678"));
        assertFalse(PhoneNumberNormalizer.isValid("12345"));
    }
}
