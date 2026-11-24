import SwiftUI
import UIKit

/// The "Livadă" colour roles from `design/tokens.json` as 0xRRGGBB values.
/// `DesignSystemTests` checks these tables against the token file.
public enum PNPalette {
    public static let light: [String: UInt32] = [
        "primary": 0x4F5D23,
        "onPrimary": 0xFFFFFF,
        "primaryContainer": 0xDCE5B4,
        "onPrimaryContainer": 0x1F2607,
        "secondary": 0x9B3B2E,
        "onSecondary": 0xFFFFFF,
        "secondaryContainer": 0xF6DDD6,
        "onSecondaryContainer": 0x3D120B,
        "background": 0xF4F1E8,
        "onBackground": 0x20231A,
        "surface": 0xF4F1E8,
        "onSurface": 0x20231A,
        "surfaceContainer": 0xE9E5D6,
        "onSurfaceVariant": 0x5A5F4C,
        "outline": 0x7B7F6A,
        "outlineVariant": 0xD3CEBB,
        "error": 0xB3261E,
        "onError": 0xFFFFFF,
        "errorContainer": 0xF9DEDC,
        "onErrorContainer": 0x410E0B,
    ]

    public static let dark: [String: UInt32] = [
        "primary": 0xB9CC7A,
        "onPrimary": 0x232B08,
        "primaryContainer": 0x3A4517,
        "onPrimaryContainer": 0xDCE5B4,
        "secondary": 0xE79A8B,
        "onSecondary": 0x4A160D,
        "secondaryContainer": 0x6B261B,
        "onSecondaryContainer": 0xF6DDD6,
        "background": 0x15170F,
        "onBackground": 0xECE9DD,
        "surface": 0x15170F,
        "onSurface": 0xECE9DD,
        "surfaceContainer": 0x22251A,
        "onSurfaceVariant": 0xAEB09C,
        "outline": 0x8C8F7A,
        "outlineVariant": 0x363A2B,
        "error": 0xF2B8B5,
        "onError": 0x601410,
        "errorContainer": 0x8C1D18,
        "onErrorContainer": 0xF9DEDC,
    ]
}

/// Dynamic colours that follow the light / dark appearance.
public enum PNColors {
    public static let primary = dynamic("primary")
    public static let onPrimary = dynamic("onPrimary")
    public static let primaryContainer = dynamic("primaryContainer")
    public static let onPrimaryContainer = dynamic("onPrimaryContainer")
    public static let secondary = dynamic("secondary")
    public static let onSecondary = dynamic("onSecondary")
    public static let secondaryContainer = dynamic("secondaryContainer")
    public static let onSecondaryContainer = dynamic("onSecondaryContainer")
    public static let background = dynamic("background")
    public static let onBackground = dynamic("onBackground")
    public static let surface = dynamic("surface")
    public static let onSurface = dynamic("onSurface")
    public static let surfaceContainer = dynamic("surfaceContainer")
    public static let onSurfaceVariant = dynamic("onSurfaceVariant")
    public static let outline = dynamic("outline")
    public static let outlineVariant = dynamic("outlineVariant")
    public static let error = dynamic("error")
    public static let onError = dynamic("onError")
    public static let errorContainer = dynamic("errorContainer")
    public static let onErrorContainer = dynamic("onErrorContainer")

    private static func dynamic(_ role: String) -> Color {
        let lightHex = PNPalette.light[role] ?? 0x000000
        let darkHex = PNPalette.dark[role] ?? 0xFFFFFF
        let uiColor = UIColor(dynamicProvider: { traits in
            traits.userInterfaceStyle == .dark
                ? PNColors.makeUIColor(darkHex)
                : PNColors.makeUIColor(lightHex)
        })
        return Color(uiColor: uiColor)
    }

    private static func makeUIColor(_ hex: UInt32) -> UIColor {
        UIColor(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
