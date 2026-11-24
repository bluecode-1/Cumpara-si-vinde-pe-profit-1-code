import Core
import Foundation
@testable import OnboardingFeature

/// A scriptable `OnboardingRepository` that records its calls.
final class FakeOnboardingRepository: OnboardingRepository, @unchecked Sendable {
    private let lock = NSLock()

    // Scripted results. Tests set these before exercising a view model.
    private var _requestCodeResult: Result<OTPChallenge, AppError> =
        .success(OTPChallenge(challengeId: "challenge-1", retryAfterSeconds: 30))
    private var _verifyCodeResult: Result<Me, AppError> = .success(TestData.newUser)
    private var _saveConsentsError: AppError?
    private var _updateResult: Result<Me, AppError> = .success(TestData.newUser)
    private var _categoriesResult: Result<[CatalogCategory], AppError> = .success(TestData.categories)

    // Recorded calls.
    private var _requestedPhones: [String] = []
    private var _verifications: [Verification] = []
    private var _savedConsents: [[ConsentInput]] = []
    private var _displayNames: [String] = []
    private var _locations: [LocationUpdate] = []
    private var _completions: [[String]] = []
    private var _savedProgress: [OnboardingProgress] = []

    struct Verification: Equatable {
        let challengeId: String
        let code: String
    }

    struct LocationUpdate: Equatable {
        let location: GeoPoint
        let grantedLocationPermission: Bool
    }

    private func locked<Value>(_ work: () -> Value) -> Value {
        lock.lock()
        defer { lock.unlock() }
        return work()
    }

    var requestCodeResult: Result<OTPChallenge, AppError> {
        get { locked { _requestCodeResult } }
        set { locked { _requestCodeResult = newValue } }
    }

    var verifyCodeResult: Result<Me, AppError> {
        get { locked { _verifyCodeResult } }
        set { locked { _verifyCodeResult = newValue } }
    }

    var saveConsentsError: AppError? {
        get { locked { _saveConsentsError } }
        set { locked { _saveConsentsError = newValue } }
    }

    var updateResult: Result<Me, AppError> {
        get { locked { _updateResult } }
        set { locked { _updateResult = newValue } }
    }

    var categoriesResult: Result<[CatalogCategory], AppError> {
        get { locked { _categoriesResult } }
        set { locked { _categoriesResult = newValue } }
    }

    var requestedPhones: [String] { locked { _requestedPhones } }
    var verifications: [Verification] { locked { _verifications } }
    var savedConsents: [[ConsentInput]] { locked { _savedConsents } }
    var displayNames: [String] { locked { _displayNames } }
    var locations: [LocationUpdate] { locked { _locations } }
    var completions: [[String]] { locked { _completions } }
    var savedProgress: [OnboardingProgress] { locked { _savedProgress } }

    // MARK: - OnboardingRepository

    func requestCode(phone: String) async throws -> OTPChallenge {
        let result: Result<OTPChallenge, AppError> = locked {
            _requestedPhones.append(phone)
            return _requestCodeResult
        }
        return try result.get()
    }

    func verifyCode(challengeId: String, code: String) async throws -> Me {
        let result: Result<Me, AppError> = locked {
            _verifications.append(Verification(challengeId: challengeId, code: code))
            return _verifyCodeResult
        }
        return try result.get()
    }

    func saveConsents(_ consents: [ConsentInput]) async throws {
        let error: AppError? = locked {
            _savedConsents.append(consents)
            return _saveConsentsError
        }
        if let error {
            throw error
        }
    }

    func updateDisplayName(_ name: String) async throws -> Me {
        let result: Result<Me, AppError> = locked {
            _displayNames.append(name)
            return _updateResult
        }
        return try result.get()
    }

    func updateHomeLocation(_ location: GeoPoint, grantedLocationPermission: Bool) async throws -> Me {
        let result: Result<Me, AppError> = locked {
            _locations.append(
                LocationUpdate(location: location, grantedLocationPermission: grantedLocationPermission)
            )
            return _updateResult
        }
        return try result.get()
    }

    func topLevelCategories() async throws -> [CatalogCategory] {
        try categoriesResult.get()
    }

    func completeOnboarding(interestCategoryIds: [String]) async throws -> Me {
        let result: Result<Me, AppError> = locked {
            _completions.append(interestCategoryIds)
            return _updateResult
        }
        return try result.get()
    }

    func currentUser() async throws -> Me {
        try updateResult.get()
    }

    func loadProgress() async -> OnboardingProgress? {
        savedProgress.last
    }

    func saveProgress(_ progress: OnboardingProgress) async {
        locked { _savedProgress.append(progress) }
    }
}

/// A `LocationProviding` that returns a scripted outcome.
@MainActor
final class FakeLocationProvider: LocationProviding {
    var outcome: LocationOutcome
    private(set) var requestCount = 0

    init(outcome: LocationOutcome) {
        self.outcome = outcome
    }

    func requestCurrentLocation() async -> LocationOutcome {
        requestCount += 1
        return outcome
    }
}

enum TestData {
    static let limits = TransactionLimits(
        maxTransaction: Money(amountMinor: 150_000, currency: .ron),
        monthlyVolume: Money(amountMinor: 500_000, currency: .ron)
    )

    static let newUser = Me(
        id: "user-1",
        displayName: "",
        memberSince: "2026-11-23",
        phone: "+40712345678",
        limits: limits
    )

    static let namedUser = Me(
        id: "user-1",
        displayName: "Ioana",
        memberSince: "2026-11-23",
        phone: "+40712345678",
        limits: limits
    )

    static let onboardedUser = Me(
        id: "user-1",
        displayName: "Ioana",
        memberSince: "2026-11-23",
        phone: "+40712345678",
        limits: limits,
        onboardingCompleted: true
    )

    static let categories = [
        CatalogCategory(id: "cat-1", slug: "haine", name: "Haine și încălțăminte"),
        CatalogCategory(id: "cat-2", slug: "electronice", name: "Electronice"),
        CatalogCategory(id: "cat-3", slug: "carti", name: "Cărți"),
    ]
}
