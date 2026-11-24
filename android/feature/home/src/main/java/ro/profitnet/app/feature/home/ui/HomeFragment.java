package ro.profitnet.app.feature.home.ui;

import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.NavDeepLinkRequest;
import androidx.navigation.NavOptions;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.core.common.navigation.DeepLinks;
import ro.profitnet.app.feature.home.R;
import ro.profitnet.app.feature.home.databinding.FragmentHomeBinding;

/**
 * Provisional Home: a greeting and "Sign out". The real content ("Near you today") comes in a
 * later step.
 */
@AndroidEntryPoint
public class HomeFragment extends Fragment {

    private FragmentHomeBinding binding;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentHomeBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        HomeViewModel viewModel = new ViewModelProvider(this).get(HomeViewModel.class);

        binding.logoutButton.setOnClickListener(v -> viewModel.onLogoutClicked());

        viewModel.getState().observe(getViewLifecycleOwner(), state -> {
            binding.greeting.setText(getString(R.string.home_greeting, state.getDisplayName()));
            binding.logoutButton.setEnabled(!state.isLoggingOut());
            binding.progress.setVisibility(state.isLoggingOut() ? View.VISIBLE : View.INVISIBLE);
        });
        viewModel.getLoggedOut().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                navigateToOnboarding();
            }
        });
    }

    /** Back to the welcome screen, with nothing left on the back stack. */
    private void navigateToOnboarding() {
        NavController navController = NavHostFragment.findNavController(this);
        NavOptions options = new NavOptions.Builder()
                .setPopUpTo(navController.getGraph().getId(), true)
                .build();
        navController.navigate(
                NavDeepLinkRequest.Builder.fromUri(Uri.parse(DeepLinks.ONBOARDING)).build(),
                options);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
