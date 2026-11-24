import Core
import Foundation
import Networking
import Persistence

/// `OnboardingRepository` backed by the API client, the secure token store
/// and the SwiftData progress store.
public final class DefaultOnboardingRepository: OnboardingRepository {
    private let client: APIClient
    private let tokenStore: TokenStore
    private let progressStore: OnboardingProgressStore

    public init(client: APIClient, tokenStore: TokenStore, progressStore: OnboardingProgressStore) {
        self.client = client
        self.tokenStore = tokenStore
        self.progressStore = progressStore
    }

    public func requestCode(phone: String) async throws -> OTPChallenge {
        try await mapped {
            try await self.client.send(APIEndpoints.requestOTP(phone: phone), as: OTPChallenge.self)
        }
    }

    public func verifyCode(challengeId: String, code: String) async throws -> Me {
        try await mapped {
            let session = try await self.client.send(
                APIEndpoints.verifyOTP(challengeId: challengeId, code: code),
                as: AuthSession.self
            )
            try self.tokenStore.save(session.tokens)
            return session.user
        }
    }

    public func saveConsents(_ consents: [ConsentInput]) async throws {
        try await mapped {
            try await self.client.sendExpectingNoContent(APIEndpoints.setConsents(consents))
        }
    }

    public func updateDisplayName(_ name: String) async throws -> Me {
        try await mapped {
            try await self.client.send(
                APIEndpoints.updateMe(MeUpdate(displayName: name)),
                as: Me.self
            )
        }
    }

    public func updateHomeLocation(
        _ location: GeoPoint,
        grantedLocationPermission: Bool
    ) async throws -> Me {
        try await mapped {
            let me = try await self.client.send(
                APIEndpoints.updateMe(MeUpdate(homeLocation: location)),
                as: Me.self
            )
            if grantedLocationPermission {
                let consent = ConsentInput(purpose: .location, granted: true)
                try await self.client.sendExpectingNoContent(APIEndpoints.setConsents([consent]))
            }
            return me
        }
    }

    public func topLevelCategories() async throws -> [CatalogCategory] {
        try await mapped {
            let all = try await self.client.send(APIEndpoints.categories(), as: [CatalogCategory].self)
            return all.filter { $0.isTopLevel }
        }
    }

    public func completeOnboarding(interestCategoryIds: [String]) async throws -> Me {
        try await mapped {
            let update = MeUpdate(
                interestCategoryIds: interestCategoryIds.isEmpty ? nil : interestCategoryIds,
                onboardingCompleted: true
            )
            return try await self.client.send(APIEndpoints.updateMe(update), as: Me.self)
        }
    }

    public func currentUser() async throws -> Me {
        try await mapped {
            try await self.client.send(APIEndpoints.me(), as: Me.self)
        }
    }

    public func loadProgress() async -> OnboardingProgress? {
        do {
            return try await progressStore.load()
        } catch {
            return nil
        }
    }

    public func saveProgress(_ progress: OnboardingProgress) async {
        do {
            try await progressStore.save(progress)
        } catch {
            // Losing the saved step only means the flow restarts later.
        }
    }

    /// Runs `operation` and converts any non-`AppError` failure (keychain,
    /// encoding) into `AppError.unknown`. Cancellation is passed through.
    private func mapped<Value>(_ operation: () async throws -> Value) async throws -> Value {
        do {
            return try await operation()
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw AppError.wrapping(error)
        }
    }
}
