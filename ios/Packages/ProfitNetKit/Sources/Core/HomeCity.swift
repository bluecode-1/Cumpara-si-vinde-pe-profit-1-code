import Foundation

/// A city offered for the manual home-area choice during onboarding.
public struct HomeCity: Equatable, Hashable, Sendable, Identifiable {
    public let name: String
    public let location: GeoPoint

    public var id: String { name }

    public init(name: String, location: GeoPoint) {
        self.name = name
        self.location = location
    }

    /// The fixed list from the onboarding specification (name, lat, lng).
    public static let all: [HomeCity] = [
        HomeCity(name: "București", location: GeoPoint(lat: 44.43, lng: 26.10)),
        HomeCity(name: "Cluj-Napoca", location: GeoPoint(lat: 46.77, lng: 23.60)),
        HomeCity(name: "Timișoara", location: GeoPoint(lat: 45.76, lng: 21.23)),
        HomeCity(name: "Iași", location: GeoPoint(lat: 47.16, lng: 27.59)),
        HomeCity(name: "Constanța", location: GeoPoint(lat: 44.18, lng: 28.63)),
        HomeCity(name: "Brașov", location: GeoPoint(lat: 45.65, lng: 25.60)),
        HomeCity(name: "Craiova", location: GeoPoint(lat: 44.32, lng: 23.80)),
        HomeCity(name: "Galați", location: GeoPoint(lat: 45.44, lng: 28.05)),
        HomeCity(name: "Oradea", location: GeoPoint(lat: 47.05, lng: 21.93)),
        HomeCity(name: "Sibiu", location: GeoPoint(lat: 45.80, lng: 24.15)),
    ]
}
