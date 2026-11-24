package ro.profitnet.app.feature.onboarding.ui.interests;

import androidx.annotation.Nullable;
import androidx.annotation.StringRes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

import ro.profitnet.app.core.model.Category;

/** Immutable state of the interests screen. */
public final class InterestsUiState {

    private final boolean loadingCategories;
    private final boolean categoriesFailed;
    private final List<Category> categories;
    private final Set<String> selectedIds;
    private final boolean saving;
    @Nullable
    @StringRes
    private final Integer errorMessage;

    public InterestsUiState(boolean loadingCategories, boolean categoriesFailed,
            List<Category> categories, Set<String> selectedIds, boolean saving,
            @Nullable @StringRes Integer errorMessage) {
        this.loadingCategories = loadingCategories;
        this.categoriesFailed = categoriesFailed;
        this.categories = Collections.unmodifiableList(new ArrayList<>(categories));
        this.selectedIds = Collections.unmodifiableSet(new LinkedHashSet<>(selectedIds));
        this.saving = saving;
        this.errorMessage = errorMessage;
    }

    public static InterestsUiState loading() {
        return new InterestsUiState(true, false, Collections.emptyList(),
                Collections.emptySet(), false, null);
    }

    public boolean isLoadingCategories() {
        return loadingCategories;
    }

    /** The categories could not be loaded; a retry is offered (skipping still works). */
    public boolean isCategoriesFailed() {
        return categoriesFailed;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public Set<String> getSelectedIds() {
        return selectedIds;
    }

    public boolean isSaving() {
        return saving;
    }

    @Nullable
    @StringRes
    public Integer getErrorMessage() {
        return errorMessage;
    }

    public boolean isBusy() {
        return loadingCategories || saving;
    }

    InterestsUiState withSelectedIds(Set<String> value) {
        return new InterestsUiState(loadingCategories, categoriesFailed, categories, value, saving,
                errorMessage);
    }

    InterestsUiState withSaving(boolean value, @Nullable @StringRes Integer error) {
        return new InterestsUiState(loadingCategories, categoriesFailed, categories, selectedIds,
                value, error);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof InterestsUiState)) {
            return false;
        }
        InterestsUiState other = (InterestsUiState) o;
        return loadingCategories == other.loadingCategories
                && categoriesFailed == other.categoriesFailed
                && saving == other.saving
                && categories.equals(other.categories)
                && selectedIds.equals(other.selectedIds)
                && Objects.equals(errorMessage, other.errorMessage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(loadingCategories, categoriesFailed, categories, selectedIds, saving,
                errorMessage);
    }
}
