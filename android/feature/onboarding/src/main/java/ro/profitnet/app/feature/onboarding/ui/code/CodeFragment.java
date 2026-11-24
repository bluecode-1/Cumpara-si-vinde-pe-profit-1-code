package ro.profitnet.app.feature.onboarding.ui.code;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.databinding.FragmentCodeBinding;
import ro.profitnet.app.feature.onboarding.ui.OnboardingNavigation;
import ro.profitnet.app.feature.onboarding.ui.PhoneFormatter;
import ro.profitnet.app.feature.onboarding.ui.SimpleTextWatcher;

/**
 * Step 3: the 6-digit code. It is submitted automatically at the sixth digit; a new code can be
 * requested once the countdown has run out.
 */
@AndroidEntryPoint
public class CodeFragment extends Fragment {

    private FragmentCodeBinding binding;
    private CodeViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentCodeBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        ViewCompat.setAccessibilityHeading(binding.title, true);
        viewModel = new ViewModelProvider(this).get(CodeViewModel.class);

        binding.codeInput.addTextChangedListener(new SimpleTextWatcher(viewModel::onCodeChanged));
        binding.resendButton.setOnClickListener(v -> viewModel.onResendClicked());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getClearCode().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                binding.codeInput.setText("");
            }
        });
        viewModel.getNavigation().observe(getViewLifecycleOwner(), event -> {
            CodeDestination destination = event.getContentIfNotHandled();
            if (destination == null) {
                return;
            }
            NavController navController = NavHostFragment.findNavController(this);
            if (destination == CodeDestination.HOME) {
                OnboardingNavigation.navigateToHome(navController);
            } else {
                navController.navigate(CodeFragmentDirections.actionCodeToConsents());
            }
        });
    }

    private void render(CodeUiState state) {
        binding.subtitle.setText(
                getString(R.string.code_subtitle, PhoneFormatter.forDisplay(state.getPhone())));
        binding.progress.setVisibility(state.isBusy() ? View.VISIBLE : View.INVISIBLE);
        binding.codeInput.setEnabled(!state.isVerifying());
        binding.codeLayout.setError(
                state.getErrorMessage() == null ? null : getString(state.getErrorMessage()));

        int seconds = state.getSecondsUntilResend();
        binding.resendCountdown.setVisibility(seconds > 0 ? View.VISIBLE : View.INVISIBLE);
        if (seconds > 0) {
            binding.resendCountdown.setText(getString(R.string.code_resend_in, seconds));
        }
        binding.resendButton.setEnabled(state.canResend());
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
