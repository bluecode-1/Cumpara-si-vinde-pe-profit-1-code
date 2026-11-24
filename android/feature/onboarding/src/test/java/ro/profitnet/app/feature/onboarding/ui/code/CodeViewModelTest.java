package ro.profitnet.app.feature.onboarding.ui.code;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import androidx.arch.core.executor.testing.InstantTaskExecutorRule;
import androidx.lifecycle.SavedStateHandle;

import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;

import org.junit.Rule;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.designsystem.R;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.core.model.TokenPair;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.RequestOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.VerifyOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;

public class CodeViewModelTest {

    private static final String PHONE = "+40712345678";
    private static final String CHALLENGE = "challenge-1";
    private static final int RETRY_AFTER = 30;

    /** Countdown driven by the test instead of a timer. */
    private static final class FakeCountdown implements Countdown {
        private Listener listener;
        int startedWith = -1;
        int starts;
        boolean cancelled;

        @Override
        public void start(int seconds, Listener newListener) {
            listener = newListener;
            startedWith = seconds;
            starts++;
            cancelled = false;
            newListener.onTick(seconds);
        }

        @Override
        public void cancel() {
            cancelled = true;
        }

        void tick(int secondsRemaining) {
            listener.onTick(secondsRemaining);
        }
    }

    @Rule
    public InstantTaskExecutorRule instantTaskExecutorRule = new InstantTaskExecutorRule();

    private final VerifyOtpUseCase verifyOtp = mock(VerifyOtpUseCase.class);
    private final RequestOtpUseCase requestOtp = mock(RequestOtpUseCase.class);
    private final FakeCountdown countdown = new FakeCountdown();
    private final AppExecutors direct = new AppExecutors(Runnable::run, Runnable::run);

    private CodeViewModel createViewModel(AppExecutors executors) {
        Map<String, Object> args = new HashMap<>();
        args.put(CodeViewModel.ARG_PHONE, PHONE);
        args.put(CodeViewModel.ARG_CHALLENGE_ID, CHALLENGE);
        args.put(CodeViewModel.ARG_RETRY_AFTER_SECONDS, RETRY_AFTER);
        return new CodeViewModel(verifyOtp, requestOtp, countdown, executors,
                new SavedStateHandle(args));
    }

    private CodeViewModel createViewModel() {
        return createViewModel(direct);
    }

    private static Result<AuthSession> session(boolean onboardingCompleted) {
        User user = User.builder("user-1").displayName(onboardingCompleted ? "Ioana" : "")
                .onboardingCompleted(onboardingCompleted).build();
        return Result.success(
                new AuthSession(new TokenPair("access", "refresh", 900), user,
                        !onboardingCompleted));
    }

    @Test
    public void startsWithCountdownFromRetryAfterSeconds() {
        CodeViewModel viewModel = createViewModel();

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(PHONE, state.getPhone());
        assertEquals(RETRY_AFTER, state.getSecondsUntilResend());
        assertFalse(state.canResend());
        assertNull(state.getErrorMessage());
        assertEquals(RETRY_AFTER, countdown.startedWith);
    }

    @Test
    public void doesNotSubmitBeforeSixDigits() {
        CodeViewModel viewModel = createViewModel();

        viewModel.onCodeChanged("1");
        viewModel.onCodeChanged("12345");

        verify(verifyOtp, never()).execute(anyString(), anyString());
        assertFalse(viewModel.getState().getValue().isVerifying());
    }

    @Test
    public void sixthDigitSubmitsAutomaticallyAndNewUserContinuesToConsents() {
        when(verifyOtp.execute(CHALLENGE, "123456")).thenReturn(session(false));
        CodeViewModel viewModel = createViewModel();

        viewModel.onCodeChanged("123456");

        verify(verifyOtp).execute(CHALLENGE, "123456");
        assertEquals(CodeDestination.CONSENTS,
                viewModel.getNavigation().getValue().getContentIfNotHandled());
        assertNull(viewModel.getNavigation().getValue().getContentIfNotHandled());
        assertFalse(viewModel.getState().getValue().isVerifying());
        assertNull(viewModel.getState().getValue().getErrorMessage());
        assertTrue(countdown.cancelled);
    }

    @Test
    public void returningUserWithCompletedOnboardingGoesHome() {
        when(verifyOtp.execute(CHALLENGE, "123456")).thenReturn(session(true));
        CodeViewModel viewModel = createViewModel();

        viewModel.onCodeChanged("123456");

        assertEquals(CodeDestination.HOME,
                viewModel.getNavigation().getValue().getContentIfNotHandled());
    }

    @Test
    public void showsProgressWhileVerifyingAndIgnoresEdits() {
        Queue<Runnable> pendingIo = new ArrayDeque<>();
        when(verifyOtp.execute(CHALLENGE, "123456")).thenReturn(session(false));
        CodeViewModel viewModel =
                createViewModel(new AppExecutors(pendingIo::add, Runnable::run));

        viewModel.onCodeChanged("123456");

        assertTrue(viewModel.getState().getValue().isVerifying());
        viewModel.onCodeChanged("123456");
        assertEquals(1, pendingIo.size());

        pendingIo.remove().run();

        assertFalse(viewModel.getState().getValue().isVerifying());
        verify(verifyOtp, times(1)).execute(CHALLENGE, "123456");
    }

