package ro.profitnet.app.feature.onboarding.ui.consents;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.ErrorMessages;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.feature.onboarding.domain.SaveConsentsUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.ConsentSelection;

@HiltViewModel
public class ConsentsViewModel extends ViewModel {

    private final SaveConsentsUseCase saveConsents;
    private final AppExecutors executors;

    private final MutableLiveData<ConsentsUiState> state =
            new MutableLiveData<>(ConsentsUiState.initial());
    private final MutableLiveData<Event<Boolean>> saved = new MutableLiveData<>();

    @Inject
    public ConsentsViewModel(SaveConsentsUseCase saveConsents, AppExecutors executors) {
        this.saveConsents = saveConsents;
        this.executors = executors;
    }

    public LiveData<ConsentsUiState> getState() {
        return state;
    }

    /** Fired once when the consents were saved. */
    public LiveData<Event<Boolean>> getSaved() {
        return saved;
    }

    public void onConsentChanged(ConsentPurpose purpose, boolean granted) {
        ConsentsUiState current = current();
        ConsentSelection selection = current.getSelection();
        ConsentSelection updated;
        switch (purpose) {
            case TERMS:
                updated = selection.withTerms(granted);
                break;
            case PRIVACY:
                updated = selection.withPrivacy(granted);
                break;
            case MARKETING:
                updated = selection.withMarketing(granted);
                break;
            case ANALYTICS:
                updated = selection.withAnalytics(granted);
                break;
            case AI_PHOTO_PROCESSING:
                updated = selection.withAiPhotoProcessing(granted);
                break;
            default:
                // LOCATION is asked on the location screen.
                return;
        }
        if (!updated.equals(selection)) {
            state.setValue(new ConsentsUiState(updated, current.isLoading(),
                    current.getErrorMessage()));
        }
    }

    public void onContinue() {
        ConsentsUiState current = current();
        if (!current.canContinue()) {
            return;
        }
        ConsentSelection selection = current.getSelection();
        state.setValue(new ConsentsUiState(selection, true, null));
        executors.io().execute(() -> {
            Result<Void> result = saveConsents.execute(selection);
            executors.main().execute(() -> onResult(result));
        });
    }

    private void onResult(Result<Void> result) {
        ConsentSelection selection = current().getSelection();
        if (result.isSuccess()) {
            state.setValue(new ConsentsUiState(selection, false, null));
            saved.setValue(new Event<>(Boolean.TRUE));
        } else {
            state.setValue(new ConsentsUiState(selection, false,
                    ErrorMessages.forError(result.getError())));
        }
    }

    @NonNull
    private ConsentsUiState current() {
        ConsentsUiState value = state.getValue();
        return value == null ? ConsentsUiState.initial() : value;
    }
}
