package ro.profitnet.app.core.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class ResultTest {

    @Test
    public void successCarriesValue() {
        Result<String> result = Result.success("ok");
        assertTrue(result.isSuccess());
        assertFalse(result.isFailure());
        assertEquals("ok", result.getValue());
        assertThrows(IllegalStateException.class, result::getError);
    }

    @Test
    public void failureCarriesError() {
        AppError error = new AppError(AppError.CODE_OTP_INVALID, 422);
        Result<String> result = Result.failure(error);
        assertTrue(result.isFailure());
        assertEquals(error, result.getError());
        assertThrows(IllegalStateException.class, result::getValue);
    }

    @Test
    public void mapTransformsSuccessAndKeepsFailure() {
        assertEquals(Integer.valueOf(2), Result.success("ok").map(String::length).getValue());
        Result<Integer> failed = Result.<String>failure(AppError.network()).map(String::length);
        assertEquals(AppError.CODE_NETWORK, failed.getError().getCode());
    }

    @Test
    public void eventIsHandedOutOnce() {
        Event<String> event = new Event<>("go");
        assertEquals("go", event.getContentIfNotHandled());
        assertNull(event.getContentIfNotHandled());
        assertEquals("go", event.peekContent());
    }
}