    @Test
    public void otpInvalidClearsTheFieldAndShowsTheMessage() {
        when(verifyOtp.execute(CHALLENGE, "000000")).thenReturn(
                Result.failure(new AppError(AppError.CODE_OTP_INVALID, 422)));
        CodeViewModel viewModel = createViewModel();

        viewModel.onCodeChanged("000000");

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(Integer.valueOf(R.string.error_otp_invalid), state.getErrorMessage());
        assertFalse(state.isVerifying());
        assertNotNull(viewModel.getClearCode().getValue().getContentIfNotHandled());
        assertNull(viewModel.getNavigation().getValue());

        // The field being emptied must not hide the message...
        viewModel.onCodeChanged("");
        assertEquals(Integer.valueOf(R.string.error_otp_invalid),
                viewModel.getState().getValue().getErrorMessage());
        // ...but typing a new code does.
        viewModel.onCodeChanged("1");
        assertNull(viewModel.getState().getValue().getErrorMessage());
    }

    @Test
    public void networkErrorShowsConnectionMessageAndKeepsTheCode() {
        when(verifyOtp.execute(CHALLENGE, "123456")).thenReturn(
                Result.failure(AppError.network()));
        CodeViewModel viewModel = createViewModel();

        viewModel.onCodeChanged("123456");

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(Integer.valueOf(R.string.error_network), state.getErrorMessage());
        assertFalse(state.isVerifying());
        assertNull(viewModel.getClearCode().getValue());
        assertNull(viewModel.getNavigation().getValue());
    }

    @Test
    public void rateLimitedShowsMessageAndBlocksResendUntilCountdownExpires() {
        when(verifyOtp.execute(CHALLENGE, "111111")).thenReturn(
                Result.failure(new AppError(AppError.CODE_RATE_LIMITED, 429)));
        CodeViewModel viewModel = createViewModel();
        countdown.tick(0); // the first countdown ran out: resending would be allowed
        assertTrue(viewModel.getState().getValue().canResend());

        viewModel.onCodeChanged("111111");

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(Integer.valueOf(R.string.error_rate_limited), state.getErrorMessage());
        assertFalse(state.canResend());
        assertEquals(RETRY_AFTER, state.getSecondsUntilResend());
        assertEquals(2, countdown.starts);

        viewModel.onResendClicked();
        verify(requestOtp, never()).execute(anyString());

        countdown.tick(0);
        assertTrue(viewModel.getState().getValue().canResend());
    }

    @Test
    public void rateLimitedDuringRunningCountdownDoesNotRestartIt() {
        when(verifyOtp.execute(CHALLENGE, "111111")).thenReturn(
                Result.failure(new AppError(AppError.CODE_RATE_LIMITED, 429)));
        CodeViewModel viewModel = createViewModel();
        countdown.tick(12);

        viewModel.onCodeChanged("111111");

        assertEquals(12, viewModel.getState().getValue().getSecondsUntilResend());
        assertEquals(1, countdown.starts);
    }

    @Test
    public void resendIsBlockedWhileCountingDown() {
        CodeViewModel viewModel = createViewModel();
        countdown.tick(5);

        viewModel.onResendClicked();

        verify(requestOtp, never()).execute(anyString());
        assertEquals(5, viewModel.getState().getValue().getSecondsUntilResend());
    }

    @Test
    public void resendRequestsNewCodeRestartsCountdownAndUsesNewChallenge() {
        when(requestOtp.execute(PHONE)).thenReturn(Result.success(
                new OtpRequest(PHONE, new OtpChallenge("challenge-2", 45))));
        when(verifyOtp.execute("challenge-2", "123456")).thenReturn(session(false));
        CodeViewModel viewModel = createViewModel();
        countdown.tick(0);

        viewModel.onResendClicked();

        verify(requestOtp).execute(PHONE);
        CodeUiState state = viewModel.getState().getValue();
        assertFalse(state.isResending());
        assertEquals(45, state.getSecondsUntilResend());
        assertEquals(45, countdown.startedWith);

        viewModel.onCodeChanged("123456");
        verify(verifyOtp).execute("challenge-2", "123456");
    }

    @Test
    public void resendNetworkErrorShowsMessageAndAllowsAnotherTry() {
        when(requestOtp.execute(PHONE)).thenReturn(Result.failure(AppError.network()));
        CodeViewModel viewModel = createViewModel();
        countdown.tick(0);

        viewModel.onResendClicked();

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(Integer.valueOf(R.string.error_network), state.getErrorMessage());
        assertTrue(state.canResend());
    }

    @Test
    public void resendRateLimitedBlocksResendAgain() {
        when(requestOtp.execute(PHONE)).thenReturn(
                Result.failure(new AppError(AppError.CODE_RATE_LIMITED, 429)));
        CodeViewModel viewModel = createViewModel();
        countdown.tick(0);

        viewModel.onResendClicked();

        CodeUiState state = viewModel.getState().getValue();
        assertEquals(Integer.valueOf(R.string.error_rate_limited), state.getErrorMessage());
        assertFalse(state.canResend());
        assertEquals(RETRY_AFTER, state.getSecondsUntilResend());
    }

    @Test
    public void clearingTheViewModelCancelsTheCountdown() {
        CodeViewModel viewModel = createViewModel();

        viewModel.onCleared();

        assertTrue(countdown.cancelled);
    }
}
