package ro.profitnet.app.feature.onboarding.ui.name;

import androidx.annotation.StringRes;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.ErrorMessages;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.domain.OnboardingErrors;
import ro.profitnet.app.feature.onboarding.domain.SaveDisplayNameUseCase;

@HiltViewModel
public class NameViewModel extends ViewModel {

    private final SaveDisplayNameUseCase saveDisplayName;
    private final AppExecutors executors;

    private final MutableLiveData<NameUiState> state = new MutableLiveData<>(NameUiState.initial());
    private final MutableLiveData<Event<Boolean>> saved = new MutableLiveData<>();

    @Inject
    public NameViewModel(SaveDisplayNameUseCase saveDisplayName, AppExecutors executors) {
        this.saveDisplayName = saveDisplayName;
        this.executors = executors;
    }

    public LiveData<NameUiState> getState() {
        return state;
    }

    /** Fired once when the name was saved. */
    public LiveData<Event<Boolean>> getSaved() {
        return saved;
    }

    public void onNameEdited() {
        NameUiState current = state.getValue();
        if (current != null && current.getErrorMessage() != null && !current.isLoading()) {
            state.setValue(NameUiState.initial());
        }
    }

    public void onSubmit(String nameInput) {
        NameUiState current = state.getValue();
        if (current != null && current.isLoading()) {
            return;
        }
        state.setValue(new NameUiState(true, null));
        executors.io().execute(() -> {
            Result<Void> result = saveDisplayName.execute(nameInput);
            executors.main().execute(() -> onResult(result));
        });
    }

    private void onResult(Result<Void> result) {
        if (result.isSuccess()) {
            state.setValue(NameUiState.initial());
            saved.setValue(new Event<>(Boolean.TRUE));
        } else {
            state.setValue(new NameUiState(false, messageFor(result.getError())));
        }
    }

    @StringRes
    private static int messageFor(AppError error) {
        if (error.hasCode(OnboardingErrors.NAME_INVALID)) {
            return R.string.name_error_length;
        }
        return ErrorMessages.forError(error);
    }
}
