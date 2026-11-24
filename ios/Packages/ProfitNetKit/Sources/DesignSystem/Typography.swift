import CoreText
import Foundation
import SwiftUI

/// Registers the bundled Manrope fonts with the process.
public enum PNFonts {
    public static let medium = "Manrope-Medium"
    public static let semiBold = "Manrope-SemiBold"
    public static let bold = "Manrope-Bold"

    static let fileNames = [medium, semiBold, bold]

    /// Registers the fonts once. Safe to call repeatedly; registering an
    /// already registered font fails harmlessly. If registration fails,
    /// `Font.custom` falls back to the system font.
    public static func registerIfNeeded() {
        _ = registration
    }

    private static let registration: Bool = {
        for name in fileNames {
            guard let url = fontURL(named: name) else {
                continue
            }
            _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        return true
    }()

    /// The URL of a bundled font file, or `nil` if the resource is missing.
    static func fontURL(named name: String) -> URL? {
        Bundle.module.url(forResource: name, withExtension: "ttf")
            ?? Bundle.module.url(forResource: name, withExtension: "ttf", subdirectory: "Fonts")
    }
}

/// The type scale from `design/tokens.json` (`typography.scaleSp`).
///
/// Sizes are base sizes at the default Dynamic Type setting; every style
/// scales relative to a system text style.
public enum PNTextStyle: CaseIterable, Sendable {
    case displaySmall
    case headlineSmall
    case titleLarge
    case titleMedium
    case bodyLarge
    case bodyMedium
    case labelLarge
    case labelMedium

    public var size: CGFloat {
        switch self {
        case .displaySmall: return 32
        case .headlineSmall: return 24
        case .titleLarge: return 20
        case .titleMedium: return 16
        case .bodyLarge: return 16
        case .bodyMedium: return 14
        case .labelLarge: return 14
        case .labelMedium: return 12
        }
    }

    public var fontName: String {
        switch self {
        case .displaySmall, .headlineSmall, .titleLarge, .labelLarge:
            return PNFonts.bold
        case .titleMedium, .labelMedium:
            return PNFonts.semiBold
        case .bodyLarge, .bodyMedium:
            return PNFonts.medium
        }
    }

    /// The system style whose Dynamic Type curve this style follows.
    public var relativeTextStyle: Font.TextStyle {
        switch self {
        case .displaySmall: return .largeTitle
        case .headlineSmall: return .title
        case .titleLarge: return .title2
        case .titleMedium: return .headline
        case .bodyLarge: return .body
        case .bodyMedium: return .subheadline
        case .labelLarge: return .subheadline
        case .labelMedium: return .caption
        }
    }

    public var font: Font {
        Font.custom(fontName, size: size, relativeTo: relativeTextStyle)
    }
}

public extension View {
    /// Applies a Livadă text style. The font scales with Dynamic Type.
    func pnTextStyle(_ style: PNTextStyle) -> some View {
        font(style.font)
    }
}
