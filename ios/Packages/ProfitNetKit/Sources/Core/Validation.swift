import Foundation

/// Normalises Romanian mobile numbers to E.164.
///
/// Accepted inputs (spaces allowed anywhere): `07XXXXXXXX`, `7XXXXXXXX`,
/// `+407XXXXXXXX`. The result is always `+407XXXXXXXX`. Anything else is
/// rejected and must not reach the server.
public enum PhoneNumberNormalizer {
    public static let countryPrefix = "+40"

    public static func normalize(_ input: String) -> String? {
        let compact = String(input.filter { !$0.isWhitespace })

        let national: Substring
        if compact.hasPrefix("+40") {
            national = compact.dropFirst(3)
        } else if compact.hasPrefix("0") {
            national = compact.dropFirst(1)
        } else {
            national = Substring(compact)
        }

        guard national.count == 9, national.first == "7" else {
            return nil
        }
        guard national.allSatisfy({ isASCIIDigit($0) }) else {
            return nil
        }
        return countryPrefix + String(national)
    }

    public static func isValid(_ input: String) -> Bool {
        normalize(input) != nil
    }

    private static func isASCIIDigit(_ character: Character) -> Bool {
        character >= "0" && character <= "9"
    }
}

/// Validates the display name: 2–40 characters after trimming whitespace.
public enum DisplayNameValidator {
    public static let minLength = 2
    public static let maxLength = 40

    /// Returns the trimmed name if it is valid, otherwise `nil`.
    public static func validated(_ input: String) -> String? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minLength, trimmed.count <= maxLength else {
            return nil
        }
        return trimmed
    }

    public static func isValid(_ input: String) -> Bool {
        validated(input) != nil
    }
}

/// Validates the SMS code: exactly six ASCII digits.
public enum OTPCodeValidator {
    public static let length = 6

    /// Keeps only ASCII digits and truncates to six characters.
    public static func sanitized(_ input: String) -> String {
        String(input.filter { $0 >= "0" && $0 <= "9" }.prefix(length))
    }

    public static func isValid(_ input: String) -> Bool {
        input.count == length && input.allSatisfy { $0 >= "0" && $0 <= "9" }
    }
}
