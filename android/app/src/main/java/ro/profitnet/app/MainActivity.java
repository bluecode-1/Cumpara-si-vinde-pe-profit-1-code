package ro.profitnet.app;

import android.net.Uri;
import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.NavDeepLinkRequest;
import androidx.navigation.NavGraph;
import androidx.navigation.NavOptions;
import androidx.navigation.fragment.NavHostFragment;

import dagger.hilt.android.AndroidEntryPoint;
import ro.profitnet.app.core.common.navigation.DeepLinks;
import ro.profitnet.app.databinding.ActivityMainBinding;

/** The single activity: hosts the navigation graph and decides where the app opens. */
@AndroidEntryPoint
public class MainActivity extends AppCompatActivity {

    private NavController navController;
    private boolean graphSet;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        EdgeToEdge.enable(this);
        super.onCreate(savedInstanceState);
        ActivityMainBinding binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        applyWindowInsets(binding);

        NavHostFragment navHost = (NavHostFragment) getSupportFragmentManager()
                .findFragmentById(R.id.nav_host);
        if (navHost == null) {
            throw new IllegalStateException("NavHostFragment is missing from activity_main");
        }
        navController = navHost.getNavController();

        // After a configuration change or process death the back stack is restored by the
        // NavController, so the saved onboarding step must not be opened a second time.
        final boolean freshLaunch = savedInstanceState == null;

        MainViewModel viewModel = new ViewModelProvider(this).get(MainViewModel.class);
        viewModel.getStartDestination().observe(this, start -> {
            if (graphSet) {
                return;
            }
            showGraph(start, freshLaunch);
            graphSet = true;
        });
        viewModel.getSessionExpired().observe(this, event -> {
            if (event.getContentIfNotHandled() != null && graphSet) {
                navigateClearingBackStack(DeepLinks.ONBOARDING);
            }
        });
    }

    private void showGraph(StartDestination start, boolean freshLaunch) {
        NavGraph graph = navController.getNavInflater().inflate(R.navigation.root_graph);
        graph.setStartDestination(start.getGraph() == StartDestination.Graph.HOME
                ? ro.profitnet.app.feature.home.R.id.home_graph
                : ro.profitnet.app.feature.onboarding.R.id.onboarding_graph);
        navController.setGraph(graph);
        if (freshLaunch && start.getResumeDeepLink() != null) {
            navigateClearingBackStack(start.getResumeDeepLink());
        }
    }

    private void navigateClearingBackStack(String deepLink) {
        NavOptions options = new NavOptions.Builder()
                .setPopUpTo(navController.getGraph().getId(), true)
                .build();
        navController.navigate(
                NavDeepLinkRequest.Builder.fromUri(Uri.parse(deepLink)).build(), options);
    }

    /** Edge-to-edge: keep content clear of the system bars, display cutout and keyboard. */
    private static void applyWindowInsets(ActivityMainBinding binding) {
        ViewCompat.setOnApplyWindowInsetsListener(binding.getRoot(), (view, windowInsets) -> {
            Insets insets = windowInsets.getInsets(WindowInsetsCompat.Type.systemBars()
                    | WindowInsetsCompat.Type.displayCutout()
                    | WindowInsetsCompat.Type.ime());
            view.setPadding(insets.left, insets.top, insets.right, insets.bottom);
            return WindowInsetsCompat.CONSUMED;
        });
    }
}
