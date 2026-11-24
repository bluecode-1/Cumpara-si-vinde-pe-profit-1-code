import Core
import DesignSystem
@testable import OnboardingFeature
import XCTest

@MainActor
final class ConsentsViewModelTests: XCTestCase {
    func testOptionalConsentsAreUncheckedByDefault() {
        let viewModel = ConsentsViewModel(repository: FakeOnboardingRepository())
        XCTAssertFalse(viewModel.state.terms)
        XCTAssertFalse(viewModel.state.privacy)
        XCTAssertFalse(viewModel.state.marketing)
        XCTAssertFalse(viewModel.state.analytics)
        XCTAssertFalse(viewModel.state.aiPhotoProcessing)
        XCTAssertFalse(viewModel.state.canContinue)
    }

    func testCannotContinueUntilBothRequiredConsentsAreGiven() async {
        let repository = FakeOnboardingRepository()
        let viewModel = ConsentsViewModel(repository: repository)

        viewModel.state.terms = true
        XCTAssertFalse(viewModel.state.canContinue)
        await viewModel.submit()
        XCTAssertTrue(repository.savedConsents.isEmpty)

        viewModel.state.privacy = true
        XCTAssertTrue(viewModel.state.canContinue)
    }

    func testSubmitSendsAllFiveConsentsWithThePolicyVersion() async {
        let repository = FakeOnboardingRepository()
        let viewModel = ConsentsViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onSaved = { didMoveOn = true }
        viewModel.state.terms = true
        viewModel.state.privacy = true
        viewModel.state.analytics = true

        await viewModel.submit()

        XCTAssertEqual(
            repository.savedConsents,
            [[
                ConsentInput(purpose: .terms, granted: true, policyVersion: "2026-11"),
                ConsentInput(purpose: .privacy, granted: true, policyVersion: "2026-11"),
                ConsentInput(purpose: .marketing, granted: false, policyVersion: "2026-11"),
                ConsentInput(purpose: .analytics, granted: true, policyVersion: "2026-11"),
                ConsentInput(purpose: .aiPhotoProcessing, granted: false, policyVersion: "2026-11"),
            ]]
        )
        XCTAssertTrue(didMoveOn)
    }

    func testFailureShowsMessageAndStays() async {
        let repository = FakeOnboardingRepository()
        repository.saveConsentsError = .network
        let viewModel = ConsentsViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onSaved = { didMoveOn = true }
        viewModel.state.terms = true
        viewModel.state.privacy = true

        await viewModel.submit()

        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(didMoveOn)
        XCTAssertFalse(viewModel.state.isSubmitting)
    }
}

@MainActor
final class NameViewModelTests: XCTestCase {
    func testValidNameIsTrimmedAndSaved() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .success(TestData.namedUser)
        let viewModel = NameViewModel(repository: repository)
        var saved: [Me] = []
        viewModel.onSaved = { saved.append($0) }

        viewModel.state.name = "  Ioana "
        await viewModel.submit()

        XCTAssertEqual(repository.displayNames, ["Ioana"])
        XCTAssertEqual(saved, [TestData.namedUser])
        XCTAssertNil(viewModel.state.error)
    }

    func testTooShortOrTooLongNameShowsLengthErrorWithoutCallingTheServer() async {
        let repository = FakeOnboardingRepository()
        let viewModel = NameViewModel(repository: repository)

        viewModel.state.name = "I"
        await viewModel.submit()
        XCTAssertEqual(viewModel.state.error?.key, .nameErrorLength)

        viewModel.state.name = String(repeating: "a", count: 41)
        await viewModel.submit()
        XCTAssertEqual(viewModel.state.error?.key, .nameErrorLength)

        XCTAssertTrue(repository.displayNames.isEmpty)
    }

    func testServerFailureShowsGenericMessage() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .failure(AppError(code: "VALIDATION_FAILED", status: 422))
        let viewModel = NameViewModel(repository: repository)

        viewModel.state.name = "Ioana"
        await viewModel.submit()

        XCTAssertEqual(viewModel.state.error?.key, .errorGeneric)
    }
}

@MainActor
final class LocationViewModelTests: XCTestCase {
    func testGrantedPermissionSavesRoundedLocationAndLocationConsent() async {
        let repository = FakeOnboardingRepository()
        let provider = FakeLocationProvider(outcome: .located(GeoPoint(lat: 44.4267674, lng: 26.1025384)))
        let viewModel = LocationViewModel(repository: repository, locationProvider: provider)
        var didMoveOn = false
        viewModel.onSaved = { _ in didMoveOn = true }

        await viewModel.useMyLocation()

        XCTAssertEqual(provider.requestCount, 1)
        XCTAssertEqual(repository.locations.count, 1)
        let update = repository.locations.first
        XCTAssertEqual(update?.location.lat ?? 0, 44.43, accuracy: 1e-9)
        XCTAssertEqual(update?.location.lng ?? 0, 26.10, accuracy: 1e-9)
        XCTAssertEqual(update?.grantedLocationPermission, true)
        XCTAssertTrue(didMoveOn)
        XCTAssertFalse(viewModel.state.isBusy)
    }

