package ro.profitnet.app.feature.onboarding.ui.phone;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import androidx.arch.core.executor.testing.InstantTaskExecutorRule;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.domain.GetOnboardingProgressUseCase;
import ro.profitnet.app.feature.onboarding.domain.OnboardingErrors;
import ro.profitnet.app.feature.onboarding.domain.RequestOtpUseCase;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingProgress;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;

public class PhoneViewModelTest {

    private static final String PHONE = "+40712345678";

    @Rule
    public InstantTaskExecutorRule instantTaskExecutorRule = new InstantTaskExecutorRule();

    private final RequestOtpUseCase requestOtp = mock(RequestOtpUseCase.class);
    private final GetOnboardingProgressUseCase getProgress =
            mock(GetOnboardingProgressUseCase.class);
    private final AppExecutors direct = new AppExecutors(Runnable::run, Runnable::run);

    @Before
    public void setUp() {
        when(getProgress.execute()).thenReturn(OnboardingProgress.initial());
    }

    private PhoneViewModel createViewModel() {
        return new PhoneViewModel(requestOtp, getProgress, direct);
    }

    @Test
    public void startsIdleWithoutError() {
        PhoneViewModel viewModel = createViewModel();

        assertEquals(PhoneUiState.initial(), viewModel.getState().getValue());
        assertNull(viewModel.getCodeSent().getValue());
        assertNull(viewModel.getPrefill().getValue());
    }

    @Test
    public void successEmitsNavigationWithNormalizedPhoneAndChallenge() {
        when(requestOtp.execute("0712 345 678")).thenReturn(Result.success(
                new OtpRequest(PHONE, new OtpChallenge("challenge-1", 30))));
        PhoneViewModel viewModel = createViewModel();

        viewModel.onSubmit("0712 345 678");

        assertEquals(new PhoneUiState(false, null), viewModel.getState().getValue());
        CodeSent event = viewModel.getCodeSent().getValue().getContentIfNotHandled();
        assertEquals(PHONE, event.getPhone());
        assertEquals("challenge-1", event.getChallengeId());
        assertEquals(30, event.getRetryAfterSeconds());
        // One-shot: not delivered again after e.g. a rotation.
        assertNull(viewModel.getCodeSent().getValue().getContentIfNotHandled());
    }

    @Test
    public void showsLoadingWhileTheRequestIsRunning() {
        Queue<Runnable> pendingIo = new ArrayDeque<>();
        when(requestOtp.execute(anyString())).thenReturn(Result.success(
                new OtpRequest(PHONE, new OtpChallenge("challenge-1", 30))));
        PhoneViewModel viewModel =
                new PhoneViewModel(requestOtp, getProgress, new AppExecutors(pendingIo::add,
                        Runnable::run));
        pendingIo.remove().run(); // progress lookup from the constructor

        List<PhoneUiState> states = new ArrayList<>();
        viewModel.getState().observeForever(states::add);
        viewModel.onSubmit("0712345678");

        assertTrue(viewModel.getState().getValue().isLoading());
        // A second tap while loading is ignored.
        viewModel.onSubmit("0712345678");
        assertEquals(1, pendingIo.size());

        pendingIo.remove().run();

        assertFalse(viewModel.getState().getValue().isLoading());
        verify(requestOtp, times(1)).execute("0712345678");
        assertEquals(3, states.size()); // initial, loading, done
    }

    @Test
    public void invalidPhoneShowsValidationError() {
        when(requestOtp.execute("12345")).thenReturn(
                Result.failure(AppError.local(OnboardingErrors.PHONE_INVALID)));
        PhoneViewModel viewModel = createViewModel();

        viewModel.onSubmit("12345");

        assertEquals(new PhoneUiState(false, R.string.phone_error_invalid),
                viewModel.getState().getValue());
        assertNull(viewModel.getCodeSent().getValue());
    }

    @Test
    public void networkErrorShowsConnectionMessage() {
        when(requestOtp.execute(anyString())).thenReturn(Result.failure(AppError.network()));
        PhoneViewModel viewModel = createViewModel();

        viewModel.onSubmit("0712345678");

        assertEquals(Integer.valueOf(ro.profitnet.app.core.designsystem.R.string.error_network),
                viewModel.getState().getValue().getErrorMessage());
        assertFalse(viewModel.getState().getValue().isLoading());
        assertNull(viewModel.getCodeSent().getValue());
    }

    @Test
    public void rateLimitShowsRateLimitMessage() {
        when(requestOtp.execute(anyString())).thenReturn(
                Result.failure(new AppError(AppError.CODE_RATE_LIMITED, 429)));
        PhoneViewModel viewModel = createViewModel();

        viewModel.onSubmit("0712345678");

        assertEquals(
                Integer.valueOf(ro.profitnet.app.core.designsystem.R.string.error_rate_limited),
                viewModel.getState().getValue().getErrorMessage());
    }

    @Test
    public void unknownServerErrorShowsGenericMessage() {
        when(requestOtp.execute(anyString())).thenReturn(Result.failure(AppError.unknown(500)));
        PhoneViewModel viewModel = createViewModel();

        viewModel.onSubmit("0712345678");

        assertEquals(Integer.valueOf(ro.profitnet.app.core.designsystem.R.string.error_generic),
                viewModel.getState().getValue().getErrorMessage());
    }

    @Test
    public void editingClearsTheError() {
        when(requestOtp.execute(anyString())).thenReturn(
                Result.failure(AppError.local(OnboardingErrors.PHONE_INVALID)));
        PhoneViewModel viewModel = createViewModel();
        viewModel.onSubmit("1");

        viewModel.onPhoneEdited();

        assertEquals(PhoneUiState.initial(), viewModel.getState().getValue());
    }

    @Test
    public void prefillsNationalPartOfPreviouslyEnteredNumber() {
        when(getProgress.execute()).thenReturn(
                new OnboardingProgress(OnboardingStep.CODE, PHONE, null));

        PhoneViewModel viewModel = createViewModel();

        assertEquals("712345678", viewModel.getPrefill().getValue().getContentIfNotHandled());
    }
}
