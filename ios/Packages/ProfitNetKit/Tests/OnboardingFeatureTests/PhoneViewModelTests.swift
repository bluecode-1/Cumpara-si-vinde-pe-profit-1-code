import Core
import DesignSystem
@testable import OnboardingFeature
import XCTest

@MainActor
final class PhoneViewModelTests: XCTestCase {
    func testValidNumberRequestsCodeWithE164AndMovesOn() async {
        let repository = FakeOnboardingRepository()
        let viewModel = PhoneViewModel(repository: repository)
        var received: [(phone: String, challenge: OTPChallenge)] = []
        viewModel.onCodeRequested = { phone, challenge in
            received.append((phone: phone, challenge: challenge))
        }

        viewModel.state.input = "0712 345 678"
        await viewModel.submit()

        XCTAssertEqual(repository.requestedPhones, ["+40712345678"])
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received.first?.phone, "+40712345678")
        XCTAssertEqual(
            received.first?.challenge,
            OTPChallenge(challengeId: "challenge-1", retryAfterSeconds: 30)
        )
        XCTAssertNil(viewModel.state.error)
        XCTAssertFalse(viewModel.state.isSubmitting)
    }

    func testAcceptsAllDocumentedForms() async {
        for input in ["0712345678", "712345678", "+40712345678", "+40 712 345 678"] {
            let repository = FakeOnboardingRepository()
            let viewModel = PhoneViewModel(repository: repository)
            viewModel.state.input = input

            await viewModel.submit()

            XCTAssertEqual(repository.requestedPhones, ["+40712345678"], "input: \(input)")
        }
    }

    func testInvalidNumberShowsValidationErrorWithoutCallingTheServer() async {
        let repository = FakeOnboardingRepository()
        let viewModel = PhoneViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onCodeRequested = { _, _ in didMoveOn = true }

        viewModel.state.input = "0212345678"
        await viewModel.submit()

        XCTAssertTrue(repository.requestedPhones.isEmpty)
        XCTAssertEqual(viewModel.state.error?.key, .phoneErrorInvalid)
        XCTAssertFalse(didMoveOn)
    }

    func testEmptyInputShowsValidationError() async {
        let repository = FakeOnboardingRepository()
        let viewModel = PhoneViewModel(repository: repository)

        await viewModel.submit()

        XCTAssertTrue(repository.requestedPhones.isEmpty)
        XCTAssertEqual(viewModel.state.error?.key, .phoneErrorInvalid)
    }

    func testNetworkErrorShowsConnectionMessage() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(.network)
        let viewModel = PhoneViewModel(repository: repository)
        var didMoveOn = false
        viewModel.onCodeRequested = { _, _ in didMoveOn = true }

        viewModel.state.input = "0712345678"
        await viewModel.submit()

        XCTAssertEqual(viewModel.state.error?.key, .errorNetwork)
        XCTAssertFalse(viewModel.state.isSubmitting)
        XCTAssertFalse(didMoveOn)
    }

    func testRateLimitedShowsRateLimitMessage() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(AppError(code: AppError.Code.rateLimited, status: 429))
        let viewModel = PhoneViewModel(repository: repository)

        viewModel.state.input = "0712345678"
        await viewModel.submit()

        XCTAssertEqual(viewModel.state.error?.key, .errorRateLimited)
    }

    func testUnknownServerErrorShowsGenericMessage() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(AppError(code: "SOMETHING_ELSE", status: 500))
        let viewModel = PhoneViewModel(repository: repository)

        viewModel.state.input = "0712345678"
        await viewModel.submit()

        XCTAssertEqual(viewModel.state.error?.key, .errorGeneric)
    }

    func testErrorIsClearedByASuccessfulRetry() async {
        let repository = FakeOnboardingRepository()
        repository.requestCodeResult = .failure(.network)
        let viewModel = PhoneViewModel(repository: repository)
        viewModel.state.input = "0712345678"
        await viewModel.submit()
        XCTAssertNotNil(viewModel.state.error)

        repository.requestCodeResult = .success(OTPChallenge(challengeId: "challenge-2", retryAfterSeconds: 30))
        await viewModel.submit()

        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual(repository.requestedPhones.count, 2)
    }

    func testRepeatedFailuresProduceDistinctErrorsForAnnouncement() async {
        let repository = FakeOnboardingRepository()
        let viewModel = PhoneViewModel(repository: repository)

        await viewModel.submit()
        let first = viewModel.state.error
        await viewModel.submit()
        let second = viewModel.state.error

        // Same message, different identity: the screen announces it again.
        XCTAssertEqual(first?.key, second?.key)
        XCTAssertNotEqual(first, second)
    }

    func testPrefilledPhoneShowsNationalPart() {
        let viewModel = PhoneViewModel(repository: FakeOnboardingRepository(), prefilledPhone: "+40712345678")
        XCTAssertEqual(viewModel.state.input, "712345678")
    }
}
