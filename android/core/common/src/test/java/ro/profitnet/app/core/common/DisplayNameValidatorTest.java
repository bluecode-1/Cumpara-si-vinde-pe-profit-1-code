package ro.profitnet.app.core.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class DisplayNameValidatorTest {

    @Test
    public void acceptsBoundaryLengths() {
        assertEquals("Io", DisplayNameValidator.normalize("Io"));
        String forty = "a".repeat(40);
        assertEquals(forty, DisplayNameValidator.normalize(forty));
    }

    @Test
    public void rejectsTooShortAndTooLong() {
        assertNull(DisplayNameValidator.normalize("I"));
        assertNull(DisplayNameValidator.normalize("a".repeat(41)));
    }

    @Test
    public void rejectsNullEmptyAndBlank() {
        assertNull(DisplayNameValidator.normalize(null));
        assertNull(DisplayNameValidator.normalize(""));
        assertNull(DisplayNameValidator.normalize("      "));
    }

    @Test
    public void trimsSurroundingWhitespaceBeforeCounting() {
        assertEquals("Ioana", DisplayNameValidator.normalize("  Ioana \n"));
        assertNull(DisplayNameValidator.normalize("  I  "));
        assertEquals("a".repeat(40), DisplayNameValidator.normalize(" " + "a".repeat(40) + " "));
    }

    @Test
    public void keepsInnerSpacesAndDiacritics() {
        assertEquals("Ștefan cel Mare", DisplayNameValidator.normalize("Ștefan cel Mare"));
    }

    @Test
    public void countsCodePointsNotUtf16Units() {
        // Each emoji is two UTF-16 units but one character for the user.
        String twentyOneEmoji = "😀".repeat(21);
        assertEquals(twentyOneEmoji, DisplayNameValidator.normalize(twentyOneEmoji));
        assertNull(DisplayNameValidator.normalize("😀"));
    }

    @Test
    public void isValidMirrorsNormalize() {
        assertTrue(DisplayNameValidator.isValid("Ana"));
        assertFalse(DisplayNameValidator.isValid("A"));
    }
}
