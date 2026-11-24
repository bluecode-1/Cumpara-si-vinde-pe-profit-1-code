import Core
import DesignSystem
@testable import OnboardingFeature
import XCTest

/// A clock the tests can move forward.
final class TestClock {
    var now: Date

    init(now: Date = Date(timeIntervalSince1970: 1_800_000_000)) {
        self.now = now
    }

    func advance(by seconds: TimeInterval) {
        now = now.addingTimeInterval(seconds)
    }
}

@MainActor
final class CodeViewModelTests: XCTestCase {
    private let phone = "+40712345678"
    private let challenge = OTPChallenge(challengeId: "challenge-1", retryAfterSeconds: 30)

    private func makeViewModel(
        repository: FakeOnboardingRepository,
        clock: TestClock = TestClock()
    ) -> CodeViewModel {
        CodeViewModel(phone: phone, challenge: challenge, repository: repository, now: { clock.now })
    }

    // MARK: - Verification

    func testSixthDigitSubmitsAutomaticallyAndMovesOn() async {
        let repository = FakeOnboardingRepository()
        let viewModel = makeViewModel(repository: repository)
        var verifiedUsers: [Me] = []
        viewModel.onVerified = { verifiedUsers.append($0) }

        viewModel.state.code = "123456"
        await viewModel.codeChanged()

        XCTAssertEqual(
            repository.verifications,
            [FakeOnboardingRepository.Verification(challengeId: "challenge-1", code: "123456")]
        )
        XCTAssertEqual(verifiedUsers, [TestData.newUser])
        XCTAssertNil(viewModel.state.error)
        XCTAssertFalse(viewModel.state.isSubmitting)
    }

    func testFewerThanSixDigitsDoesNotSubmit() async {
        let repository = FakeOnboardingRepository()
        let viewModel = makeViewModel(repository: repository)

        viewModel.state.code = "12345"
        await viewModel.codeChanged()
        await viewModel.submit()

        XCTAssertTrue(repository.verifications.isEmpty)
    }

    func testInputIsReducedToAtMostSixDigits() async {
        let repository = FakeOnboardingRepository()
        let viewModel = makeViewModel(repository: repository)

        viewModel.state.code = "12a 3"
        await viewModel.codeChanged()
        XCTAssertEqual(viewModel.state.code, "123")
        XCTAssertTrue(repository.verifications.isEmpty)

        viewModel.state.code = "1234567890"
        await viewModel.codeChanged()
        XCTAssertEqual(viewModel.state.code, "123456")
        XCTAssertEqual(repository.verifications.map(\.code), ["123456"])
    }

    func testOTPInvalidClearsTheFieldAndShowsTheMessage() async {
        let repository = FakeOnboardingRepository()
        repository.verifyCodeResult = .failure(AppError(code: AppError.Code.otpInvalid, status: 422))
        let viewModel = makeViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onVerified = { _ in didMoveOn = true }

        viewModel.state.code = "000000"
        await viewModel.codeChanged()

        XCTAssertEqual(viewModel.state.code, "")
        XCTAssertEqual(viewModel.state.error?.key, .errorOtpInvalid)
        XCTAssertFalse(viewModel.state.isSubmitting)
        XCTAssertFalse(didMoveOn)
    }

    func testNetworkErrorKeepsTheCodeAndShowsTheConnectionMessage() async {
        let repository = FakeOnboardingRepository()
        repository.verifyCodeResult = .failure(.network)
        let viewModel = makeViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onVerified = { _ in didMoveOn = true }

        viewModel.state.code = "123456"
        await viewModel.codeChanged()

        XCTAssertEqual(viewModel.state.code, "123456")
        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(didMoveOn)

        // The user can retry with the same code once the network is back.
        repository.verifyCodeResult = .success(TestData.newUser)
        await viewModel.submit()
        XCTAssertTrue(didMoveOn)
        XCTAssertNil(viewModel.state.error)
    }