    func testDeniedPermissionShowsMessageAndDoesNotBlock() async {
        let repository = FakeOnboardingRepository()
        let provider = FakeLocationProvider(outcome: .denied)
        let viewModel = LocationViewModel(repository: repository, locationProvider: provider)
        var didMoveOn = false
        viewModel.onSaved = { _ in didMoveOn = true }

        await viewModel.useMyLocation()

        XCTAssertEqual(viewModel.state.error?.key, .locationDenied)
        XCTAssertTrue(repository.locations.isEmpty)
        XCTAssertFalse(didMoveOn)

        // The manual choice still works.
        viewModel.showCityPicker()
        XCTAssertTrue(viewModel.state.isCityPickerPresented)
        let cluj = HomeCity.all[1]
        await viewModel.pickCity(cluj)

        XCTAssertFalse(viewModel.state.isCityPickerPresented)
        XCTAssertEqual(
            repository.locations,
            [
                FakeOnboardingRepository.LocationUpdate(
                    location: GeoPoint(lat: 46.77, lng: 23.60),
                    grantedLocationPermission: false
                ),
            ]
        )
        XCTAssertTrue(didMoveOn)
        XCTAssertNil(viewModel.state.error)
    }

    func testUnavailableLocationShowsGenericMessage() async {
        let viewModel = LocationViewModel(
            repository: FakeOnboardingRepository(),
            locationProvider: FakeLocationProvider(outcome: .unavailable)
        )

        await viewModel.useMyLocation()

        XCTAssertEqual(viewModel.state.error?.key, .errorGeneric)
    }

    func testSaveFailureShowsMessage() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .failure(.network)
        let viewModel = LocationViewModel(
            repository: repository,
            locationProvider: FakeLocationProvider(outcome: .denied)
        )

        await viewModel.pickCity(HomeCity.all[0])

        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(viewModel.state.isBusy)
    }

    func testOffersTheTenCitiesFromTheSpecification() {
        let viewModel = LocationViewModel(
            repository: FakeOnboardingRepository(),
            locationProvider: FakeLocationProvider(outcome: .denied)
        )
        XCTAssertEqual(viewModel.cities.count, 10)
    }
}

@MainActor
final class InterestsViewModelTests: XCTestCase {
    func testLoadsCategories() async {
        let viewModel = InterestsViewModel(repository: FakeOnboardingRepository())

        await viewModel.load()

        XCTAssertEqual(viewModel.state.categories, TestData.categories)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertNil(viewModel.state.error)
    }

    func testFinishSendsSelectedIdsInDisplayOrder() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .success(TestData.onboardedUser)
        let viewModel = InterestsViewModel(repository: repository)
        var completed: [Me] = []
        viewModel.onCompleted = { completed.append($0) }
        await viewModel.load()

        viewModel.setSelected(true, for: TestData.categories[2])
        viewModel.setSelected(true, for: TestData.categories[0])
        viewModel.setSelected(true, for: TestData.categories[1])
        viewModel.setSelected(false, for: TestData.categories[1])
        XCTAssertTrue(viewModel.isSelected(TestData.categories[0]))
        XCTAssertFalse(viewModel.isSelected(TestData.categories[1]))

        await viewModel.finish()

        XCTAssertEqual(repository.completions, [["cat-1", "cat-3"]])
        XCTAssertEqual(completed, [TestData.onboardedUser])
    }

    func testSkipCompletesWithoutInterests() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .success(TestData.onboardedUser)
        let viewModel = InterestsViewModel(repository: repository)
        var completed: [Me] = []
        viewModel.onCompleted = { completed.append($0) }
        await viewModel.load()
        viewModel.setSelected(true, for: TestData.categories[0])

        await viewModel.skip()

        XCTAssertEqual(repository.completions, [[]])
        XCTAssertEqual(completed.count, 1)
    }

    func testLoadFailureShowsMessageButSkipStillWorks() async {
        let repository = FakeOnboardingRepository()
        repository.categoriesResult = .failure(.network)
        repository.updateResult = .success(TestData.onboardedUser)
        let viewModel = InterestsViewModel(repository: repository)
        var completed: [Me] = []
        viewModel.onCompleted = { completed.append($0) }

        await viewModel.load()
        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertTrue(viewModel.state.categories.isEmpty)

        await viewModel.skip()
        XCTAssertEqual(completed.count, 1)
    }

    func testCompletionFailureShowsMessage() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .failure(.network)
        let viewModel = InterestsViewModel(repository: repository)

        await viewModel.finish()

        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(viewModel.state.isSubmitting)
    }
}

final class ErrorMessagesTests: XCTestCase {
    func testMapsCodesToMessageKeys() {
        XCTAssertEqual(ErrorMessages.key(for: AppError(code: "OTP_INVALID", status: 422)), .errorOtpInvalid)
        XCTAssertEqual(ErrorMessages.key(for: AppError(code: "RATE_LIMITED", status: 429)), .errorRateLimited)
        XCTAssertEqual(ErrorMessages.key(for: AppError.network), .errorNetwork)
        XCTAssertEqual(ErrorMessages.key(for: AppError.unauthorized), .errorGeneric)
        XCTAssertEqual(ErrorMessages.key(for: AppError(code: "ANYTHING", status: 500)), .errorGeneric)
        XCTAssertEqual(ErrorMessages.key(for: CocoaError(.fileNoSuchFile)), .errorGeneric)
    }
}
