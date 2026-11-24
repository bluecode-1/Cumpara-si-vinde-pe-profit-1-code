import Core
import XCTest

final class PhoneNumberNormalizerTests: XCTestCase {
    func testAcceptsNationalFormWithLeadingZero() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0712345678"), "+40712345678")
    }

    func testAcceptsNationalFormWithoutLeadingZero() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("712345678"), "+40712345678")
    }

    func testAcceptsInternationalForm() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+40712345678"), "+40712345678")
    }

    func testAcceptsSpacesAnywhere() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0712 345 678"), "+40712345678")
        XCTAssertEqual(PhoneNumberNormalizer.normalize(" 712 345 678 "), "+40712345678")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+40 712 345 678"), "+40712345678")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+ 4 0 7 1 2 3 4 5 6 7 8"), "+40712345678")
    }

    func testRejectsEmptyAndBlank() {
        XCTAssertNil(PhoneNumberNormalizer.normalize(""))
        XCTAssertNil(PhoneNumberNormalizer.normalize("   "))
    }

    func testRejectsWrongLength() {
        XCTAssertNil(PhoneNumberNormalizer.normalize("071234567"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("07123456789"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("71234567"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("+4071234567"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("+407123456789"))
    }

    func testRejectsNonMobileNumbers() {
        // Landline (02x / 03x) and other prefixes are not mobile numbers.
        XCTAssertNil(PhoneNumberNormalizer.normalize("0212345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("0312345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("+40212345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("812345678"))
    }

    func testRejectsOtherPrefixesAndSeparators() {
        XCTAssertNil(PhoneNumberNormalizer.normalize("0040712345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("40712345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("+41712345678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("0712-345-678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("0712.345.678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("(0712) 345 678"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("+400712345678"))
    }

    func testRejectsLettersAndNonASCIIDigits() {
        XCTAssertNil(PhoneNumberNormalizer.normalize("07123abc78"))
        XCTAssertNil(PhoneNumberNormalizer.normalize("abcdefghij"))
        // Arabic-Indic digits are digits for Unicode but not for E.164.
        XCTAssertNil(PhoneNumberNormalizer.normalize("07١٢٣٤٥٦٧٨"))
    }

    func testIsValidMatchesNormalize() {
        XCTAssertTrue(PhoneNumberNormalizer.isValid("0712 345 678"))
        XCTAssertFalse(PhoneNumberNormalizer.isValid("12345"))
    }
}
