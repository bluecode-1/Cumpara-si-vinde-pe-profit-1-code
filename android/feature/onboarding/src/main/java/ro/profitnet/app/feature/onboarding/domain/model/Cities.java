package ro.profitnet.app.feature.onboarding.domain.model;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import ro.profitnet.app.core.model.GeoPoint;

/**
 * The fixed list of cities for manual selection (spec section 3). The names are proper nouns
 * and part of the shared product data, identical on all three platforms, so they are not
 * string resources.
 */
public final class Cities {

    public static final List<City> ALL = Collections.unmodifiableList(Arrays.asList(
            new City("București", new GeoPoint(44.43, 26.10)),
            new City("Cluj-Napoca", new GeoPoint(46.77, 23.60)),
            new City("Timișoara", new GeoPoint(45.76, 21.23)),
            new City("Iași", new GeoPoint(47.16, 27.59)),
            new City("Constanța", new GeoPoint(44.18, 28.63)),
            new City("Brașov", new GeoPoint(45.65, 25.60)),
            new City("Craiova", new GeoPoint(44.32, 23.80)),
            new City("Galați", new GeoPoint(45.44, 28.05)),
            new City("Oradea", new GeoPoint(47.05, 21.93)),
            new City("Sibiu", new GeoPoint(45.80, 24.15))));

    private Cities() {
    }
}
