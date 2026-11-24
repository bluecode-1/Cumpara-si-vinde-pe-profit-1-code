package ro.profitnet.app.core.designsystem;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import ro.profitnet.app.core.common.AppError;

public class ErrorMessagesTest {

    @Test
    public void knownCodesHaveTheirOwnMessage() {
        assertEquals(R.string.error_otp_invalid,
                ErrorMessages.forError(new AppError(AppError.CODE_OTP_INVALID, 422)));
        assertEquals(R.string.error_rate_limited,
                ErrorMessages.forError(new AppError(AppError.CODE_RATE_LIMITED, 429)));
        assertEquals(R.string.error_network, ErrorMessages.forError(AppError.network()));
    }

    @Test
    public void everythingElseIsGeneric() {
        assertEquals(R.string.error_generic, ErrorMessages.forError(AppError.unknown(500)));
        assertEquals(R.string.error_generic,
                ErrorMessages.forError(new AppError("SOME_NEW_SERVER_CODE", 409)));
        assertEquals(R.string.error_generic,
                ErrorMessages.forError(new AppError(AppError.CODE_UNAUTHORIZED, 401)));
    }
}
