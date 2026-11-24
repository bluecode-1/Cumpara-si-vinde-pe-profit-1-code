package ro.profitnet.app.feature.onboarding.ui.phone;

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
import ro.profitnet.app.feature.onboarding.domain.GetOnboardingProgressUseCase;
import ro.profitnet.app.feature.onboarding.domain.OnboardingErrors;
import ro.profitnet.app.feature.onboarding.domain.RequestOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;
import ro.profitnet.app.feature.onboarding.ui.PhoneFormatter;

@HiltViewModel
public class PhoneViewModel extends ViewModel {

    private final RequestOtpUseCase requestOtp;
    private final AppExecutors executors;

    private final MutableLiveData<PhoneUiState> state =
            new MutableLiveData<>(PhoneUiState.initial());
    private final MutableLiveData<Event<CodeSent>> codeSent = new MutableLiveData<>();
    private final MutableLiveData<Event<String>> prefill = new MutableLiveData<>();

    @Inject
    public PhoneViewModel(RequestOtpUseCase requestOtp,
            GetOnboardingProgressUseCase getProgress, AppExecutors executors) {
        this.requestOtp = requestOtp;
        this.executors = executors;
        // Offer the number entered in an earlier, interrupted attempt.
        executors.io().execute(() -> {
            String national = PhoneFormatter.nationalPart(getProgress.execute().getPhone());
            if (national != null) {
                executors.main().execute(() -> prefill.setValue(new Event<>(national)));
            }
        });
    }

    public LiveData<PhoneUiState> getState() {
        return state;
    }

    /** Fired once when the code was sent. */
    public LiveData<Event<CodeSent>> getCodeSent() {
        return codeSent;
    }

    /** National part of a previously entered number, to prefill an empty field. */
    public LiveData<Event<String>> getPrefill() {
        return prefill;
    }

    public void onPhoneEdited() {
        PhoneUiState current = state.getValue();
        if (current != null && current.getErrorMessage() != null && !current.isLoading()) {
            state.setValue(new PhoneUiState(false, null));
        }
    }

    public void onSubmit(String phoneInput) {
        PhoneUiState current = state.getValue();
        if (current != null && current.isLoading()) {
            return;
        }
        state.setValue(new PhoneUiState(true, null));
        executors.io().execute(() -> {
            Result<OtpRequest> result = requestOtp.execute(phoneInput);
            executors.main().execute(() -> onResult(result));
        });
    }

    private void onResult(Result<OtpRequest> result) {
        if (result.isSuccess()) {
            OtpRequest request = result.getValue();
            state.setValue(new PhoneUiState(false, null));
            codeSent.setValue(new Event<>(new CodeSent(request.getPhone(),
                    request.getChallenge().getChallengeId(),
                    request.getChallenge().getRetryAfterSeconds())));
        } else {
            state.setValue(new PhoneUiState(false, messageFor(result.getError())));
        }
    }

    @StringRes
    private static int messageFor(AppError error) {
        if (error.hasCode(OnboardingErrors.PHONE_INVALID)) {
            return R.string.phone_error_invalid;
        }
        return ErrorMessages.forError(error);
    }
}
