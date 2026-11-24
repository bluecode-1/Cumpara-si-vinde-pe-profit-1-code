package ro.profitnet.app.feature.home.ui;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.feature.home.domain.GetDisplayNameUseCase;
import ro.profitnet.app.feature.home.domain.LogoutUseCase;

@HiltViewModel
public class HomeViewModel extends ViewModel {

    private final LogoutUseCase logout;
    private final AppExecutors executors;

    private final MutableLiveData<HomeUiState> state = new MutableLiveData<>(HomeUiState.initial());
    private final MutableLiveData<Event<Boolean>> loggedOut = new MutableLiveData<>();

    @Inject
    public HomeViewModel(GetDisplayNameUseCase getDisplayName, LogoutUseCase logout,
            AppExecutors executors) {
        this.logout = logout;
        this.executors = executors;
        executors.io().execute(() -> {
            String name = getDisplayName.execute();
            executors.main().execute(
                    () -> state.setValue(new HomeUiState(name, current().isLoggingOut())));
        });
    }

    public LiveData<HomeUiState> getState() {
        return state;
    }

    /** Fired once when the local session was removed. */
    public LiveData<Event<Boolean>> getLoggedOut() {
        return loggedOut;
    }

    public void onLogoutClicked() {
        HomeUiState current = current();
        if (current.isLoggingOut()) {
            return;
        }
        state.setValue(new HomeUiState(current.getDisplayName(), true));
        executors.io().execute(() -> {
            logout.execute();
            executors.main().execute(() -> {
                state.setValue(new HomeUiState(current().getDisplayName(), false));
                loggedOut.setValue(new Event<>(Boolean.TRUE));
            });
        });
    }

    @NonNull
    private HomeUiState current() {
        HomeUiState value = state.getValue();
        return value == null ? HomeUiState.initial() : value;
    }
}
