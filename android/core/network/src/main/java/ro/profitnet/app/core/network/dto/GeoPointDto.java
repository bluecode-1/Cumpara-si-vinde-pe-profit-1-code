package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code GeoPoint} schema. */
public final class GeoPointDto {

    @SerializedName("lat")
    public Double lat;

    @SerializedName("lng")
    public Double lng;

    public GeoPointDto() {
    }

    public GeoPointDto(double lat, double lng) {
        this.lat = lat;
        this.lng = lng;
    }
}
