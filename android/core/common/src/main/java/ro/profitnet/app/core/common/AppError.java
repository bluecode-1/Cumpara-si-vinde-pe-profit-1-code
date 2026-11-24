package ro.profitnet.app.core.common;

import java.util.Objects;

/**
 * The single error type used across the app. {@code code} is the stable machine-readable code
 * from an {@code application/problem+json} body (or one of the client-side codes below);
 * user-facing text is looked up from string resources by code and never comes from the server.
 */
public final class AppError {

    /** Server code: the SMS code is wrong or expired. */
    public static final String CODE_OTP_INVALID = "OTP_INVALID";
    /** Server code: too many attempts. */
    public static final String CODE_RATE_LIMITED = "RATE_LIMITED";
    /** Client code: the request never reached the server (no connectivity, timeout). */
    public static final String CODE_NETWORK = "NETWORK";
    /** Client code: the session is gone (refresh failed) and the user must sign in again. */
    public static final String CODE_UNAUTHORIZED = "UNAUTHORIZED";
    /** Client code: the response could not be understood or carried no problem code. */
    public static final String CODE_UNKNOWN = "UNKNOWN";

    /** HTTP status used when no HTTP exchange took place. */
    public static final int NO_HTTP_STATUS = 0;

    private final String code;
    private final int httpStatus;

    public AppError(String code, int httpStatus) {
        this.code = Objects.requireNonNull(code, "code");
        this.httpStatus = httpStatus;
    }

    public static AppError network() {
        return new AppError(CODE_NETWORK, NO_HTTP_STATUS);
    }

    public static AppError unknown(int httpStatus) {
        return new AppError(CODE_UNKNOWN, httpStatus);
    }

    public static AppError local(String code) {
        return new AppError(code, NO_HTTP_STATUS);
    }

    public String getCode() {
        return code;
    }

    public int getHttpStatus() {
        return httpStatus;
    }

    public boolean hasCode(String other) {
        return code.equals(other);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof AppError)) {
            return false;
        }
        AppError other = (AppError) o;
        return httpStatus == other.httpStatus && code.equals(other.code);
    }

    @Override
    public int hashCode() {
        return Objects.hash(code, httpStatus);
    }

    @Override
    public String toString() {
        return "AppError{code='" + code + "', httpStatus=" + httpStatus + '}';
    }
}
