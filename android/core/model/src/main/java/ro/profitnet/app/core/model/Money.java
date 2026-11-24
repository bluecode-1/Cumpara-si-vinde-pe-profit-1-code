package ro.profitnet.app.core.model;

import java.util.Objects;

/** An amount in minor units (bani / euro cents) plus its ISO 4217 currency. */
public final class Money {

    private final long amountMinor;
    private final String currency;

    public Money(long amountMinor, String currency) {
        if (amountMinor < 0) {
            throw new IllegalArgumentException("amountMinor must not be negative");
        }
        this.amountMinor = amountMinor;
        this.currency = Objects.requireNonNull(currency, "currency");
    }

    public long getAmountMinor() {
        return amountMinor;
    }

    public String getCurrency() {
        return currency;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Money)) {
            return false;
        }
        Money other = (Money) o;
        return amountMinor == other.amountMinor && currency.equals(other.currency);
    }

    @Override
    public int hashCode() {
        return Objects.hash(amountMinor, currency);
    }

    @Override
    public String toString() {
        return amountMinor + " " + currency + " (minor)";
    }
}
