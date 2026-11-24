package ro.profitnet.app.feature.onboarding.domain.model;

import java.util.Objects;

import ro.profitnet.app.core.model.GeoPoint;

/** A city offered when the user prefers to pick the home area manually. */
public final class City {

    private final String name;
    private final GeoPoint location;

    public City(String name, GeoPoint location) {
        this.name = Objects.requireNonNull(name, "name");
        this.location = Objects.requireNonNull(location, "location");
    }

    public String getName() {
        return name;
    }

    public GeoPoint getLocation() {
        return location;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof City)) {
            return false;
        }
        City other = (City) o;
        return name.equals(other.name) && location.equals(other.location);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, location);
    }
}
