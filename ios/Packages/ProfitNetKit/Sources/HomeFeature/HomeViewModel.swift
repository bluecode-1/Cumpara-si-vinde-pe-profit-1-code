import Core
import Foundation
import Observation

public struct HomeScreenState: Equatable, Sendable {
    public var displayName: String
    public var isLoggingOut: Bool = false

    public init(displayName: String) {
        self.displayName = displayName
    }
}

@MainActor
@Observable
public final class HomeViewModel {
    public var state: HomeScreenState

    private let repository: HomeRepository
    private let onLoggedOut: () -> Void

    public init(displayName: String, repository: HomeRepository, onLoggedOut: @escaping () -> Void) {
        self.state = HomeScreenState(displayName: displayName)
        self.repository = repository
        self.onLoggedOut = onLoggedOut
    }

    /// Refreshes the greeting from `GET /me`. Failures are ignored: the
    /// locally known name stays on screen.
    public func refresh() async {
        guard let me = try? await repository.currentUser() else {
            return
        }
        if !me.displayName.isEmpty {
            state.displayName = me.displayName
        }
    }

    public func logout() async {
        guard !state.isLoggingOut else {
            return
        }
        state.isLoggingOut = true
        await repository.logout()
        state.isLoggingOut = false
        onLoggedOut()
    }
}
