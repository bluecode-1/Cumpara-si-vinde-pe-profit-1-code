package ro.profitnet.app.feature.onboarding.ui.consents;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.feature.onboarding.databinding.FragmentConsentsBinding;
import ro.profitnet.app.feature.onboarding.domain.model.ConsentSelection;

/**
 * Step 4: Terms and Privacy (required) and three optional consents, all unticked by default.
 */
@AndroidEntryPoint
public class ConsentsFragment extends Fragment {

    private FragmentConsentsBinding binding;
    private ConsentsViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentConsentsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        viewModel = new ViewModelProvider(this).get(ConsentsViewModel.class);
        ViewCompat.setAccessibilityHeading(binding.optionalHeader, true);

        bind(binding.termsCheck, ConsentPurpose.TERMS);
        bind(binding.privacyCheck, ConsentPurpose.PRIVACY);
        bind(binding.marketingCheck, ConsentPurpose.MARKETING);
        bind(binding.analyticsCheck, ConsentPurpose.ANALYTICS);
        bind(binding.aiCheck, ConsentPurpose.AI_PHOTO_PROCESSING);
        binding.continueButton.setOnClickListener(v -> viewModel.onContinue());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getSaved().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                NavHostFragment.findNavController(this)
                        .navigate(ConsentsFragmentDirections.actionConsentsToName());
            }
        });
    }

    private void bind(CompoundButton checkBox, ConsentPurpose purpose) {
        checkBox.setOnCheckedChangeListener(
                (button, checked) -> viewModel.onConsentChanged(purpose, checked));
    }

    private void render(ConsentsUiState state) {
        ConsentSelection selection = state.getSelection();
        // The view model is the source of truth (it survives rotation).
        binding.termsCheck.setChecked(selection.isTerms());
        binding.privacyCheck.setChecked(selection.isPrivacy());
        binding.marketingCheck.setChecked(selection.isMarketing());
        binding.analyticsCheck.setChecked(selection.isAnalytics());
        binding.aiCheck.setChecked(selection.isAiPhotoProcessing());

        boolean editable = !state.isLoading();
        binding.termsCheck.setEnabled(editable);
        binding.privacyCheck.setEnabled(editable);
        binding.marketingCheck.setEnabled(editable);
        binding.analyticsCheck.setEnabled(editable);
        binding.aiCheck.setEnabled(editable);

        binding.progress.setVisibility(state.isLoading() ? View.VISIBLE : View.INVISIBLE);
        binding.continueButton.setEnabled(state.canContinue());
        if (state.getErrorMessage() == null) {
            binding.message.setVisibility(View.GONE);
        } else {
            binding.message.setText(state.getErrorMessage());
            binding.message.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
