import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/sync_shared_assets.dart';

/// The package keeps copies of artefacts owned by the monorepo. These tests
/// fail when a copy drifts; fix with `dart run tool/sync_shared_assets.dart`.
void main() {
  Map<String, List<int>> filesIn(String directory) => <String, List<int>>{
    for (final File file in Directory(directory).listSync().whereType<File>())
      file.uri.pathSegments.last: file.readAsBytesSync(),
  };

  void expectMirror(String source, String target) {
    final Map<String, List<int>> expected = filesIn(source);
    final Map<String, List<int>> actual = filesIn(target);
    expect(expected, isNotEmpty);
    expect(
      actual.keys.toSet(),
      expected.keys.toSet(),
      reason: '$target must contain exactly the files of $source',
    );
    for (final String name in expected.keys) {
      expect(
        actual[name],
        expected[name],
        reason: '$target/$name differs from $source/$name',
      );
    }
  }

  test('assets/fixtures is identical to api/fixtures', () {
    expectMirror(fixturesSource, fixturesTarget);
  });

  test('assets/fonts is identical to design/fonts', () {
    expectMirror(fontsSource, fontsTarget);
  });

  test('the generated theme tokens match design/tokens.json', () {
    expect(
      File(tokensTarget).readAsStringSync(),
      generateTokensDart(File(tokensSource).readAsStringSync()),
    );
  });

  test('pubspec declares the fixtures and every Manrope weight', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- assets/fixtures/'));
    for (final String font in filesIn(
      fontsSource,
    ).keys.where((String name) => name.endsWith('.ttf'))) {
      expect(pubspec, contains('assets/fonts/$font'));
    }
  });
}
