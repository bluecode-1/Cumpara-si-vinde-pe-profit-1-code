import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/city.dart';
import 'package:profitnet/features/onboarding/domain/coordinate_rounding.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_controller.freezed.dart';
part 'location_controller.g.dart';

@freezed
abstract class LocationState with _$LocationState {
  const factory LocationState({
    @Default(false) bool isBusy,

    /// The device location could not be used (permission denied or no fix):
    /// the screen points the user to the city list.
    @Default(false) bool isLocationDenied,
    AppError? error,
  }) = _LocationState;
}

/// Step 6: sets the approximate home area, from the device location or
/// from a manually chosen city.
@riverpod
class LocationController extends _$LocationController {
  @override
  LocationState build() => const LocationState();

  /// Asks for the device location. With the permission granted, the
  /// `LOCATION` consent is recorded and the rounded position is saved.
  Future<void> useMyLocation() async {
    if (state.isBusy) {
      return;
    }
    final LocationService locationService = ref.read(locationServiceProvider);
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    state = const LocationState(isBusy: true);
    final LocationResult result = await locationService.currentLocation();
    if (result is! LocationFound) {
      if (ref.mounted) {
        state = const LocationState(isLocationDenied: true);
      }
      return;
    }
    await _save(
      repository,
      session,
      result.point,
      recordLocationConsent: true,
      keepDeniedHint: false,
    );
  }

  /// Uses the coordinates of [city]; no location permission is involved.
  Future<void> pickCity(City city) async {
    if (state.isBusy) {
      return;
    }
    final bool keepDeniedHint = state.isLocationDenied;
    state = state.copyWith(isBusy: true, error: null);
    await _save(
      ref.read(onboardingRepositoryProvider),
      ref.read(sessionControllerProvider.notifier),
      city.location,
      recordLocationConsent: false,
      keepDeniedHint: keepDeniedHint,
    );
  }

  Future<void> _save(
    OnboardingRepository repository,
    SessionController session,
    GeoPoint point, {
    required bool recordLocationConsent,
    required bool keepDeniedHint,
  }) async {
    try {
      if (recordLocationConsent) {
        await repository.saveConsents(const <ConsentDecision>[
          ConsentDecision(purpose: ConsentPurpose.location, granted: true),
        ]);
      }
      // Only the ~1 km area leaves the device, never the exact position.
      await repository.updateHomeLocation(roundForPrivacy(point));
      await session.advanceTo(OnboardingStep.interests);
    } on AppError catch (error) {
      if (ref.mounted) {
        state = LocationState(isLocationDenied: keepDeniedHint, error: error);
      }
    }
  }
}
