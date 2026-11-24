package ro.profitnet.app.feature.onboarding.ui.consents;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.Objects;

import ro.profitnet.app.feature.onboarding.domain.model.ConsentSelection;

/** Immutable state of the consents screen. */
public final class ConsentsUiState {

    private final ConsentSelection selection;
    private final boolean loading;
    @Nullable
    @StringRes
    private final Integer errorMessage;

    public ConsentsUiState(ConsentSelection selection, boolean loading,
            @Nullable @StringRes Integer errorMessage) {
        this.selection = Objects.requireNonNull(selection, "selection");
        this.loading = loading;
        this.errorMessage = errorMessage;
    }

    /** Nothing is ticked initially: consent is never assumed. */
    public static ConsentsUiState initial() {
        return new ConsentsUiState(ConsentSelection.none(), false, null);
    }

    public ConsentSelection getSelection() {
        return selection;
    }

    public boolean isLoading() {
        return loading;
    }

    @Nullable
    @StringRes
    public Integer getErrorMessage() {
        return errorMessage;
    }

    /** Continue is available once both required consents are ticked. */
    public boolean canContinue() {
        return selection.hasRequired() && !loading;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof ConsentsUiState)) {
            return false;
        }
        ConsentsUiState other = (ConsentsUiState) o;
        return loading == other.loading && selection.equals(other.selection)
                && Objects.equals(errorMessage, other.errorMessage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(selection, loading, errorMessage);
    }
}
