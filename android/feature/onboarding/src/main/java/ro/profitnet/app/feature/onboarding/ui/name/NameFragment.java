package ro.profitnet.app.feature.onboarding.ui.name;

import android.os.Bundle;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.feature.onboarding.databinding.FragmentNameBinding;
import ro.profitnet.app.feature.onboarding.ui.SimpleTextWatcher;

/** Step 5: the display name (2–40 characters). */
@AndroidEntryPoint
public class NameFragment extends Fragment {

    private FragmentNameBinding binding;
    private NameViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentNameBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        ViewCompat.setAccessibilityHeading(binding.title, true);
        viewModel = new ViewModelProvider(this).get(NameViewModel.class);

        binding.nameInput.addTextChangedListener(
                new SimpleTextWatcher(text -> viewModel.onNameEdited()));
        binding.nameInput.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                submit();
                return true;
            }
            return false;
        });
        binding.continueButton.setOnClickListener(v -> submit());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getSaved().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                NavHostFragment.findNavController(this)
                        .navigate(NameFragmentDirections.actionNameToLocation());
            }
        });
    }

    private void submit() {
        Editable text = binding.nameInput.getText();
        viewModel.onSubmit(text == null ? "" : text.toString());
    }

    private void render(NameUiState state) {
        binding.progress.setVisibility(state.isLoading() ? View.VISIBLE : View.INVISIBLE);
        binding.continueButton.setEnabled(!state.isLoading());
        binding.nameInput.setEnabled(!state.isLoading());
        binding.nameLayout.setError(
                state.getErrorMessage() == null ? null : getString(state.getErrorMessage()));
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
