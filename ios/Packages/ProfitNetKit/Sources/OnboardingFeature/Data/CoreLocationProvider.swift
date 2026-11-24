import Core
import CoreLocation
import Foundation

/// `LocationProviding` on top of `CLLocationManager`.
///
/// Asks for the when-in-use permission if it was not decided yet, then
/// requests a single position. A refused or restricted permission yields
/// `.denied`; the screen then offers the manual city list.
@MainActor
public final class CoreLocationProvider: NSObject, LocationProviding {
    private let manager: CLLocationManager
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<LocationOutcome, Never>?

    public override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        // The home area is rounded to about 1 km, so coarse accuracy is enough.
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    public func requestCurrentLocation() async -> LocationOutcome {
        // Only one request at a time; a second tap while locating is ignored.
        guard authorizationContinuation == nil, locationContinuation == nil else {
            return .unavailable
        }

        var status = manager.authorizationStatus
        if status == .notDetermined {
            status = await withCheckedContinuation { continuation in
                authorizationContinuation = continuation
                manager.requestWhenInUseAuthorization()
            }
        }

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return await withCheckedContinuation { continuation in
                locationContinuation = continuation
                manager.requestLocation()
            }
        case .denied, .restricted, .notDetermined:
            return .denied
        @unknown default:
            return .denied
        }
    }

    private func authorizationChanged(to status: CLAuthorizationStatus) {
        // The delegate is also called while the system prompt is still on
        // screen; keep waiting until the user has decided.
        guard status != .notDetermined, let continuation = authorizationContinuation else {
            return
        }
        authorizationContinuation = nil
        continuation.resume(returning: status)
    }

    private func finishLocating(with outcome: LocationOutcome) {
        guard let continuation = locationContinuation else {
            return
        }
        locationContinuation = nil
        continuation.resume(returning: outcome)
    }
}

extension CoreLocationProvider: CLLocationManagerDelegate {
    public nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorizationChanged(to: status)
        }
    }

    public nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let outcome: LocationOutcome
        if let coordinate = locations.last?.coordinate {
            outcome = .located(GeoPoint(lat: coordinate.latitude, lng: coordinate.longitude))
        } else {
            outcome = .unavailable
        }
        Task { @MainActor in
            self.finishLocating(with: outcome)
        }
    }

    public nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let isDenied = (error as? CLError)?.code == .denied
        Task { @MainActor in
            self.finishLocating(with: isDenied ? .denied : .unavailable)
        }
    }
}
