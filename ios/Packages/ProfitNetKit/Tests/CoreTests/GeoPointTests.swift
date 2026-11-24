import Core
import XCTest

final class GeoPointTests: XCTestCase {
    func testRoundsToTwoDecimals() {
        let rounded = GeoPoint(lat: 44.4267674, lng: 26.1025384).roundedForHomeArea()
        XCTAssertEqual(rounded.lat, 44.43, accuracy: 1e-9)
        XCTAssertEqual(rounded.lng, 26.10, accuracy: 1e-9)
    }

    func testRoundsDownWhenThirdDecimalIsBelowFive() {
        let rounded = GeoPoint(lat: 46.7712, lng: 23.6236).roundedForHomeArea()
        XCTAssertEqual(rounded.lat, 46.77, accuracy: 1e-9)
        XCTAssertEqual(rounded.lng, 23.62, accuracy: 1e-9)
    }

    func testRoundsNegativeCoordinatesAwayFromZero() {
        let rounded = GeoPoint(lat: -33.8688, lng: -151.2093).roundedForHomeArea()
        XCTAssertEqual(rounded.lat, -33.87, accuracy: 1e-9)
        XCTAssertEqual(rounded.lng, -151.21, accuracy: 1e-9)
    }

    func testAlreadyRoundedValuesAreUnchanged() {
        let point = GeoPoint(lat: 47.16, lng: 27.59)
        XCTAssertEqual(point.roundedForHomeArea(), point)
    }

    func testCoordinateRoundingWithOtherPrecisions() {
        XCTAssertEqual(CoordinateRounding.round(44.4267674, decimals: 0), 44, accuracy: 1e-9)
        XCTAssertEqual(CoordinateRounding.round(44.4267674, decimals: 3), 44.427, accuracy: 1e-9)
    }

    func testCityListMatchesTheSpecification() {
        XCTAssertEqual(HomeCity.all.count, 10)
        XCTAssertEqual(HomeCity.all.first?.name, "București")
        XCTAssertEqual(HomeCity.all.first?.location, GeoPoint(lat: 44.43, lng: 26.10))
        XCTAssertEqual(HomeCity.all.last?.name, "Sibiu")
        // Every city is already at the precision that is sent to the server.
        for city in HomeCity.all {
            XCTAssertEqual(city.location.roundedForHomeArea().lat, city.location.lat, accuracy: 1e-9)
            XCTAssertEqual(city.location.roundedForHomeArea().lng, city.location.lng, accuracy: 1e-9)
        }
    }
}

final class AppErrorTests: XCTestCase {
    func testWrappingKeepsAppErrors() {
        let error = AppError(code: AppError.Code.otpInvalid, status: 422)
        XCTAssertEqual(AppError.wrapping(error), error)
    }

    func testWrappingOtherErrorsGivesUnknown() {
        struct SomeError: Error {}
        XCTAssertEqual(AppError.wrapping(SomeError()), .unknown)
    }
}