    func testAfterOTPInvalidACorrectCodeSucceeds() async {
        let repository = FakeOnboardingRepository()
        repository.verifyCodeResult = .failure(AppError(code: AppError.Code.otpInvalid, status: 422))
        let viewModel = makeViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onVerified = { _ in didMoveOn = true }
        viewModel.state.code = "000000"
        await viewModel.codeChanged()

        repository.verifyCodeResult = .success(TestData.newUser)
        viewModel.state.code = "123456"
        await viewModel.codeChanged()

        XCTAssertTrue(didMoveOn)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual(repository.verifications.map(\.code), ["000000", "123456"])
    }

    // MARK: - Resend countdown

    func testResendIsBlockedUntilTheCountdownExpires() async {
        let repository = FakeOnboardingRepository()
        let clock = TestClock()
        let viewModel = makeViewModel(repository: repository, clock: clock)

        XCTAssertEqual(viewModel.state.secondsUntilResend, 30)
        XCTAssertFalse(viewModel.state.canResend)

        await viewModel.resend()
        XCTAssertTrue(repository.requestedPhones.isEmpty)

        clock.advance(by: 10)
        viewModel.tick()
        XCTAssertEqual(viewModel.state.secondsUntilResend, 20)

        clock.advance(by: 20)
        viewModel.tick()
        XCTAssertEqual(viewModel.state.secondsUntilResend, 0)
        XCTAssertTrue(viewModel.state.canResend)
    }

    func testResendRequestsANewCodeAndRestartsTheCountdown() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .success(OTPChallenge(challengeId: "challenge-2", retryAfterSeconds: 45))
        let clock = TestClock()
        let viewModel = makeViewModel(repository: repository, clock: clock)
        clock.advance(by: 30)
        viewModel.tick()

        await viewModel.resend()

        XCTAssertEqual(repository.requestedPhones, [phone])
        XCTAssertEqual(viewModel.state.secondsUntilResend, 45)
        XCTAssertFalse(viewModel.state.canResend)
        XCTAssertFalse(viewModel.state.isResending)

        // The next verification uses the new challenge.
        viewModel.state.code = "123456"
        await viewModel.codeChanged()
        XCTAssertEqual(repository.verifications.last?.challengeId, "challenge-2")
    }

    func testRateLimitedOnVerifyShowsMessageAndKeepsResendBlocked() async {
        let repository = FakeOnboardingRepository()
        repository.verifyCodeResult = .failure(AppError(code: AppError.Code.rateLimited, status: 429))
        let clock = TestClock()
        let viewModel = makeViewModel(repository: repository, clock: clock)
        clock.advance(by: 12)

        viewModel.state.code = "123456"
        await viewModel.codeChanged()

        XCTAssertEqual(viewModel.state.error?.key, .errorRateLimited)
        // The running countdown continues; resend stays blocked.
        XCTAssertEqual(viewModel.state.secondsUntilResend, 18)
        XCTAssertFalse(viewModel.state.canResend)
        await viewModel.resend()
        XCTAssertTrue(repository.requestedPhones.isEmpty)
    }

    func testRateLimitedOnResendShowsMessageAndBlocksResendAgain() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(AppError(code: AppError.Code.rateLimited, status: 429))
        let clock = TestClock()
        let viewModel = makeViewModel(repository: repository, clock: clock)
        clock.advance(by: 30)
        viewModel.tick()
        XCTAssertTrue(viewModel.state.canResend)

        await viewModel.resend()

        XCTAssertEqual(viewModel.state.error?.key, .errorRateLimited)
        XCTAssertEqual(viewModel.state.secondsUntilResend, 30)
        XCTAssertFalse(viewModel.state.canResend)

        // Blocked until the new countdown expires.
        await viewModel.resend()
        XCTAssertEqual(repository.requestedPhones.count, 1)
    }

    func testNetworkErrorOnResendShowsTheConnectionMessage() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(.network)
        let clock = TestClock()
        let viewModel = makeViewModel(repository: repository, clock: clock)
        clock.advance(by: 31)
        viewModel.tick()

        await viewModel.resend()

        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(viewModel.state.isResending)
        // Not a rate limit: the user may try again right away.
        XCTAssertTrue(viewModel.state.canResend)
    }
}
