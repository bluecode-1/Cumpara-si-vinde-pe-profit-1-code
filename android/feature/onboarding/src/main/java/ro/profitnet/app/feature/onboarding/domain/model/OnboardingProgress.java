package ro.profitnet.app.feature.onboarding.domain.model;

import java.util.Objects;

/** Locally persisted state of the flow. Immutable; use the {@code with...} methods to change. */
public final class OnboardingProgress {

    private final OnboardingStep step;
    private final String phone;
    private final String displayName;

    public OnboardingProgress(OnboardingStep step, String phone, String displayName) {
        this.step = Objects.requireNonNull(step, "step");
        this.phone = phone;
        this.displayName = displayName;
    }

    public static OnboardingProgress initial() {
        return new OnboardingProgress(OnboardingStep.WELCOME, null, null);
    }

    public OnboardingStep getStep() {
        return step;
    }

    /** E.164 phone number, or {@code null} if none was entered yet. */
    public String getPhone() {
        return phone;
    }

    /** May be {@code null}. */
    public String getDisplayName() {
        return displayName;
    }

    public OnboardingProgress withStep(OnboardingStep newStep) {
        return new OnboardingProgress(newStep, phone, displayName);
    }

    public OnboardingProgress withPhone(String newPhone) {
        return new OnboardingProgress(step, newPhone, displayName);
    }

    public OnboardingProgress withDisplayName(String newDisplayName) {
        return new OnboardingProgress(step, phone, newDisplayName);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof OnboardingProgress)) {
            return false;
        }
        OnboardingProgress other = (OnboardingProgress) o;
        return step == other.step
                && Objects.equals(phone, other.phone)
                && Objects.equals(displayName, other.displayName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(step, phone, displayName);
    }

    @Override
    public String toString() {
        return "OnboardingProgress{step=" + step + '}';
    }
}
