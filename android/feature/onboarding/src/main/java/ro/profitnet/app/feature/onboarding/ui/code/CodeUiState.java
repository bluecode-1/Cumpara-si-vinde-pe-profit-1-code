package ro.profitnet.app.feature.onboarding.ui.code;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.Objects;

/** Immutable state of the code screen. */
public final class CodeUiState {

    private final String phone;
    private final boolean verifying;
    private final boolean resending;
    @Nullable
    @StringRes
    private final Integer errorMessage;
    private final int secondsUntilResend;

    public CodeUiState(String phone, boolean verifying, boolean resending,
            @Nullable @StringRes Integer errorMessage, int secondsUntilResend) {
        this.phone = Objects.requireNonNull(phone, "phone");
        this.verifying = verifying;
        this.resending = resending;
        this.errorMessage = errorMessage;
        this.secondsUntilResend = Math.max(0, secondsUntilResend);
    }

    /** Phone number in E.164 the code was sent to. */
    public String getPhone() {
        return phone;
    }

    public boolean isVerifying() {
        return verifying;
    }

    public boolean isResending() {
        return resending;
    }

    public boolean isBusy() {
        return verifying || resending;
    }

    @Nullable
    @StringRes
    public Integer getErrorMessage() {
        return errorMessage;
    }

    /** Seconds left before another code may be requested; 0 when resending is allowed. */
    public int getSecondsUntilResend() {
        return secondsUntilResend;
    }

    public boolean canResend() {
        return secondsUntilResend == 0 && !isBusy();
    }

    CodeUiState withVerifying(boolean value) {
        return new CodeUiState(phone, value, resending, errorMessage, secondsUntilResend);
    }

    CodeUiState withResending(boolean value) {
        return new CodeUiState(phone, verifying, value, errorMessage, secondsUntilResend);
    }

    CodeUiState withErrorMessage(@Nullable @StringRes Integer value) {
        return new CodeUiState(phone, verifying, resending, value, secondsUntilResend);
    }

    CodeUiState withSecondsUntilResend(int value) {
        return new CodeUiState(phone, verifying, resending, errorMessage, value);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof CodeUiState)) {
            return false;
        }
        CodeUiState other = (CodeUiState) o;
        return verifying == other.verifying && resending == other.resending
                && secondsUntilResend == other.secondsUntilResend
                && phone.equals(other.phone)
                && Objects.equals(errorMessage, other.errorMessage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(phone, verifying, resending, errorMessage, secondsUntilResend);
    }
}
