import CoreText
import DesignSystem
import XCTest

final class TokenParityTests: XCTestCase {
    /// `design/tokens.json`, copied by `ios/Scripts/sync-fixtures.sh`.
    private func loadTokens() throws -> [String: Any] {
        let url = try XCTUnwrap(
            Bundle.module.url(forResource: "tokens", withExtension: "json", subdirectory: "Tokens")
        )
        let object = try JSONSerialization.jsonObject(with: Data(contentsOf: url))
        return try XCTUnwrap(object as? [String: Any])
    }

    private func hexValue(_ text: String) -> UInt32? {
        guard text.hasPrefix("#"), text.count == 7 else {
            return nil
        }
        return UInt32(text.dropFirst(), radix: 16)
    }

    private func assertPalette(
        _ palette: [String: UInt32],
        matches scheme: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let tokens = try loadTokens()
        let colors = try XCTUnwrap(tokens["color"] as? [String: Any], file: file, line: line)
        let roles = try XCTUnwrap(colors[scheme] as? [String: String], file: file, line: line)

        XCTAssertEqual(Set(palette.keys), Set(roles.keys), file: file, line: line)
        for (role, hexText) in roles {
            XCTAssertEqual(
                palette[role],
                hexValue(hexText),
                "\(scheme).\(role) differs from tokens.json",
                file: file,
                line: line
            )
        }
    }

    func testLightPaletteMatchesTokens() throws {
        try assertPalette(PNPalette.light, matches: "light")
    }

    func testDarkPaletteMatchesTokens() throws {
        try assertPalette(PNPalette.dark, matches: "dark")
    }

    func testTypeScaleMatchesTokens() throws {
        let tokens = try loadTokens()
        let typography = try XCTUnwrap(tokens["typography"] as? [String: Any])
        let scale = try XCTUnwrap(typography["scaleSp"] as? [String: [String: Any]])

        let styles: [String: PNTextStyle] = [
            "displaySmall": .displaySmall,
            "headlineSmall": .headlineSmall,
            "titleLarge": .titleLarge,
            "titleMedium": .titleMedium,
            "bodyLarge": .bodyLarge,
            "bodyMedium": .bodyMedium,
            "labelLarge": .labelLarge,
            "labelMedium": .labelMedium,
        ]
        let fontNames = [
            "medium": PNFonts.medium,
            "semiBold": PNFonts.semiBold,
            "bold": PNFonts.bold,
        ]

        XCTAssertEqual(Set(styles.keys), Set(scale.keys))
        XCTAssertEqual(styles.count, PNTextStyle.allCases.count)
        for (name, style) in styles {
            let token = try XCTUnwrap(scale[name])
            let size = try XCTUnwrap(token["size"] as? Double)
            let weight = try XCTUnwrap(token["weight"] as? String)
            XCTAssertEqual(Double(style.size), size, accuracy: 0.001, "\(name) size")
            XCTAssertEqual(style.fontName, fontNames[weight], "\(name) weight")
        }
    }

    func testSpacingAndRadiusMatchTokens() throws {
        let tokens = try loadTokens()
        let spacing = try XCTUnwrap(tokens["spacingDp"] as? [String: Double])
        XCTAssertEqual(Double(PNSpacing.xs), spacing["xs"])
        XCTAssertEqual(Double(PNSpacing.sm), spacing["sm"])
        XCTAssertEqual(Double(PNSpacing.md), spacing["md"])
        XCTAssertEqual(Double(PNSpacing.lg), spacing["lg"])
        XCTAssertEqual(Double(PNSpacing.xl), spacing["xl"])

        let radius = try XCTUnwrap(tokens["radiusDp"] as? [String: Double])
        XCTAssertEqual(Double(PNRadius.small), radius["small"])
        XCTAssertEqual(Double(PNRadius.medium), radius["medium"])
        XCTAssertEqual(Double(PNRadius.large), radius["large"])
    }

    func testMinimumTouchTargetIs44Points() {
        XCTAssertGreaterThanOrEqual(PNMetrics.minTouchTarget, 44)
    }
}

final class FontRegistrationTests: XCTestCase {
    func testManropeFontsAreAvailableAfterRegistration() {
        PNFonts.registerIfNeeded()
        for name in [PNFonts.medium, PNFonts.semiBold, PNFonts.bold] {
            // CoreText falls back to another font when the name is unknown,
            // so compare the PostScript name of what it returns.
            let font = CTFontCreateWithName(name as CFString, 16, nil)
            XCTAssertEqual(CTFontCopyPostScriptName(font) as String, name)
        }
    }
}

final class L10nKeyTests: XCTestCase {
    func testKeysAreUniqueSnakeCase() {
        let rawValues = L10nKey.allCases.map(\.rawValue)
        XCTAssertEqual(Set(rawValues).count, rawValues.count)
        for rawValue in rawValues {
            XCTAssertTrue(
                rawValue.allSatisfy { ($0 >= "a" && $0 <= "z") || $0 == "_" },
                "\(rawValue) is not lower snake case"
            )
        }
    }
}
