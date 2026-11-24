package ro.profitnet.app.feature.onboarding.domain;

import java.util.Collections;

import javax.inject.Inject;

import ro.profitnet.app.core.common.CoordinateRounder;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.model.City;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/**
 * Sets the user's home area, either from the device location (permission already granted) or
 * from a manually picked city. Coordinates are rounded to 2 decimals (~1 km) before they are
 * sent. Using the device location also records the LOCATION consent.
 */
public class SaveHomeLocationUseCase {

    private final ProfileRepository profileRepository;
    private final DeviceLocationProvider locationProvider;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public SaveHomeLocationUseCase(ProfileRepository profileRepository,
            DeviceLocationProvider locationProvider,
            OnboardingProgressRepository progressRepository) {
        this.profileRepository = profileRepository;
        this.locationProvider = locationProvider;
        this.progressRepository = progressRepository;
    }

    /** Call only after the location permission was granted. */
    public Result<Void> fromDeviceLocation() {
        Result<GeoPoint> location = locationProvider.getCurrentLocation();
        if (location.isFailure()) {
            return Result.failure(location.getError());
        }
        // Record the consent before any location-derived data is sent.
        Result<Void> consent = profileRepository.saveConsents(Collections.singletonList(
                Consent.decision(ConsentPurpose.LOCATION, true,
                        SaveConsentsUseCase.POLICY_VERSION)));
        if (consent.isFailure()) {
            return consent;
        }
        return save(location.getValue());
    }

    public Result<Void> fromCity(City city) {
        return save(city.getLocation());
    }

    private Result<Void> save(GeoPoint exact) {
        GeoPoint rounded = new GeoPoint(
                CoordinateRounder.round(exact.getLat()),
                CoordinateRounder.round(exact.getLng()));
        Result<User> result = profileRepository.updateHomeLocation(rounded);
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        progressRepository.save(progressRepository.load().withStep(OnboardingStep.INTERESTS));
        return Result.success(null);
    }
}
