import Core
import Foundation
import Networking
import Persistence

/// What the provisional home screen needs.
public protocol HomeRepository: Sendable {
    /// `GET /me`. Throws `AppError`.
    func currentUser() async throws -> Me

    /// `POST /auth/logout`, then deletes the local session (tokens and saved
    /// onboarding progress). The local session is deleted even if the
    /// request fails, so this never throws.
    func logout() async
}

public final class DefaultHomeRepository: HomeRepository {
    private let client: APIClient
    private let tokenStore: TokenStore
    private let progressStore: OnboardingProgressStore

    public init(client: APIClient, tokenStore: TokenStore, progressStore: OnboardingProgressStore) {
        self.client = client
        self.tokenStore = tokenStore
        self.progressStore = progressStore
    }

    public func currentUser() async throws -> Me {
        do {
            return try await client.send(APIEndpoints.me(), as: Me.self)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw AppError.wrapping(error)
        }
    }

    public func logout() async {
        do {
            try await client.sendExpectingNoContent(APIEndpoints.logout())
        } catch {
            // Best effort: the refresh token family expires server-side anyway.
        }
        try? tokenStore.clear()
        do {
            try await progressStore.clear()
        } catch {
            // Nothing else to do; a stale row is overwritten at the next sign-in.
        }
    }
}
