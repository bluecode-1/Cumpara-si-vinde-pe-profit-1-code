import Core
import Foundation

/// The result of asking for the device location once.
public enum LocationOutcome: Equatable, Sendable {
    /// The (unrounded) current position.
    case located(GeoPoint)
    /// The user refused the permission, or location is restricted.
    case denied
    /// Permission was granted but no position could be determined.
    case unavailable
}

/// Asks for the location permission if needed and returns one position.
@MainActor
public protocol LocationProviding: AnyObject {
    func requestCurrentLocation() async -> LocationOutcome
}
