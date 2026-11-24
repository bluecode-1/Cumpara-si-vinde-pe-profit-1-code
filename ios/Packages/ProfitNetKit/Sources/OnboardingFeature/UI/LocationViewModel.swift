import Core
import DesignSystem
import Foundation
import Observation

public struct LocationScreenState: Equatable, Sendable {
    /// True while waiting for the permission prompt or a position.
    public var isLocating: Bool = false
    /// True while the chosen area is being saved.
    public var isSaving: Bool = false
    public var isCityPickerPresented: Bool = false
    public var error: ScreenError?

    public init() {}

    public var isBusy: Bool {
        isLocating || isSaving
    }
}

@MainActor
@Observable
public final class LocationViewModel {
    public var state = LocationScreenState()

    public let cities: [HomeCity] = HomeCity.all

    @ObservationIgnored public var onSaved: (Me) -> Void = { _ in }

    private let repository: OnboardingRepository
    private let locationProvider: LocationProviding

    public init(repository: OnboardingRepository, locationProvider: LocationProviding) {
        self.repository = repository
        self.locationProvider = locationProvider
    }

    /// "Use my location": asks for the permission and saves the rounded position.
    public func useMyLocation() async {
        guard !state.isBusy else {
            return
        }
        state.error = nil
        state.isLocating = true
        let outcome = await locationProvider.requestCurrentLocation()
        state.isLocating = false

        switch outcome {
        case .located(let point):
            await save(point.roundedForHomeArea(), grantedLocationPermission: true)
        case .denied:
            // Not blocked: the user can pick a city from the list.
            state.error = ScreenError(.locationDenied)
        case .unavailable:
            state.error = ScreenError(.errorGeneric)
        }
    }

    public func showCityPicker() {
        guard !state.isBusy else {
            return
        }
        state.isCityPickerPresented = true
    }

    /// "I choose the city": saves the city's coordinates as the home area.
    public func pickCity(_ city: HomeCity) async {
        state.isCityPickerPresented = false
        guard !state.isBusy else {
            return
        }
        state.error = nil
        await save(city.location.roundedForHomeArea(), grantedLocationPermission: false)
    }

    private func save(_ location: GeoPoint, grantedLocationPermission: Bool) async {
        state.isSaving = true
        do {
            let me = try await repository.updateHomeLocation(
                location,
                grantedLocationPermission: grantedLocationPermission
            )
            state.isSaving = false
            onSaved(me)
        } catch is CancellationError {
            state.isSaving = false
        } catch {
            state.isSaving = false
            state.error = ScreenError(ErrorMessages.key(for: error))
        }
    }
}
