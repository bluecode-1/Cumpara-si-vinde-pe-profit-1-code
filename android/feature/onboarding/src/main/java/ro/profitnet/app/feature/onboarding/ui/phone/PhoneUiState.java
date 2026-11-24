package ro.profitnet.app.feature.onboarding.ui.phone;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.Objects;

/** Immutable state of the phone screen. */
public final class PhoneUiState {

    private final boolean loading;
    @Nullable
    @StringRes
    private final Integer errorMessage;

    public PhoneUiState(boolean loading, @Nullable @StringRes Integer errorMessage) {
        this.loading = loading;
        this.errorMessage = errorMessage;
    }

    public static PhoneUiState initial() {
        return new PhoneUiState(false, null);
    }

    public boolean isLoading() {
        return loading;
    }

    /** String resource of the error under the field, or {@code null} for none. */
    @Nullable
    @StringRes
    public Integer getErrorMessage() {
        return errorMessage;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof PhoneUiState)) {
            return false;
        }
        PhoneUiState other = (PhoneUiState) o;
        return loading == other.loading && Objects.equals(errorMessage, other.errorMessage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(loading, errorMessage);
    }

    @Override
    public String toString() {
        return "PhoneUiState{loading=" + loading + ", errorMessage=" + errorMessage + '}';
    }
}
