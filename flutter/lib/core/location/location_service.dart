import 'package:geolocator/geolocator.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Outcome of asking the device where it is.
sealed class LocationResult {
  const LocationResult();
}

final class LocationFound extends LocationResult {
  const LocationFound(this.point);

  /// The raw device position; callers round it before it leaves the device.
  final GeoPoint point;
}

/// The user declined the permission (now or permanently).
final class LocationPermissionDenied extends LocationResult {
  const LocationPermissionDenied();
}

/// Permission is fine but no position could be obtained (location services
/// switched off, time-out...).
final class LocationUnavailable extends LocationResult {
  const LocationUnavailable();
}

abstract interface class LocationService {
  /// Requests the permission if needed and returns the current position.
  /// Never throws.
  Future<LocationResult> currentLocation();
}

/// [LocationService] on the `geolocator` plugin. City-level accuracy is all
/// the app needs, so only coarse location is requested.
final class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService([GeolocatorPlatform? geolocator])
    : _geolocator = geolocator ?? GeolocatorPlatform.instance;

  final GeolocatorPlatform _geolocator;

  @override
  Future<LocationResult> currentLocation() async {
    try {
      LocationPermission permission = await _geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return const LocationPermissionDenied();
      }
      if (!await _geolocator.isLocationServiceEnabled()) {
        return const LocationUnavailable();
      }
      final Position position = await _geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return LocationFound(
        GeoPoint(lat: position.latitude, lng: position.longitude),
      );
    } on PermissionDeniedException {
      return const LocationPermissionDenied();
    } on Exception {
      return const LocationUnavailable();
    }
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => GeolocatorLocationService();
