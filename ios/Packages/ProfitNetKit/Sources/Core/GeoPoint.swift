import Foundation

/// A WGS84 coordinate.
public struct GeoPoint: Codable, Equatable, Hashable, Sendable {
    public let lat: Double
    public let lng: Double

    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }

    /// The point with both coordinates rounded to two decimals (about 1 km).
    /// The home area is always rounded like this before it is sent.
    public func roundedForHomeArea() -> GeoPoint {
        GeoPoint(
            lat: CoordinateRounding.round(lat, decimals: 2),
            lng: CoordinateRounding.round(lng, decimals: 2)
        )
    }
}

public enum CoordinateRounding {
    /// Rounds half away from zero to the given number of decimals.
    public static func round(_ value: Double, decimals: Int) -> Double {
        let factor = pow(10.0, Double(max(0, decimals)))
        return (value * factor).rounded(.toNearestOrAwayFromZero) / factor
    }
}
