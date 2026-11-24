package ro.profitnet.app.feature.onboarding.ui.code;

/** Where to go after the code was verified. */
public enum CodeDestination {
    /** New or unfinished account: continue onboarding. */
    CONSENTS,
    /** Returning user who already completed onboarding. */
    HOME
}
