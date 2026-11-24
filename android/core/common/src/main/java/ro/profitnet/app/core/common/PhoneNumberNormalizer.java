package ro.profitnet.app.core.common;

import java.util.regex.Pattern;

/**
 * Validates Romanian mobile numbers and converts them to E.164.
 *
 * <p>Accepted input, with or without spaces: {@code 07XXXXXXXX}, {@code 7XXXXXXXX} and
 * {@code +407XXXXXXXX}. The normalized form is always {@code +407XXXXXXXX}. Anything else is
 * rejected.
 */
public final class PhoneNumberNormalizer {

    private static final String COUNTRY_PREFIX = "+40";
    private static final Pattern WHITESPACE = Pattern.compile("[\\s\\u00A0]+");
    private static final Pattern ACCEPTED = Pattern.compile("^(?:\\+40|0)?(7[0-9]{8})$");

    private PhoneNumberNormalizer() {
    }

    /**
     * @return the number in E.164 ({@code +407XXXXXXXX}), or {@code null} if the input is not an
     *         accepted Romanian mobile number.
     */
    public static String normalize(String input) {
        if (input == null) {
            return null;
        }
        String compact = WHITESPACE.matcher(input).replaceAll("");
        java.util.regex.Matcher matcher = ACCEPTED.matcher(compact);
        if (!matcher.matches()) {
            return null;
        }
        return COUNTRY_PREFIX + matcher.group(1);
    }

    public static boolean isValid(String input) {
        return normalize(input) != null;
    }
}
