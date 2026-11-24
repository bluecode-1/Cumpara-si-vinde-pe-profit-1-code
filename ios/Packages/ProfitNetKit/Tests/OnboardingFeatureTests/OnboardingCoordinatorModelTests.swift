import Core
@testable import OnboardingFeature
import XCTest

@MainActor
final class OnboardingCoordinatorModelTests: XCTestCase {
    private func makeModel(
        repository: FakeOnboardingRepository,
        startStep: OnboardingStep = .welcome,
        prefilledPhone: String? = nil,
        onCompleted: @escaping (Me) -> Void = { _ in }
    ) -> OnboardingCoordinatorModel {
        OnboardingCoordinatorModel(
            repository: repository,
            locationProvider: FakeLocationProvider(outcome: .denied),
            startStep: startStep,
            prefilledPhone: prefilledPhone,
            onCompleted: onCompleted
        )
    }

    func testStartsAtWelcomeAndPushesPhone() {
        let model = makeModel(repository: FakeOnboardingRepository())
        XCTAssertEqual(model.root, .welcome)
        XCTAssertTrue(model.path.isEmpty)

        model.start()

        XCTAssertEqual(model.path, [.phone])
    }

    func testNewUserGoesFromPhoneToCodeToConsents() async {
        let repository = FakeOnboardingRepository()
        let model = makeModel(repository: repository)
        model.start()

        model.phoneViewModel.state.input = "0712345678"
        await model.phoneViewModel.submit()
        XCTAssertEqual(model.path, [.phone, .code])
        let codeViewModel = model.codeViewModel
        XCTAssertNotNil(codeViewModel)
        XCTAssertEqual(codeViewModel?.phone, "+40712345678")

        codeViewModel?.state.code = "123456"
        await codeViewModel?.codeChanged()

        // The pre-authentication screens are no longer reachable with "back".
        XCTAssertEqual(model.root, .consents)
        XCTAssertTrue(model.path.isEmpty)
    }

    func testStepsAfterVerificationArePushedInOrder() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .success(TestData.namedUser)
        let model = makeModel(repository: repository, startStep: .consents)
        XCTAssertEqual(model.root, .consents)

        model.consentsViewModel.state.terms = true
        model.consentsViewModel.state.privacy = true
        await model.consentsViewModel.submit()
        XCTAssertEqual(model.path, [.name])

        model.nameViewModel.state.name = "Ioana"
        await model.nameViewModel.submit()
        XCTAssertEqual(model.path, [.name, .location])

        await model.locationViewModel.pickCity(HomeCity.all[0])
        XCTAssertEqual(model.path, [.name, .location, .interests])
    }

    func testFinishingInterestsSavesCompletedProgressAndCompletes() async {
        let repository = FakeOnboardingRepository()
        repository.updateResult = .success(TestData.onboardedUser)
        let completed = expectation(description: "onCompleted")
        var completedUser: Me?
        let model = makeModel(repository: repository, startStep: .interests) { me in
            completedUser = me
            completed.fulfill()
        }
        XCTAssertEqual(model.root, .interests)

        await model.interestsViewModel.skip()
        await fulfillment(of: [completed], timeout: 2)

        XCTAssertEqual(completedUser, TestData.onboardedUser)
        XCTAssertEqual(repository.savedProgress.last?.step, .completed)
        XCTAssertEqual(repository.savedProgress.last?.displayName, "Ioana")
    }

    func testAlreadyOnboardedUserCompletesRightAfterVerification() async {
        let repository = FakeOnboardingRepository()
        repository.verifyCodeResult = .success(TestData.onboardedUser)
        let completed = expectation(description: "onCompleted")
        let model = makeModel(repository: repository) { _ in
            completed.fulfill()
        }
        model.start()
        model.phoneViewModel.state.input = "0712345678"
        await model.phoneViewModel.submit()

        model.codeViewModel?.state.code = "123456"
        await model.codeViewModel?.codeChanged()
        await fulfillment(of: [completed], timeout: 2)

        // The consents step is not shown to a returning user.
        XCTAssertNotEqual(model.root, .consents)
    }

    func testResumeMapping() {
        XCTAssertEqual(makeModel(repository: FakeOnboardingRepository(), startStep: .name).root, .name)
        XCTAssertEqual(makeModel(repository: FakeOnboardingRepository(), startStep: .location).root, .location)
        // A code challenge is not resumed: the user re-enters at the phone
        // step with the number filled in.
        let model = makeModel(
            repository: FakeOnboardingRepository(),
            startStep: .code,
            prefilledPhone: "+40712345678"
        )
        XCTAssertEqual(model.root, .phone)
        XCTAssertEqual(model.phoneViewModel.state.input, "712345678")
    }
}
