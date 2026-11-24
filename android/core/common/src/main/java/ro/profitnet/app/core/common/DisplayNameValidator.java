package ro.profitnet.app.core.common;

/** Display name rule: 2 to 40 characters after trimming surrounding whitespace. */
public final class DisplayNameValidator {

    public static final int MIN_LENGTH = 2;
    public static final int MAX_LENGTH = 40;

    private DisplayNameValidator() {
    }

    /**
     * @return the trimmed name if it is valid, otherwise {@code null}. Length is counted in
     *         Unicode code points so that characters outside the BMP count once.
     */
    public static String normalize(String input) {
        if (input == null) {
            return null;
        }
        String trimmed = input.strip();
        int length = trimmed.codePointCount(0, trimmed.length());
        if (length < MIN_LENGTH || length > MAX_LENGTH) {
            return null;
        }
        return trimmed;
    }

    public static boolean isValid(String input) {
        return normalize(input) != null;
    }
}
