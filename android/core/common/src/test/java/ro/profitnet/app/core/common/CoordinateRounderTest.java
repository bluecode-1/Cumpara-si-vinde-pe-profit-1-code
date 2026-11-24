package ro.profitnet.app.core.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;

import org.junit.Test;

public class CoordinateRounderTest {

    private static final double EXACT = 0.0;

    @Test
    public void roundsToTwoDecimals() {
        assertEquals(44.43, CoordinateRounder.round(44.4267674), EXACT);
        assertEquals(26.10, CoordinateRounder.round(26.1025384), EXACT);
        assertEquals(46.77, CoordinateRounder.round(46.7712101), EXACT);
    }

    @Test
    public void roundsHalfUp() {
        assertEquals(23.6, CoordinateRounder.round(23.595), EXACT);
        assertEquals(23.59, CoordinateRounder.round(23.5949), EXACT);
    }

    @Test
    public void keepsAlreadyRoundedValues() {
        assertEquals(45.76, CoordinateRounder.round(45.76), EXACT);
        assertEquals(0.0, CoordinateRounder.round(0.0), EXACT);
    }

    @Test
    public void handlesNegativeCoordinates() {
        assertEquals(-33.87, CoordinateRounder.round(-33.8688), EXACT);
        assertEquals(-0.13, CoordinateRounder.round(-0.1278), EXACT);
    }

    @Test
    public void rejectsNonFiniteValues() {
        assertThrows(IllegalArgumentException.class, () -> CoordinateRounder.round(Double.NaN));
        assertThrows(IllegalArgumentException.class,
                () -> CoordinateRounder.round(Double.POSITIVE_INFINITY));
    }
}
