import Core
import HomeFeature
import XCTest

private final class FakeHomeRepository: HomeRepository, @unchecked Sendable {
    private let lock = NSLock()
    private var _logoutCount = 0
    private let user: Me?

    init(user: Me?) {
        self.user = user
    }

    var logoutCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _logoutCount
    }

    func currentUser() async throws -> Me {
        guard let user else {
            throw AppError.network
        }
        return user
    }

    func logout() async {
        recordLogout()
    }

    private func recordLogout() {
        lock.lock()
        defer { lock.unlock() }
        _logoutCount += 1
    }
}

@MainActor
final class HomeViewModelTests: XCTestCase {
    private func makeUser(displayName: String) -> Me {
        Me(
            id: "user-1",
            displayName: displayName,
            memberSince: "2026-11-23",
            phone: "+40712345678",
            limits: TransactionLimits(
                maxTransaction: Money(amountMinor: 150_000, currency: .ron),
                monthlyVolume: Money(amountMinor: 500_000, currency: .ron)
            ),
            onboardingCompleted: true
        )
    }

    func testLogoutCallsRepositoryThenNotifies() async {
        let repository = FakeHomeRepository(user: nil)
        var loggedOutCount = 0
        let viewModel = HomeViewModel(displayName: "Ioana", repository: repository) {
            loggedOutCount += 1
        }

        await viewModel.logout()

        XCTAssertEqual(repository.logoutCount, 1)
        XCTAssertEqual(loggedOutCount, 1)
        XCTAssertFalse(viewModel.state.isLoggingOut)
    }

    func testRefreshUpdatesTheGreetingName() async {
        let repository = FakeHomeRepository(user: makeUser(displayName: "Ioana Maria"))
        let viewModel = HomeViewModel(displayName: "Ioana", repository: repository) {}

        await viewModel.refresh()

        XCTAssertEqual(viewModel.state.displayName, "Ioana Maria")
    }

    func testRefreshFailureKeepsTheKnownName() async {
        let repository = FakeHomeRepository(user: nil)
        let viewModel = HomeViewModel(displayName: "Ioana", repository: repository) {}

        await viewModel.refresh()

        XCTAssertEqual(viewModel.state.displayName, "Ioana")
    }
}
