package ro.profitnet.app.feature.onboarding.domain;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.GeoPoint;

/** Reads the device's approximate location. The location permission must already be granted. */
public interface DeviceLocationProvider {

    /**
     * Blocks until a location is available or a timeout expires.
     *
     * @return the location, or a failure with {@link OnboardingErrors#LOCATION_UNAVAILABLE}.
     */
    Result<GeoPoint> getCurrentLocation();
}
