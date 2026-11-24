import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';

/// Builds the light and dark Material 3 themes of the "Livadă" identity
/// from the constants generated out of `design/tokens.json`.
abstract final class AppTheme {
  static ThemeData light({PageTransitionsTheme? pageTransitions}) =>
      _build(Brightness.light, LivadaColors.light, pageTransitions);

  static ThemeData dark({PageTransitionsTheme? pageTransitions}) =>
      _build(Brightness.dark, LivadaColors.dark, pageTransitions);

  static ColorScheme colorScheme(Brightness brightness, LivadaColors c) =>
      ColorScheme(
        brightness: brightness,
        primary: c.primary,
        onPrimary: c.onPrimary,
        primaryContainer: c.primaryContainer,
        onPrimaryContainer: c.onPrimaryContainer,
        secondary: c.secondary,
        onSecondary: c.onSecondary,
        secondaryContainer: c.secondaryContainer,
        onSecondaryContainer: c.onSecondaryContainer,
        // The palette has two accents; tertiary roles reuse the secondary.
        tertiary: c.secondary,
        onTertiary: c.onSecondary,
        tertiaryContainer: c.secondaryContainer,
        onTertiaryContainer: c.onSecondaryContainer,
        error: c.error,
        onError: c.onError,
        errorContainer: c.errorContainer,
        onErrorContainer: c.onErrorContainer,
        surface: c.surface,
        onSurface: c.onSurface,
        onSurfaceVariant: c.onSurfaceVariant,
        surfaceContainerLowest: c.surface,
        surfaceContainerLow: c.surface,
        surfaceContainer: c.surfaceContainer,
        surfaceContainerHigh: c.surfaceContainer,
        surfaceContainerHighest: c.surfaceContainer,
        outline: c.outline,
        outlineVariant: c.outlineVariant,
        // Keep surfaces flat: no primary-tinted elevation overlays.
        surfaceTint: Colors.transparent,
      );

  static TextStyle _style(LivadaTextToken token) => TextStyle(
    fontFamily: LivadaTypography.fontFamily,
    fontSize: token.size,
    height: token.lineHeight / token.size,
    fontWeight: FontWeight.values.firstWhere(
      (FontWeight weight) => weight.value == token.weight,
    ),
  );

  static TextTheme textTheme(ColorScheme scheme) => TextTheme(
    displaySmall: _style(LivadaTypography.displaySmall),
    headlineSmall: _style(LivadaTypography.headlineSmall),
    titleLarge: _style(LivadaTypography.titleLarge),
    titleMedium: _style(LivadaTypography.titleMedium),
    bodyLarge: _style(LivadaTypography.bodyLarge),
    bodyMedium: _style(LivadaTypography.bodyMedium),
    labelLarge: _style(LivadaTypography.labelLarge),
    labelMedium: _style(LivadaTypography.labelMedium),
  ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

  static ThemeData _build(
    Brightness brightness,
    LivadaColors colors,
    PageTransitionsTheme? pageTransitions,
  ) {
    final ColorScheme scheme = colorScheme(brightness, colors);
    final TextTheme text = textTheme(scheme);
    const Size minButtonSize = Size(64, LivadaSizes.minTouchTarget);
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(
      horizontal: LivadaSpacing.lg,
      vertical: LivadaSpacing.sm,
    );
    const StadiumBorder pill = StadiumBorder();
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(LivadaRadius.small),
      borderSide: BorderSide(color: scheme.outline),
    );

    return ThemeData(
      colorScheme: scheme,
      fontFamily: LivadaTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: colors.background,
      // Guarantees 48 dp touch targets for every Material control.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: pageTransitions,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: minButtonSize,
          padding: buttonPadding,
          shape: pill,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: minButtonSize,
          padding: buttonPadding,
          shape: pill,
          side: BorderSide(color: scheme.outline),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: minButtonSize,
          padding: buttonPadding,
          shape: pill,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        // Validation messages must wrap instead of being ellipsised when the
        // user enlarges the text.
        errorMaxLines: 5,
        helperMaxLines: 5,
      ),
      chipTheme: ChipThemeData(
        shape: pill,
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: text.labelLarge?.copyWith(color: scheme.onSurface),
        selectedColor: scheme.primaryContainer,
        checkmarkColor: scheme.onPrimaryContainer,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(LivadaRadius.large),
          ),
        ),
      ),
    );
  }
}
