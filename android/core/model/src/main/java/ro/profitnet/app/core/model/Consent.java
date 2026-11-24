package ro.profitnet.app.core.model;

import java.util.Objects;

/**
 * A consent decision tied to a policy version. {@code updatedAt} is set by the server
 * (RFC 3339, UTC) and is {@code null} for a decision that has not been sent yet.
 */
public final class Consent {

    private final ConsentPurpose purpose;
    private final boolean granted;
    private final String policyVersion;
    private final String updatedAt;

    public Consent(ConsentPurpose purpose, boolean granted, String policyVersion, String updatedAt) {
        this.purpose = Objects.requireNonNull(purpose, "purpose");
        this.granted = granted;
        this.policyVersion = Objects.requireNonNull(policyVersion, "policyVersion");
        this.updatedAt = updatedAt;
    }

    /** A decision made on this device, not yet acknowledged by the server. */
    public static Consent decision(ConsentPurpose purpose, boolean granted, String policyVersion) {
        return new Consent(purpose, granted, policyVersion, null);
    }

    public ConsentPurpose getPurpose() {
        return purpose;
    }

    public boolean isGranted() {
        return granted;
    }

    public String getPolicyVersion() {
        return policyVersion;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Consent)) {
            return false;
        }
        Consent other = (Consent) o;
        return granted == other.granted
                && purpose == other.purpose
                && policyVersion.equals(other.policyVersion)
                && Objects.equals(updatedAt, other.updatedAt);
    }

    @Override
    public int hashCode() {
        return Objects.hash(purpose, granted, policyVersion, updatedAt);
    }

    @Override
    public String toString() {
        return "Consent{" + purpose + '=' + granted + ", policyVersion=" + policyVersion + '}';
    }
}
