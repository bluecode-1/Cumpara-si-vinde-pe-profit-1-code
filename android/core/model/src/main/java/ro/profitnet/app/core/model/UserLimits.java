package ro.profitnet.app.core.model;

import java.util.Objects;

/** Transaction limits of the signed-in user for the current verification tier. */
public final class UserLimits {

    private final Money maxTransaction;
    private final Money monthlyVolume;

    public UserLimits(Money maxTransaction, Money monthlyVolume) {
        this.maxTransaction = Objects.requireNonNull(maxTransaction, "maxTransaction");
        this.monthlyVolume = Objects.requireNonNull(monthlyVolume, "monthlyVolume");
    }

    public Money getMaxTransaction() {
        return maxTransaction;
    }

    public Money getMonthlyVolume() {
        return monthlyVolume;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof UserLimits)) {
            return false;
        }
        UserLimits other = (UserLimits) o;
        return maxTransaction.equals(other.maxTransaction)
                && monthlyVolume.equals(other.monthlyVolume);
    }

    @Override
    public int hashCode() {
        return Objects.hash(maxTransaction, monthlyVolume);
    }
}
