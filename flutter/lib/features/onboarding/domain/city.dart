import 'package:profitnet/core/model/geo_point.dart';

/// A city offered when the user prefers not to share the device location.
final class City {
  const City(this.name, this.location);

  final String name;
  final GeoPoint location;
}

/// The manual choices, in the order given by the onboarding specification.
const List<City> manualCities = <City>[
  City('București', GeoPoint(lat: 44.43, lng: 26.10)),
  City('Cluj-Napoca', GeoPoint(lat: 46.77, lng: 23.60)),
  City('Timișoara', GeoPoint(lat: 45.76, lng: 21.23)),
  City('Iași', GeoPoint(lat: 47.16, lng: 27.59)),
  City('Constanța', GeoPoint(lat: 44.18, lng: 28.63)),
  City('Brașov', GeoPoint(lat: 45.65, lng: 25.60)),
  City('Craiova', GeoPoint(lat: 44.32, lng: 23.80)),
  City('Galați', GeoPoint(lat: 45.44, lng: 28.05)),
  City('Oradea', GeoPoint(lat: 47.05, lng: 21.93)),
  City('Sibiu', GeoPoint(lat: 45.80, lng: 24.15)),
];
