import 'package:profitnet/core/model/geo_point.dart';

/// Reduces a coordinate to 2 decimals (about 1 km) so that only the
/// approximate home area ever leaves the device.
GeoPoint roundForPrivacy(GeoPoint point) =>
    GeoPoint(lat: roundCoordinate(point.lat), lng: roundCoordinate(point.lng));

/// Rounds half away from zero to 2 decimals.
double roundCoordinate(double value) => (value * 100).round() / 100;
