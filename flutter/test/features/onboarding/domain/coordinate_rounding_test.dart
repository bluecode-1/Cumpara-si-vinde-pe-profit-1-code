import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/features/onboarding/domain/city.dart';
import 'package:profitnet/features/onboarding/domain/coordinate_rounding.dart';

void main() {
  test('rounds to two decimals', () {
    expect(roundCoordinate(44.4267674), 44.43);
    expect(roundCoordinate(26.1025384), 26.1);
    expect(roundCoordinate(46.7712), 46.77);
    expect(roundCoordinate(23.6236), 23.62);
    expect(roundCoordinate(45.0), 45.0);
  });

  test('rounds half away from zero, also for negative coordinates', () {
    expect(roundCoordinate(0.125), 0.13);
    expect(roundCoordinate(-0.125), -0.13);
    expect(roundCoordinate(-73.98765), -73.99);
    expect(roundCoordinate(-0.001), 0.0);
  });

  test('rounds both components of a point', () {
    expect(
      roundForPrivacy(const GeoPoint(lat: 44.4267674, lng: 26.1025384)),
      const GeoPoint(lat: 44.43, lng: 26.1),
    );
  });

  test('is idempotent', () {
    final GeoPoint once = roundForPrivacy(
      const GeoPoint(lat: 47.158455, lng: 27.601442),
    );
    expect(roundForPrivacy(once), once);
    expect(once, const GeoPoint(lat: 47.16, lng: 27.6));
  });

  test('the manual cities are the ten from the specification', () {
    expect(manualCities.map((City city) => city.name), <String>[
      'București',
      'Cluj-Napoca',
      'Timișoara',
      'Iași',
      'Constanța',
      'Brașov',
      'Craiova',
      'Galați',
      'Oradea',
      'Sibiu',
    ]);
    expect(manualCities.first.location, const GeoPoint(lat: 44.43, lng: 26.1));
    expect(manualCities.last.location, const GeoPoint(lat: 45.8, lng: 24.15));
    for (final City city in manualCities) {
      expect(roundForPrivacy(city.location), city.location);
    }
  });
}
