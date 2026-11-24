package ro.profitnet.app.feature.onboarding.domain.model;

/** The screens of the onboarding flow, in order, plus the terminal state. */
public enum OnboardingStep {
    WELCOME,
    PHONE,
    CODE,
    CONSENTS,
    NAME,
    LOCATION,
    INTERESTS,
    COMPLETED;

    /** Lenient parsing for values read back from storage. */
    public static OnboardingStep fromName(String name) {
        if (name != null) {
            for (OnboardingStep step : values()) {
                if (step.name().equals(name)) {
                    return step;
                }
            }
        }
        return WELCOME;
    }
}
