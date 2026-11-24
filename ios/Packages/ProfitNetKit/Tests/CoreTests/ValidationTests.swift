import Core
import XCTest

final class DisplayNameValidatorTests: XCTestCase {
    func testAcceptsNamesBetweenTwoAndFortyCharacters() {
        XCTAssertEqual(DisplayNameValidator.validated("Io"), "Io")
        XCTAssertEqual(DisplayNameValidator.validated("Ioana"), "Ioana")
        let forty = String(repeating: "a", count: 40)
        XCTAssertEqual(DisplayNameValidator.validated(forty), forty)
    }

    func testRejectsTooShortAndTooLongNames() {
        XCTAssertNil(DisplayNameValidator.validated(""))
        XCTAssertNil(DisplayNameValidator.validated("I"))
        XCTAssertNil(DisplayNameValidator.validated(String(repeating: "a", count: 41)))
    }

    func testTrimsSurroundingWhitespaceBeforeCounting() {
        XCTAssertEqual(DisplayNameValidator.validated("  Ioana \n"), "Ioana")
        XCTAssertNil(DisplayNameValidator.validated("   "))
        XCTAssertNil(DisplayNameValidator.validated(" I "))
    }

    func testCountsCharactersNotBytes() {
        // Two characters, each several UTF-8 bytes long.
        XCTAssertEqual(DisplayNameValidator.validated("Șț"), "Șț")
        let fortyDiacritics = String(repeating: "ș", count: 40)
        XCTAssertTrue(DisplayNameValidator.isValid(fortyDiacritics))
    }

    func testKeepsInnerSpaces() {
        XCTAssertEqual(DisplayNameValidator.validated("Ana Maria"), "Ana Maria")
    }
}

final class OTPCodeValidatorTests: XCTestCase {
    func testValidCodeIsExactlySixDigits() {
        XCTAssertTrue(OTPCodeValidator.isValid("123456"))
        XCTAssertFalse(OTPCodeValidator.isValid("12345"))
        XCTAssertFalse(OTPCodeValidator.isValid("1234567"))
        XCTAssertFalse(OTPCodeValidator.isValid("12345a"))
        XCTAssertFalse(OTPCodeValidator.isValid(""))
    }

    func testSanitizedKeepsDigitsAndTruncates() {
        XCTAssertEqual(OTPCodeValidator.sanitized("12 34-56"), "123456")
        XCTAssertEqual(OTPCodeValidator.sanitized("1234567890"), "123456")
        XCTAssertEqual(OTPCodeValidator.sanitized("abc"), "")
    }
}
