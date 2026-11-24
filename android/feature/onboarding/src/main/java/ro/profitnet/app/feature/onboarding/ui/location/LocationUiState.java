package ro.profitnet.app.feature.onboarding.ui.location;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.Objects;

/** Immutable state of the location screen. */
public final class LocationUiState {

    private final boolean loading;
    @Nullable
    @StringRes
    private final Integer message;

    public LocationUiState(boolean loading, @Nullable @StringRes Integer message) {
        this.loading = loading;
        this.message = message;
    }

    public static LocationUiState initial() {
        return new LocationUiState(false, null);
    }

    public boolean isLoading() {
        return loading;
    }

    /** Notice shown under the buttons (permission denied, no fix, server error). */
    @Nullable
    @StringRes
    public Integer getMessage() {
        return message;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof LocationUiState)) {
            return false;
        }
        LocationUiState other = (LocationUiState) o;
        return loading == other.loading && Objects.equals(message, other.message);
    }

    @Override
    public int hashCode() {
        return Objects.hash(loading, message);
    }
}
