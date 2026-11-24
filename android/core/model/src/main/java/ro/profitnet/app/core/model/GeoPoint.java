package ro.profitnet.app.core.model;

/** A WGS84 coordinate pair. */
public final class GeoPoint {

    private final double lat;
    private final double lng;

    public GeoPoint(double lat, double lng) {
        if (!(lat >= -90 && lat <= 90)) {
            throw new IllegalArgumentException("lat out of range: " + lat);
        }
        if (!(lng >= -180 && lng <= 180)) {
            throw new IllegalArgumentException("lng out of range: " + lng);
        }
        this.lat = lat;
        this.lng = lng;
    }

    public double getLat() {
        return lat;
    }

    public double getLng() {
        return lng;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof GeoPoint)) {
            return false;
        }
        GeoPoint other = (GeoPoint) o;
        return Double.compare(lat, other.lat) == 0 && Double.compare(lng, other.lng) == 0;
    }

    @Override
    public int hashCode() {
        return 31 * Double.hashCode(lat) + Double.hashCode(lng);
    }

    @Override
    public String toString() {
        return "GeoPoint{" + lat + ", " + lng + '}';
    }
}
