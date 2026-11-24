// GENERATED FILE - DO NOT EDIT.
// Source: design/tokens.json ("Livada" v1).
// Regenerate with: dart run tool/sync_shared_assets.dart
import 'dart:ui';

/// Colour roles of the Livada theme.
final class LivadaColors {
  const LivadaColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainer;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  static const LivadaColors light = LivadaColors(
    primary: Color(0xFF4F5D23),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCE5B4),
    onPrimaryContainer: Color(0xFF1F2607),
    secondary: Color(0xFF9B3B2E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF6DDD6),
    onSecondaryContainer: Color(0xFF3D120B),
    background: Color(0xFFF4F1E8),
    onBackground: Color(0xFF20231A),
    surface: Color(0xFFF4F1E8),
    onSurface: Color(0xFF20231A),
    surfaceContainer: Color(0xFFE9E5D6),
    onSurfaceVariant: Color(0xFF5A5F4C),
    outline: Color(0xFF7B7F6A),
    outlineVariant: Color(0xFFD3CEBB),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
  );

  static const LivadaColors dark = LivadaColors(
    primary: Color(0xFFB9CC7A),
    onPrimary: Color(0xFF232B08),
    primaryContainer: Color(0xFF3A4517),
    onPrimaryContainer: Color(0xFFDCE5B4),
    secondary: Color(0xFFE79A8B),
    onSecondary: Color(0xFF4A160D),
    secondaryContainer: Color(0xFF6B261B),
    onSecondaryContainer: Color(0xFFF6DDD6),
    background: Color(0xFF15170F),
    onBackground: Color(0xFFECE9DD),
    surface: Color(0xFF15170F),
    onSurface: Color(0xFFECE9DD),
    surfaceContainer: Color(0xFF22251A),
    onSurfaceVariant: Color(0xFFAEB09C),
    outline: Color(0xFF8C8F7A),
    outlineVariant: Color(0xFF363A2B),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
  );
}

/// One entry of the type scale (sizes in logical pixels).
final class LivadaTextToken {
  const LivadaTextToken({
    required this.size,
    required this.lineHeight,
    required this.weight,
  });

  final double size;
  final double lineHeight;
  final int weight;
}

abstract final class LivadaTypography {
  static const String fontFamily = 'Manrope';

  static const LivadaTextToken displaySmall = LivadaTextToken(
    size: 32,
    lineHeight: 40,
    weight: 700,
  );

  static const LivadaTextToken headlineSmall = LivadaTextToken(
    size: 24,
    lineHeight: 32,
    weight: 700,
  );

  static const LivadaTextToken titleLarge = LivadaTextToken(
    size: 20,
    lineHeight: 28,
    weight: 700,
  );

  static const LivadaTextToken titleMedium = LivadaTextToken(
    size: 16,
    lineHeight: 24,
    weight: 600,
  );

  static const LivadaTextToken bodyLarge = LivadaTextToken(
    size: 16,
    lineHeight: 24,
    weight: 500,
  );

  static const LivadaTextToken bodyMedium = LivadaTextToken(
    size: 14,
    lineHeight: 20,
    weight: 500,
  );

  static const LivadaTextToken labelLarge = LivadaTextToken(
    size: 14,
    lineHeight: 20,
    weight: 700,
  );

  static const LivadaTextToken labelMedium = LivadaTextToken(
    size: 12,
    lineHeight: 16,
    weight: 600,
  );
}

abstract final class LivadaRadius {
  static const double small = 12;
  static const double medium = 20;
  static const double large = 28;
  static const double pill = 999;
}

abstract final class LivadaSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class LivadaSizes {
  static const double minTouchTarget = 48;
}
