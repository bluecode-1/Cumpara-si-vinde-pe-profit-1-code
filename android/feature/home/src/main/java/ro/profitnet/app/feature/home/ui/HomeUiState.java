package ro.profitnet.app.feature.home.ui;

import java.util.Objects;

/** Immutable state of the provisional Home screen. */
public final class HomeUiState {

    private final String displayName;
    private final boolean loggingOut;

    public HomeUiState(String displayName, boolean loggingOut) {
        this.displayName = displayName == null ? "" : displayName;
        this.loggingOut = loggingOut;
    }

    public static HomeUiState initial() {
        return new HomeUiState("", false);
    }

    /** Name for the greeting; empty until it is known. */
    public String getDisplayName() {
        return displayName;
    }

    public boolean isLoggingOut() {
        return loggingOut;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof HomeUiState)) {
            return false;
        }
        HomeUiState other = (HomeUiState) o;
        return loggingOut == other.loggingOut && displayName.equals(other.displayName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(displayName, loggingOut);
    }
}
