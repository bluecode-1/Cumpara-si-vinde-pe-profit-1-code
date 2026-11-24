import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/app_theme.dart';

Color _hex(Object? value) =>
    Color(int.parse('FF${(value! as String).substring(1)}', radix: 16));

void main() {
  final Map<String, dynamic> tokens = jsonDecode(
    File('../design/tokens.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final Map<String, dynamic> colors = tokens['color'] as Map<String, dynamic>;

  for (final (String name, ThemeData theme) in <(String, ThemeData)>[
    ('light', AppTheme.light()),
    ('dark', AppTheme.dark()),
  ]) {
    test('$name colour scheme comes from design/tokens.json', () {
      final Map<String, dynamic> palette = colors[name] as Map<String, dynamic>;
      final ColorScheme scheme = theme.colorScheme;
      expect(
        scheme.brightness,
        name == 'light' ? Brightness.light : Brightness.dark,
      );
      expect(scheme.primary, _hex(palette['primary']));
      expect(scheme.onPrimary, _hex(palette['onPrimary']));
      expect(scheme.primaryContainer, _hex(palette['primaryContainer']));
      expect(scheme.onPrimaryContainer, _hex(palette['onPrimaryContainer']));
      expect(scheme.secondary, _hex(palette['secondary']));
      expect(scheme.onSecondary, _hex(palette['onSecondary']));
      expect(scheme.secondaryContainer, _hex(palette['secondaryContainer']));
      expect(scheme.surface, _hex(palette['surface']));
      expect(scheme.onSurface, _hex(palette['onSurface']));
      expect(scheme.surfaceContainer, _hex(palette['surfaceContainer']));
      expect(scheme.onSurfaceVariant, _hex(palette['onSurfaceVariant']));
      expect(scheme.outline, _hex(palette['outline']));
      expect(scheme.outlineVariant, _hex(palette['outlineVariant']));
      expect(scheme.error, _hex(palette['error']));
      expect(scheme.onError, _hex(palette['onError']));
      expect(scheme.errorContainer, _hex(palette['errorContainer']));
      expect(theme.scaffoldBackgroundColor, _hex(palette['background']));
      expect(theme.useMaterial3, isTrue);
    });

    test('$name typography is Manrope with the token sizes', () {
      final TextTheme text = theme.textTheme;
      expect(text.bodyLarge!.fontFamily, 'Manrope');
      expect(text.displaySmall!.fontSize, 32);
      expect(text.displaySmall!.fontWeight, FontWeight.w700);
      expect(text.displaySmall!.height, 40 / 32);
      expect(text.titleMedium!.fontWeight, FontWeight.w600);
      expect(text.bodyLarge!.fontSize, 16);
      expect(text.bodyLarge!.fontWeight, FontWeight.w500);
      expect(text.bodyMedium!.height, 20 / 14);
      expect(text.labelMedium!.fontSize, 12);
    });

    test('$name buttons are at least 48 dp tall', () {
      for (final ButtonStyle? style in <ButtonStyle?>[
        theme.filledButtonTheme.style,
        theme.outlinedButtonTheme.style,
        theme.textButtonTheme.style,
      ]) {
        expect(
          style!.minimumSize!.resolve(<WidgetState>{})!.height,
          greaterThanOrEqualTo(48),
        );
      }
      expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
    });
  }
}
