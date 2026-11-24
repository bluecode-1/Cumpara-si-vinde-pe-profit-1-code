package ro.profitnet.app.feature.onboarding.ui.location;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import com.google.android.material.dialog.MaterialAlertDialogBuilder;

import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.databinding.FragmentLocationBinding;
import ro.profitnet.app.feature.onboarding.domain.model.City;

/**
 * Step 6: the home area, from the device location (approximate permission, asked with the
 * explanation on screen) or from a manually picked city. Refusing the permission is not a dead
 * end: a notice points to the city list.
 */
@AndroidEntryPoint
public class LocationFragment extends Fragment {

    private FragmentLocationBinding binding;
    private LocationViewModel viewModel;

    private final ActivityResultLauncher<String> permissionLauncher = registerForActivityResult(
            new ActivityResultContracts.RequestPermission(),
            granted -> viewModel.onPermissionResult(Boolean.TRUE.equals(granted)));

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentLocationBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        viewModel = new ViewModelProvider(this).get(LocationViewModel.class);

        binding.useMyLocationButton.setOnClickListener(v -> useMyLocation());
        binding.pickCityButton.setOnClickListener(v -> showCityPicker());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getSaved().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                NavHostFragment.findNavController(this)
                        .navigate(LocationFragmentDirections.actionLocationToInterests());
            }
        });
    }

    private void useMyLocation() {
        if (ContextCompat.checkSelfPermission(requireContext(),
                Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            viewModel.onPermissionResult(true);
        } else {
            permissionLauncher.launch(Manifest.permission.ACCESS_COARSE_LOCATION);
        }
    }

    private void showCityPicker() {
        List<City> cities = viewModel.getCities();
        CharSequence[] names = new CharSequence[cities.size()];
        for (int i = 0; i < names.length; i++) {
            names[i] = cities.get(i).getName();
        }
        new MaterialAlertDialogBuilder(requireContext())
                .setTitle(R.string.location_pick_city)
                .setItems(names, (dialog, which) -> viewModel.onCitySelected(cities.get(which)))
                .show();
    }

    private void render(LocationUiState state) {
        binding.progress.setVisibility(state.isLoading() ? View.VISIBLE : View.INVISIBLE);
        binding.useMyLocationButton.setEnabled(!state.isLoading());
        binding.pickCityButton.setEnabled(!state.isLoading());
        if (state.getMessage() == null) {
            binding.message.setVisibility(View.GONE);
        } else {
            // A live region: the notice is announced by screen readers when it appears.
            binding.message.setText(state.getMessage());
            binding.message.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
