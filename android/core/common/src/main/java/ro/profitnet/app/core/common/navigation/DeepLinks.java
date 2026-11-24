package ro.profitnet.app.core.common.navigation;

/**
 * In-app deep links used to navigate between features. Features never depend on each other;
 * the destinations are declared in the nav graphs and wired together by the app module.
 * These links are internal only (not exported through the manifest).
 */
public final class DeepLinks {

    public static final String HOME = "profitnet://home";
    public static final String ONBOARDING = "profitnet://onboarding";

    private static final String ONBOARDING_STEP_PREFIX = "profitnet://onboarding/";

    private DeepLinks() {
    }

    /** Link to a resumable onboarding step: consents, name, location or interests. */
    public static String onboardingStep(String stepPath) {
        return ONBOARDING_STEP_PREFIX + stepPath;
    }
}
