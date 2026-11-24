package ro.profitnet.app.feature.onboarding.domain;

/** Client-side error codes raised by the onboarding use cases (no server call involved). */
public final class OnboardingErrors {

    public static final String PHONE_INVALID = "LOCAL_PHONE_INVALID";
    public static final String NAME_INVALID = "LOCAL_NAME_INVALID";
    public static final String CONSENTS_REQUIRED = "LOCAL_CONSENTS_REQUIRED";
    public static final String LOCATION_UNAVAILABLE = "LOCAL_LOCATION_UNAVAILABLE";

    private OnboardingErrors() {
    }
}
