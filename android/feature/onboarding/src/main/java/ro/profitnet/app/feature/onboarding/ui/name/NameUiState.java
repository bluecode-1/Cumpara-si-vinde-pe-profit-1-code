package ro.profitnet.app.feature.onboarding.ui.name;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.Objects;

/** Immutable state of the display name screen. */
public final class NameUiState {

    private final boolean loading;
    @Nullable
    @StringRes
    private final Integer errorMessage;

    public NameUiState(boolean loading, @Nullable @StringRes Integer errorMessage) {
        this.loading = loading;
        this.errorMessage = errorMessage;
    }

    public static NameUiState initial() {
        return new NameUiState(false, null);
    }

    public boolean isLoading() {
        return loading;
    }

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
        if (!(o instanceof NameUiState)) {
            return false;
        }
        NameUiState other = (NameUiState) o;
        return loading == other.loading && Objects.equals(errorMessage, other.errorMessage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(loading, errorMessage);
    }
}
