import Core
import Foundation

/// Serialises token refresh between concurrent requests (single flight).
///
/// When several requests receive 401 at the same time, the first one starts
/// `POST /auth/refresh`; the others await the same task. A request that
/// arrives after the refresh finished notices that the stored access token is
/// no longer the one it failed with and reuses the new token without another
/// refresh.
///
/// If the server rejects the refresh, the session is cleared and
/// `onSessionCleared` is called. A connectivity failure during refresh does
/// not clear the session: the user is still signed in, just offline.
actor TokenRefresher {
    private let tokenStore: TokenStore
    private let transport: HTTPTransport
    private let onSessionCleared: @Sendable () -> Void
    private var refreshTask: Task<String, Error>?

    init(
        tokenStore: TokenStore,
        transport: HTTPTransport,
        onSessionCleared: @escaping @Sendable () -> Void
    ) {
        self.tokenStore = tokenStore
        self.transport = transport
        self.onSessionCleared = onSessionCleared
    }

    /// The stored access token, or `nil` when there is no session.
    func currentAccessToken() -> String? {
        storedTokens()?.accessToken
    }

    /// Returns a usable access token after a request failed with 401 while
    /// using `failedToken`.
    func refreshedAccessToken(replacing failedToken: String?) async throws -> String {
        if let refreshTask {
            return try await refreshTask.value
        }
        if let current = storedTokens()?.accessToken, current != failedToken {
            return current
        }

        let task = Task<String, Error> {
            try await self.performRefresh()
        }
        refreshTask = task
        defer { refreshTask = nil }
        return try await task.value
    }

    private func performRefresh() async throws -> String {
        guard let current = storedTokens() else {
            // Nothing to refresh with and nothing to clear: the session is
            // already gone (for example a previous refresh was rejected).
            throw AppError.unauthorized
        }

        let endpoint = try APIEndpoints.refresh(refreshToken: current.refreshToken)
        // Connectivity errors propagate from here without clearing the session.
        let (data, response) = try await transport.perform(endpoint, accessToken: nil)

        guard (200..<300).contains(response.statusCode),
              let tokens = try? JSONCoding.makeDecoder().decode(TokenPair.self, from: data)
        else {
            clearSession()
            throw AppError.unauthorized
        }

        do {
            try tokenStore.save(tokens)
        } catch {
            clearSession()
            throw AppError.unauthorized
        }
        return tokens.accessToken
    }

    private func storedTokens() -> TokenPair? {
        // `try?` flattens the optional returned by `load()`.
        try? tokenStore.load()
    }

    private func clearSession() {
        try? tokenStore.clear()
        onSessionCleared()
    }
}
