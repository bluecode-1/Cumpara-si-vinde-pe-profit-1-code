package ro.profitnet.app.feature.onboarding.ui;

/** Display formatting for Romanian mobile numbers in E.164. */
public final class PhoneFormatter {

    private static final String PREFIX = "+40";
    private static final int NATIONAL_LENGTH = 9;

    private PhoneFormatter() {
    }

    /** {@code +40712345678} becomes {@code +40 712 345 678}; other input is returned as is. */
    public static String forDisplay(String e164) {
        String national = nationalPart(e164);
        if (national == null) {
            return e164 == null ? "" : e164;
        }
        return PREFIX + ' ' + national.substring(0, 3) + ' ' + national.substring(3, 6) + ' '
                + national.substring(6);
    }

    /** {@code +40712345678} becomes {@code 712345678}; {@code null} for any other shape. */
    public static String nationalPart(String e164) {
        if (e164 == null || !e164.startsWith(PREFIX)
                || e164.length() != PREFIX.length() + NATIONAL_LENGTH) {
            return null;
        }
        return e164.substring(PREFIX.length());
    }
}
