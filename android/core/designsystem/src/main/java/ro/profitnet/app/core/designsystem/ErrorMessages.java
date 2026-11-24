package ro.profitnet.app.core.designsystem;

import androidx.annotation.StringRes;

import ro.profitnet.app.core.common.AppError;

/**
 * Maps an {@link AppError} to the text shown to the user. The text always comes from the app's
 * string resources, chosen by the error code; server-provided text is never displayed.
 */
public final class ErrorMessages {

    private ErrorMessages() {
    }

    @StringRes
    public static int forError(AppError error) {
        switch (error.getCode()) {
            case AppError.CODE_OTP_INVALID:
                return R.string.error_otp_invalid;
            case AppError.CODE_RATE_LIMITED:
                return R.string.error_rate_limited;
            case AppError.CODE_NETWORK:
                return R.string.error_network;
            default:
                return R.string.error_generic;
        }
    }
}
