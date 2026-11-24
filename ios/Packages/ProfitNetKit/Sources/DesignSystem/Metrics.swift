import CoreGraphics

/// Spacing scale from `design/tokens.json` (`spacingDp`), in points.
public enum PNSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
}

/// Corner radii from `design/tokens.json` (`radiusDp`), in points.
public enum PNRadius {
    public static let small: CGFloat = 12
    public static let medium: CGFloat = 20
    public static let large: CGFloat = 28
}

public enum PNMetrics {
    /// Minimum touch target on iOS (the token's 48 dp is the Android value).
    public static let minTouchTarget: CGFloat = 44
}
