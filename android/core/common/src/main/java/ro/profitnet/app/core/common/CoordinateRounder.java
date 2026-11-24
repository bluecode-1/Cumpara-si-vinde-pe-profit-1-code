package ro.profitnet.app.core.common;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Rounds coordinates to 2 decimals (about 1 km) before they leave the device: the home area
 * does not need the exact address.
 */
public final class CoordinateRounder {

    public static final int DECIMALS = 2;

    private CoordinateRounder() {
    }

    public static double round(double coordinate) {
        if (Double.isNaN(coordinate) || Double.isInfinite(coordinate)) {
            throw new IllegalArgumentException("Coordinate must be a finite number");
        }
        return BigDecimal.valueOf(coordinate).setScale(DECIMALS, RoundingMode.HALF_UP).doubleValue();
    }
}
