package ro.profitnet.app.feature.onboarding.ui.code;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;
import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Event;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.ErrorMessages;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.feature.onboarding.domain.RequestOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.VerifyOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;

@HiltViewModel
public class CodeViewModel extends ViewModel {

    /** Navigation argument names; must match the arguments of the code destination. */
    static final String ARG_PHONE = "phone";
    static final String ARG_CHALLENGE_ID = "challengeId";
    static final String ARG_RETRY_AFTER_SECONDS = "retryAfterSeconds";

    /** Used when a rate limit is hit and the server gave no usable waiting time. */
    private static final int DEFAULT_RETRY_AFTER_SECONDS = 30;

    private final VerifyOtpUseCase verifyOtp;
    private final RequestOtpUseCase requestOtp;
    private final Countdown countdown;
    private final AppExecutors executors;
    private final SavedStateHandle savedStateHandle;

    private final String phone;
    private String challengeId;
    private int retryAfterSeconds;

    private final MutableLiveData<CodeUiState> state;
    private final MutableLiveData<Event<CodeDestination>> navigation = new MutableLiveData<>();
    private final MutableLiveData<Event<Boolean>> clearCode = new MutableLiveData<>();

    @Inject
    public CodeViewModel(VerifyOtpUseCase verifyOtp, RequestOtpUseCase requestOtp,
            Countdown countdown, AppExecutors executors, SavedStateHandle savedStateHandle) {
        this.verifyOtp = verifyOtp;
        this.requestOtp = requestOtp;
        this.countdown = countdown;
        this.executors = executors;
        this.savedStateHandle = savedStateHandle;

        this.phone = requireArg(savedStateHandle, ARG_PHONE);
        this.challengeId = requireArg(savedStateHandle, ARG_CHALLENGE_ID);
        Integer retry = savedStateHandle.get(ARG_RETRY_AFTER_SECONDS);
        this.retryAfterSeconds = retry == null ? 0 : Math.max(0, retry);

        this.state = new MutableLiveData<>(
                new CodeUiState(phone, false, false, null, retryAfterSeconds));
        startCountdown(retryAfterSeconds);
    }

    public LiveData<CodeUiState> getState() {
        return state;
    }

    /** Fired once after a successful verification. */
    public LiveData<Event<CodeDestination>> getNavigation() {
        return navigation;
    }

    /** Fired when the input field must be emptied (wrong or expired code). */
    public LiveData<Event<Boolean>> getClearCode() {
        return clearCode;
    }

    /** Called on every edit; the code is submitted automatically at the 6th digit. */
    public void onCodeChanged(String code) {
        CodeUiState current = current();
        if (current.isVerifying()) {
            return;
        }
        if (VerifyOtpUseCase.isCompleteCode(code)) {
            verify(code);
        } else if (code != null && !code.isEmpty() && current.getErrorMessage() != null) {
            // The user started typing a new code: the old error no longer applies.
            state.setValue(current.withErrorMessage(null));
        }
    }

    public void onResendClicked() {
        CodeUiState current = current();
        if (!current.canResend()) {
            return;
        }
        state.setValue(current.withResending(true).withErrorMessage(null));
        executors.io().execute(() -> {
            Result<OtpRequest> result = requestOtp.execute(phone);
            executors.main().execute(() -> onResendResult(result));
        });
    }

    private void verify(String code) {
        state.setValue(current().withVerifying(true).withErrorMessage(null));
        final String challenge = challengeId;
        executors.io().execute(() -> {
            Result<AuthSession> result = verifyOtp.execute(challenge, code);
            executors.main().execute(() -> onVerifyResult(result));
        });
    }

    private void onVerifyResult(Result<AuthSession> result) {
        if (result.isSuccess()) {
            countdown.cancel();
            state.setValue(current().withVerifying(false));
            navigation.setValue(new Event<>(
                    result.getValue().getUser().isOnboardingCompleted()
                            ? CodeDestination.HOME
                            : CodeDestination.CONSENTS));
            return;
        }
        AppError error = result.getError();
        state.setValue(current().withVerifying(false)
                .withErrorMessage(ErrorMessages.forError(error)));
        if (error.hasCode(AppError.CODE_OTP_INVALID)) {
            clearCode.setValue(new Event<>(Boolean.TRUE));
        } else if (error.hasCode(AppError.CODE_RATE_LIMITED)) {
            clearCode.setValue(new Event<>(Boolean.TRUE));
            blockResendAfterRateLimit();
        }
    }

    private void onResendResult(Result<OtpRequest> result) {
        if (result.isSuccess()) {
            challengeId = result.getValue().getChallenge().getChallengeId();
            retryAfterSeconds = result.getValue().getChallenge().getRetryAfterSeconds();
            savedStateHandle.set(ARG_CHALLENGE_ID, challengeId);
            savedStateHandle.set(ARG_RETRY_AFTER_SECONDS, retryAfterSeconds);
            state.setValue(current().withResending(false));
            startCountdown(retryAfterSeconds);
            return;
        }
        AppError error = result.getError();
        state.setValue(current().withResending(false)
                .withErrorMessage(ErrorMessages.forError(error)));
        if (error.hasCode(AppError.CODE_RATE_LIMITED)) {
            blockResendAfterRateLimit();
        }
    }

    /** Rate limited: resending stays blocked until a countdown has run out. */
    private void blockResendAfterRateLimit() {
        if (current().getSecondsUntilResend() == 0) {
            startCountdown(retryAfterSeconds > 0 ? retryAfterSeconds : DEFAULT_RETRY_AFTER_SECONDS);
        }
    }

    private void startCountdown(int seconds) {
        countdown.start(seconds,
                remaining -> state.setValue(current().withSecondsUntilResend(remaining)));
    }

    @NonNull
    private CodeUiState current() {
        CodeUiState value = state.getValue();
        if (value == null) {
            throw new IllegalStateException("State is always initialised");
        }
        return value;
    }

    private static String requireArg(SavedStateHandle handle, String name) {
        String value = handle.get(name);
        if (value == null) {
            throw new IllegalArgumentException("Missing navigation argument: " + name);
        }
        return value;
    }

    @Override
    protected void onCleared() {
        countdown.cancel();
    }
}
