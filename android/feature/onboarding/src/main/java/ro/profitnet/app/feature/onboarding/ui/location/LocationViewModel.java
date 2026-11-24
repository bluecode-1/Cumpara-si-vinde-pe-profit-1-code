package ro.profitnet.app.feature.onboarding.ui.location;

import androidx.annotation.StringRes;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import java.util.List;
import java.util.function.Supplier;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.ErrorMessages;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.domain.OnboardingErrors;
import ro.profitnet.app.feature.onboarding.domain.SaveHomeLocationUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.Cities;
import ro.profitnet.app.feature.onboarding.domain.model.City;

@HiltViewModel
public class LocationViewModel extends ViewModel {

    private final SaveHomeLocationUseCase saveHomeLocation;
    private final AppExecutors executors;

    private final MutableLiveData<LocationUiState> state =
            new MutableLiveData<>(LocationUiState.initial());
    private final MutableLiveData<Event<Boolean>> saved = new MutableLiveData<>();

    @Inject
    public LocationViewModel(SaveHomeLocationUseCase saveHomeLocation, AppExecutors executors) {
        this.saveHomeLocation = saveHomeLocation;
        this.executors = executors;
    }

    public LiveData<LocationUiState> getState() {
        return state;
    }

    /** Fired once when the home area was saved. */
    public LiveData<Event<Boolean>> getSaved() {
        return saved;
    }

    /** Cities offered for manual selection. */
    public List<City> getCities() {
        return Cities.ALL;
    }

    /** Result of the location permission request (or of the check, if already granted). */
    public void onPermissionResult(boolean granted) {
        if (!granted) {
            // Not a dead end: the user can still pick a city.
            state.setValue(new LocationUiState(false, R.string.location_denied));
            return;
        }
        run(saveHomeLocation::fromDeviceLocation);
    }

    public void onCitySelected(City city) {
        run(() -> saveHomeLocation.fromCity(city));
    }

    private void run(Supplier<Result<Void>> work) {
        LocationUiState current = state.getValue();
        if (current != null && current.isLoading()) {
            return;
        }
        state.setValue(new LocationUiState(true, null));
        executors.io().execute(() -> {
            Result<Void> result = work.get();
            executors.main().execute(() -> onResult(result));
        });
    }

    private void onResult(Result<Void> result) {
        if (result.isSuccess()) {
            state.setValue(LocationUiState.initial());
            saved.setValue(new Event<>(Boolean.TRUE));
        } else {
            state.setValue(new LocationUiState(false, messageFor(result.getError())));
        }
    }

    @StringRes
    private static int messageFor(AppError error) {
        if (error.hasCode(OnboardingErrors.LOCATION_UNAVAILABLE)) {
            return R.string.location_unavailable;
        }
        return ErrorMessages.forError(error);
    }
}
