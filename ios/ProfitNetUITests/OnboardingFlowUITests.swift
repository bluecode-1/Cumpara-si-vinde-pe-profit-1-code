import XCTest

/// Happy path of the onboarding flow against the demo API
/// (`-FAKE_API 1`), from Welcome to the provisional home screen.
///
/// The identifiers below are set in `OnboardingFeature` / `HomeFeature`.
final class OnboardingFlowUITests: XCTestCase {
    private enum ID {
        static let welcomeStart = "onboarding.welcome.start"
        static let phoneField = "onboarding.phone.field"
        static let phoneSubmit = "onboarding.phone.submit"
        static let codeField = "onboarding.code.field"
        static let consentTerms = "onboarding.consents.terms"
        static let consentPrivacy = "onboarding.consents.privacy"
        static let consentsContinue = "onboarding.consents.continue"
        static let nameField = "onboarding.name.field"
        static let nameContinue = "onboarding.name.continue"
        static let locationPickCity = "onboarding.location.pickCity"
        static let firstCity = "onboarding.location.city.0"
        static let firstCategory = "onboarding.interests.category.haine"
        static let interestsFinish = "onboarding.interests.finish"
        static let errorMessage = "onboarding.error"
        static let homeGreeting = "home.greeting"
        static let homeLogout = "home.logout"
    }

    private let timeout: TimeInterval = 10

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        // Demo API, a clean session, Romanian texts.
        app.launchArguments += ["-FAKE_API", "1", "-RESET_STATE", "1"]
        app.launchArguments += ["-AppleLanguages", "(ro)", "-AppleLocale", "ro_RO"]
        app.launch()
        return app
    }

    private func waitFor(
        _ element: XCUIElement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            element.waitForExistence(timeout: timeout),
            "Expected \(element) to appear",
            file: file,
            line: line
        )
    }

    func testNewUserCompletesOnboardingAndLogsOut() throws {
        let app = launchApp()

        // 1. Welcome
        let start = app.buttons[ID.welcomeStart]
        waitFor(start)
        start.tap()

        // 2. Phone
        let phoneField = app.textFields[ID.phoneField]
        waitFor(phoneField)
        phoneField.tap()
        phoneField.typeText("0712345678")
        app.buttons[ID.phoneSubmit].tap()

        // 3. Code: the sixth digit submits automatically.
        let codeField = app.textFields[ID.codeField]
        waitFor(codeField)
        codeField.tap()
        codeField.typeText("123456")

        // 4. Consents: "Continue" is disabled until both required boxes are checked.
        let terms = app.buttons[ID.consentTerms]
        waitFor(terms)
        let consentsContinue = app.buttons[ID.consentsContinue]
        XCTAssertFalse(consentsContinue.isEnabled)
        terms.tap()
        app.buttons[ID.consentPrivacy].tap()
        XCTAssertTrue(consentsContinue.isEnabled)
        consentsContinue.tap()

        // 5. Name
        let nameField = app.textFields[ID.nameField]
        waitFor(nameField)
        nameField.tap()
        nameField.typeText("Ioana")
        app.buttons[ID.nameContinue].tap()

        // 6. Location: choose a city manually (no system permission prompt).
        let pickCity = app.buttons[ID.locationPickCity]
        waitFor(pickCity)
        pickCity.tap()
        let firstCity = app.buttons[ID.firstCity]
        waitFor(firstCity)
        firstCity.tap()

        // 7. Interests
        let category = app.buttons[ID.firstCategory]
        waitFor(category)
        category.tap()
        app.buttons[ID.interestsFinish].tap()

        // Home
        let greeting = app.staticTexts[ID.homeGreeting]
        waitFor(greeting)
        XCTAssertEqual(greeting.label, "Bună, Ioana")

        // Logout returns to Welcome.
        app.buttons[ID.homeLogout].tap()
        waitFor(app.buttons[ID.welcomeStart])
    }

    func testWrongCodeShowsErrorAndStaysOnCodeStep() throws {
        let app = launchApp()

        let start = app.buttons[ID.welcomeStart]
        waitFor(start)
        start.tap()

        let phoneField = app.textFields[ID.phoneField]
        waitFor(phoneField)
        phoneField.tap()
        phoneField.typeText("0712345678")
        app.buttons[ID.phoneSubmit].tap()

        let codeField = app.textFields[ID.codeField]
        waitFor(codeField)
        codeField.tap()
        codeField.typeText("000000")

        let error = app.staticTexts[ID.errorMessage]
        waitFor(error)
        XCTAssertEqual(error.label, "Codul nu este corect sau a expirat.")
        XCTAssertTrue(codeField.exists)
        XCTAssertFalse(app.buttons[ID.consentTerms].exists)
    }

    func testInvalidPhoneShowsValidationError() throws {
        let app = launchApp()

        let start = app.buttons[ID.welcomeStart]
        waitFor(start)
        start.tap()

        let phoneField = app.textFields[ID.phoneField]
        waitFor(phoneField)
        phoneField.tap()
        phoneField.typeText("12345")
        app.buttons[ID.phoneSubmit].tap()

        let error = app.staticTexts[ID.errorMessage]
        waitFor(error)
        XCTAssertEqual(error.label, "Introdu un număr de mobil valid, de exemplu 0712 345 678.")
        XCTAssertFalse(app.textFields[ID.codeField].exists)
    }
}
