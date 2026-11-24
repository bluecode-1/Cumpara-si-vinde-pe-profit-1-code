package ro.profitnet.app;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.security.SessionManager;

/**
 * Activity-level state: the start destination (resolved once, off the main thread) and the
 * "session expired" signal raised when the server rejects the refresh token.
 */
@HiltViewModel
public class MainViewModel extends ViewModel {

    private final SessionManager sessionManager;
    private final MutableLiveData<StartDestination> startDestination = new MutableLiveData<>();
    private final MutableLiveData<Event<Boolean>> sessionExpired = new MutableLiveData<>();
    private final SessionManager.SessionExpiredListener expiredListener;

    @Inject
    public MainViewModel(StartDestinationResolver resolver, SessionManager sessionManager,
            OnboardingProgressDao progressDao, AppExecutors executors) {
        this.sessionManager = sessionManager;
        // Called on a network thread, right after the tokens were cleared.
        this.expiredListener = () -> {
            progressDao.clear();
            executors.main().execute(() -> sessionExpired.setValue(new Event<>(Boolean.TRUE)));
        };
        sessionManager.addSessionExpiredListener(expiredListener);

        executors.io().execute(() -> {
            StartDestination resolved = resolver.resolve();
            executors.main().execute(() -> startDestination.setValue(resolved));
        });
    }

    public LiveData<StartDestination> getStartDestination() {
        return startDestination;
    }

    /** Fired once per expiry: the UI must return to the welcome screen. */
    public LiveData<Event<Boolean>> getSessionExpired() {
        return sessionExpired;
    }

    @Override
    protected void onCleared() {
        sessionManager.removeSessionExpiredListener(expiredListener);
    }
}
