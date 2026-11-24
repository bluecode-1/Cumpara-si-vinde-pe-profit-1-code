package ro.profitnet.app.feature.home.ui;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import androidx.arch.core.executor.testing.InstantTaskExecutorRule;

import org.junit.Rule;
import org.junit.Test;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.home.domain.GetDisplayNameUseCase;
import ro.profitnet.app.feature.home.domain.HomeRepository;
import ro.profitnet.app.feature.home.domain.LogoutUseCase;

public class HomeViewModelTest {

    @Rule
    public InstantTaskExecutorRule instantTaskExecutorRule = new InstantTaskExecutorRule();

    private final HomeRepository repository = mock(HomeRepository.class);
    private final AppExecutors executors = new AppExecutors(Runnable::run, Runnable::run);

    private HomeViewModel createViewModel() {
        return new HomeViewModel(new GetDisplayNameUseCase(repository),
                new LogoutUseCase(repository), executors);
    }

    @Test
    public void greetsWithTheLocallySavedNameWithoutCallingTheServer() {
        when(repository.getCachedDisplayName()).thenReturn("Ioana");

        HomeViewModel viewModel = createViewModel();

        assertEquals("Ioana", viewModel.getState().getValue().getDisplayName());
        verify(repository, never()).getMe();
    }

    @Test
    public void fallsBackToTheServerName() {
        when(repository.getCachedDisplayName()).thenReturn(null);
        when(repository.getMe()).thenReturn(
                Result.success(User.builder("id").displayName("Andrei").build()));

        assertEquals("Andrei", createViewModel().getState().getValue().getDisplayName());
    }

    @Test
    public void nameIsEmptyWhenNothingIsAvailable() {
        when(repository.getCachedDisplayName()).thenReturn("  ");
        when(repository.getMe()).thenReturn(Result.failure(AppError.network()));

        assertEquals("", createViewModel().getState().getValue().getDisplayName());
    }

    @Test
    public void logoutClearsSessionAndFiresEventOnce() {
        when(repository.getCachedDisplayName()).thenReturn("Ioana");
        HomeViewModel viewModel = createViewModel();
        assertNull(viewModel.getLoggedOut().getValue());

        viewModel.onLogoutClicked();

        verify(repository).logout();
        assertFalse(viewModel.getState().getValue().isLoggingOut());
        assertNotNull(viewModel.getLoggedOut().getValue().getContentIfNotHandled());
        assertNull(viewModel.getLoggedOut().getValue().getContentIfNotHandled());
    }
}
