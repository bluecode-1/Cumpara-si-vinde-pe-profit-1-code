import Core
import Foundation

/// Everything the onboarding screens need from the outside world.
/// All methods throw `AppError` only.
public protocol OnboardingRepository: Sendable {
    /// `POST /auth/otp/request`. `phone` must be E.164.
    func requestCode(phone: String) async throws -> OTPChallenge

    /// `POST /auth/otp/verify`. On success the tokens are stored securely
    /// and the authenticated user is returned.
    func verifyCode(challengeId: String, code: String) async throws -> Me

    /// `PUT /me/consents`.
    func saveConsents(_ consents: [ConsentInput]) async throws

    /// `PATCH /me` with `displayName`.
    func updateDisplayName(_ name: String) async throws -> Me

    /// `PATCH /me` with `homeLocation` (already rounded). When
    /// `grantedLocationPermission` is true, also records the `LOCATION` consent.
    func updateHomeLocation(_ location: GeoPoint, grantedLocationPermission: Bool) async throws -> Me

    /// `GET /categories`, filtered to the top level.
    func topLevelCategories() async throws -> [CatalogCategory]

    /// `PATCH /me` with the chosen interests and `onboardingCompleted: true`.
    func completeOnboarding(interestCategoryIds: [String]) async throws -> Me

    /// `GET /me`.
    func currentUser() async throws -> Me

    /// The locally saved progress, if any. Never throws: a storage failure
    /// only means the flow restarts.
    func loadProgress() async -> OnboardingProgress?

    /// Saves the progress locally so the flow can be resumed.
    func saveProgress(_ progress: OnboardingProgress) async
}
