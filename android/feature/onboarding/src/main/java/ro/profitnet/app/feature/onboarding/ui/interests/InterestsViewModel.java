package ro.profitnet.app.feature.onboarding.ui.interests;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.ErrorMessages;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.feature.onboarding.domain.CompleteOnboardingUseCase;
import ro.profitnet.app.feature.onboarding.domain.GetInterestCategoriesUseCase;

@HiltViewModel
public class InterestsViewModel extends ViewModel {

    private final GetInterestCategoriesUseCase getCategories;
    private final CompleteOnboardingUseCase completeOnboarding;
    private final AppExecutors executors;

    private final MutableLiveData<InterestsUiState> state =
            new MutableLiveData<>(InterestsUiState.loading());
    private final MutableLiveData<Event<Boolean>> completed = new MutableLiveData<>();

    @Inject
    public InterestsViewModel(GetInterestCategoriesUseCase getCategories,
            CompleteOnboardingUseCase completeOnboarding, AppExecutors executors) {
        this.getCategories = getCategories;
        this.completeOnboarding = completeOnboarding;
        this.executors = executors;
        loadCategories();
    }

    public LiveData<InterestsUiState> getState() {
        return state;
    }

    /** Fired once when onboarding was completed. */
    public LiveData<Event<Boolean>> getCompleted() {
        return completed;
    }

    public void onRetry() {
        InterestsUiState current = current();
        if (current.isCategoriesFailed() && !current.isBusy()) {
            loadCategories();
        }
    }

    public void onCategoryToggled(String categoryId, boolean selected) {
        InterestsUiState current = current();
        if (current.getSelectedIds().contains(categoryId) == selected) {
            return;
        }
        Set<String> ids = new LinkedHashSet<>(current.getSelectedIds());
        if (selected) {
            ids.add(categoryId);
        } else {
            ids.remove(categoryId);
        }
        state.setValue(current.withSelectedIds(ids));
    }

    /** "Done": saves the selection and completes onboarding. */
    public void onFinish() {
        complete(current().getSelectedIds());
    }

    /** "Skip": completes onboarding without interests. */
    public void onSkip() {
        complete(Collections.emptySet());
    }

    private void complete(Collection<String> interestIds) {
        InterestsUiState current = current();
        if (current.isSaving()) {
            return;
        }
        state.setValue(current.withSaving(true, null));
        executors.io().execute(() -> {
            Result<Void> result = completeOnboarding.execute(interestIds);
            executors.main().execute(() -> {
                if (result.isSuccess()) {
                    state.setValue(current().withSaving(false, null));
                    completed.setValue(new Event<>(Boolean.TRUE));
                } else {
                    state.setValue(current().withSaving(false,
                            ErrorMessages.forError(result.getError())));
                }
            });
        });
    }

    private void loadCategories() {
        state.setValue(InterestsUiState.loading());
        executors.io().execute(() -> {
            Result<List<Category>> result = getCategories.execute();
            executors.main().execute(() -> {
                if (result.isSuccess()) {
                    state.setValue(new InterestsUiState(false, false, result.getValue(),
                            Collections.emptySet(), false, null));
                } else {
                    state.setValue(new InterestsUiState(false, true, Collections.emptyList(),
                            Collections.emptySet(), false,
                            ErrorMessages.forError(result.getError())));
                }
            });
        });
    }

    @NonNull
    private InterestsUiState current() {
        InterestsUiState value = state.getValue();
        return value == null ? InterestsUiState.loading() : value;
    }
}
