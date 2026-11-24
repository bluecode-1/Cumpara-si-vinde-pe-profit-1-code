package ro.profitnet.app.feature.onboarding.ui.phone;

import android.os.Bundle;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.feature.onboarding.databinding.FragmentPhoneBinding;
import ro.profitnet.app.feature.onboarding.ui.SimpleTextWatcher;

/** Step 2: phone number with the fixed +40 prefix; requests the SMS code. */
@AndroidEntryPoint
public class PhoneFragment extends Fragment {

    private FragmentPhoneBinding binding;
    private PhoneViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentPhoneBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        viewModel = new ViewModelProvider(this).get(PhoneViewModel.class);

        binding.phoneInput.addTextChangedListener(
                new SimpleTextWatcher(text -> viewModel.onPhoneEdited()));
        binding.phoneInput.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                submit();
                return true;
            }
            return false;
        });
        binding.submitButton.setOnClickListener(v -> submit());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getPrefill().observe(getViewLifecycleOwner(), event -> {
            String national = event.getContentIfNotHandled();
            Editable current = binding.phoneInput.getText();
            if (national != null && (current == null || current.length() == 0)) {
                binding.phoneInput.setText(national);
                binding.phoneInput.setSelection(national.length());
            }
        });
        viewModel.getCodeSent().observe(getViewLifecycleOwner(), event -> {
            CodeSent codeSent = event.getContentIfNotHandled();
            if (codeSent != null) {
                NavHostFragment.findNavController(this).navigate(
                        PhoneFragmentDirections.actionPhoneToCode(codeSent.getPhone(),
                                codeSent.getChallengeId(), codeSent.getRetryAfterSeconds()));
            }
        });
    }

    private void submit() {
        Editable text = binding.phoneInput.getText();
        viewModel.onSubmit(text == null ? "" : text.toString());
    }

    private void render(PhoneUiState state) {
        binding.progress.setVisibility(state.isLoading() ? View.VISIBLE : View.INVISIBLE);
        binding.submitButton.setEnabled(!state.isLoading());
        binding.phoneInput.setEnabled(!state.isLoading());
        // TextInputLayout announces its error to accessibility services.
        binding.phoneLayout.setError(
                state.getErrorMessage() == null ? null : getString(state.getErrorMessage()));
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
