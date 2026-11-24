package ro.profitnet.app.feature.onboarding.ui.interests;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.fragment.NavHostFragment;

import com.google.android.material.chip.Chip;

import java.util.ArrayList;
import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.feature.onboarding.R;
import ro.profitnet.app.feature.onboarding.databinding.FragmentInterestsBinding;
import ro.profitnet.app.feature.onboarding.ui.OnboardingNavigation;

/** Step 7: optional interests (top-level categories, multi-select) with "Skip". */
@AndroidEntryPoint
public class InterestsFragment extends Fragment {

    private FragmentInterestsBinding binding;
    private InterestsViewModel viewModel;
    /** Ids of the categories currently shown as chips, in order. */
    private final List<String> shownCategoryIds = new ArrayList<>();

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        binding = FragmentInterestsBinding.inflate(inflater, container, false);
        shownCategoryIds.clear();
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        ViewCompat.setAccessibilityHeading(binding.title, true);
        viewModel = new ViewModelProvider(this).get(InterestsViewModel.class);

        binding.finishButton.setOnClickListener(v -> viewModel.onFinish());
        binding.skipButton.setOnClickListener(v -> viewModel.onSkip());
        binding.retryButton.setOnClickListener(v -> viewModel.onRetry());

        viewModel.getState().observe(getViewLifecycleOwner(), this::render);
        viewModel.getCompleted().observe(getViewLifecycleOwner(), event -> {
            if (event.getContentIfNotHandled() != null) {
                OnboardingNavigation.navigateToHome(NavHostFragment.findNavController(this));
            }
        });
    }

    private void render(InterestsUiState state) {
        renderChips(state);
        binding.progress.setVisibility(state.isBusy() ? View.VISIBLE : View.INVISIBLE);
        binding.finishButton.setEnabled(!state.isBusy() && !state.isCategoriesFailed());
        binding.skipButton.setEnabled(!state.isSaving());
        binding.retryButton.setVisibility(state.isCategoriesFailed() ? View.VISIBLE : View.GONE);
        binding.retryButton.setEnabled(!state.isBusy());
        if (state.getErrorMessage() == null) {
            binding.message.setVisibility(View.GONE);
        } else {
            binding.message.setText(state.getErrorMessage());
            binding.message.setVisibility(View.VISIBLE);
        }
    }

    private void renderChips(InterestsUiState state) {
        List<String> ids = new ArrayList<>();
        for (Category category : state.getCategories()) {
            ids.add(category.getId());
        }
        if (!ids.equals(shownCategoryIds)) {
            binding.categoryChips.removeAllViews();
            LayoutInflater inflater = getLayoutInflater();
            for (Category category : state.getCategories()) {
                Chip chip = (Chip) inflater.inflate(
                        R.layout.item_interest_chip, binding.categoryChips, false);
                chip.setId(View.generateViewId());
                chip.setText(category.getName());
                chip.setTag(category.getId());
                chip.setOnCheckedChangeListener((button, checked) ->
                        viewModel.onCategoryToggled(category.getId(), checked));
                binding.categoryChips.addView(chip);
            }
            shownCategoryIds.clear();
            shownCategoryIds.addAll(ids);
        }
        for (int i = 0; i < binding.categoryChips.getChildCount(); i++) {
            Chip chip = (Chip) binding.categoryChips.getChildAt(i);
            chip.setChecked(state.getSelectedIds().contains((String) chip.getTag()));
            chip.setEnabled(!state.isSaving());
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
