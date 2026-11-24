package ro.profitnet.app.feature.onboarding.ui;

import android.net.Uri;

import androidx.navigation.NavController;
import androidx.navigation.NavDeepLinkRequest;
import androidx.navigation.NavOptions;

import ro.profitnet.app.core.common.navigation.DeepLinks;

/** Navigation out of the onboarding feature (other features are reached by deep link). */
public final class OnboardingNavigation {

    private OnboardingNavigation() {
    }

    /** Opens Home and removes the whole onboarding flow from the back stack. */
    public static void navigateToHome(NavController navController) {
        NavOptions options = new NavOptions.Builder()
                .setPopUpTo(navController.getGraph().getId(), true)
                .build();
        navController.navigate(
                NavDeepLinkRequest.Builder.fromUri(Uri.parse(DeepLinks.HOME)).build(), options);
    }
}
