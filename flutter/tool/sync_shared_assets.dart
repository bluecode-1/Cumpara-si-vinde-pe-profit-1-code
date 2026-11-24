// Copies the artefacts shared by the three ProfitNet clients into this package:
//
//  * ../api/fixtures/*.json   -> assets/fixtures/   (served by the fake API)
//  * ../design/fonts/*        -> assets/fonts/
//  * ../design/tokens.json    -> lib/core/design/livada_tokens.dart (generated)
//
// Run from the package root: `dart run tool/sync_shared_assets.dart`.
// `test/tool/shared_assets_sync_test.dart` fails when the copies drift.
import 'dart:convert';
import 'dart:io';

const String fixturesSource = '../api/fixtures';
const String fixturesTarget = 'assets/fixtures';
const String fontsSource = '../design/fonts';
const String fontsTarget = 'assets/fonts';
const String tokensSource = '../design/tokens.json';
const String tokensTarget = 'lib/core/design/livada_tokens.dart';

void main() {
  final int fixtures = mirrorDirectory(fixturesSource, fixturesTarget);
  final int fonts = mirrorDirectory(fontsSource, fontsTarget);
  File(tokensTarget)
    ..createSync(recursive: true)
    ..writeAsStringSync(
      generateTokensDart(File(tokensSource).readAsStringSync()),
    );
  stdout.writeln(
    'Synced $fixtures fixtures, $fonts font files and $tokensTarget.',
  );
}

/// Makes [target] an exact copy of the files directly inside [source].
/// Returns the number of files copied.
int mirrorDirectory(String source, String target) {
  final Directory targetDir = Directory(target)..createSync(recursive: true);
  for (final File stale in targetDir.listSync().whereType<File>()) {
    stale.deleteSync();
  }
  final List<File> files = Directory(source)
      .listSync()
      .whereType<File>()
      .toList();
  for (final File file in files) {
    file.copySync('$target/${file.uri.pathSegments.last}');
  }
  return files.length;
}

/// Renders `design/tokens.json` as Dart constants.
String generateTokensDart(String tokensJson) {
  final Map<String, Object?> tokens =
      jsonDecode(tokensJson) as Map<String, Object?>;
  final Map<String, Object?> color = tokens['color']! as Map<String, Object?>;
  final Map<String, Object?> light = color['light']! as Map<String, Object?>;
  final Map<String, Object?> dark = color['dark']! as Map<String, Object?>;
  if (!_sameKeys(light, dark)) {
    throw const FormatException(
      'Light and dark palettes define different keys',
    );
  }
  final Map<String, Object?> typography =
      tokens['typography']! as Map<String, Object?>;
  final Map<String, Object?> weights =
      typography['weights']! as Map<String, Object?>;
  final Map<String, Object?> scale =
      typography['scaleSp']! as Map<String, Object?>;

  final StringBuffer out = StringBuffer()
    ..writeln('// GENERATED FILE - DO NOT EDIT.')
    ..writeln(
      '// Source: design/tokens.json ("${tokens['name']}" v${tokens['version']}).',
    )
    ..writeln('// Regenerate with: dart run tool/sync_shared_assets.dart')
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln('/// Colour roles of the Livada theme.')
    ..writeln('final class LivadaColors {')
    ..writeln('  const LivadaColors({');
  for (final String key in light.keys) {
    out.writeln('    required this.$key,');
  }
  out
    ..writeln('  });')
    ..writeln();
  for (final String key in light.keys) {
    out.writeln('  final Color $key;');
  }
  for (final MapEntry<String, Map<String, Object?>> palette
      in <String, Map<String, Object?>>{'light': light, 'dark': dark}.entries) {
    out
      ..writeln()
      ..writeln('  static const LivadaColors ${palette.key} = LivadaColors(');
    for (final MapEntry<String, Object?> entry in palette.value.entries) {
      out.writeln('    ${entry.key}: Color(${_argb(entry.value! as String)}),');
    }
    out.writeln('  );');
  }
  out
    ..writeln('}')
    ..writeln()
    ..writeln('/// One entry of the type scale (sizes in logical pixels).')
    ..writeln('final class LivadaTextToken {')
    ..writeln('  const LivadaTextToken({')
    ..writeln('    required this.size,')
    ..writeln('    required this.lineHeight,')
    ..writeln('    required this.weight,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  final double size;')
    ..writeln('  final double lineHeight;')
    ..writeln('  final int weight;')
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class LivadaTypography {')
    ..writeln(
      "  static const String fontFamily = '${typography['fontFamily']}';",
    );
  for (final MapEntry<String, Object?> entry in scale.entries) {
    final Map<String, Object?> style = entry.value! as Map<String, Object?>;
    out
      ..writeln()
      ..writeln(
        '  static const LivadaTextToken ${entry.key} = LivadaTextToken(',
      )
      ..writeln('    size: ${style['size']},')
      ..writeln('    lineHeight: ${style['lineHeight']},')
      ..writeln('    weight: ${weights[style['weight']]},')
      ..writeln('  );');
  }
  out.writeln('}');
  _writeDoubles(
    out,
    'LivadaRadius',
    tokens['radiusDp']! as Map<String, Object?>,
  );
  _writeDoubles(
    out,
    'LivadaSpacing',
    tokens['spacingDp']! as Map<String, Object?>,
  );
  _writeDoubles(out, 'LivadaSizes', <String, Object?>{
    'minTouchTarget': tokens['minTouchTargetDp'],
  });
  return out.toString();
}

void _writeDoubles(StringBuffer out, String name, Map<String, Object?> values) {
  out
    ..writeln()
    ..writeln('abstract final class $name {');
  for (final MapEntry<String, Object?> entry in values.entries) {
    out.writeln('  static const double ${entry.key} = ${entry.value};');
  }
  out.writeln('}');
}

bool _sameKeys(Map<String, Object?> a, Map<String, Object?> b) =>
    a.length == b.length && a.keys.every(b.containsKey);

String _argb(String hex) {
  if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(hex)) {
    throw FormatException('Unsupported colour value', hex);
  }
  return '0xFF${hex.substring(1).toUpperCase()}';
}
