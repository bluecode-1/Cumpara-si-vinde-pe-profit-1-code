import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the layer boundaries from docs/04-structura-proiect.md, which
/// the built-in lints cannot express:
///
///  * `domain` is pure Dart: no Flutter, no I/O packages, no other layer;
///  * `presentation` never touches `data` (it gets implementations through
///    the feature's `di/` composition root);
///  * a feature never imports another feature;
///  * `core` imports neither features nor the app shell;
///  * features may use `app/adaptive/` but nothing else from `app/`.
void main() {
  final RegExp importPattern = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

  final Map<String, List<String>> importsByFile = <String, List<String>>{
    for (final File file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((File f) => f.path.endsWith('.dart')))
      file.path.replaceAll(r'\', '/'): importPattern
          .allMatches(file.readAsStringSync())
          .map((RegExpMatch match) => match.group(1)!)
          .toList(),
  };

  List<String> violations(
    bool Function(String file) appliesTo,
    bool Function(String file, String import) isForbidden,
  ) => <String>[
    for (final MapEntry<String, List<String>> entry in importsByFile.entries)
      if (appliesTo(entry.key))
        for (final String import in entry.value)
          if (isForbidden(entry.key, import)) '${entry.key} -> $import',
  ];

  String? featureOf(String path) =>
      RegExp(r'features/([^/]+)/').firstMatch(path)?.group(1);

  test('the scan sees the source tree', () {
    expect(importsByFile.keys, contains('lib/app/router.dart'));
    expect(
      importsByFile.keys.where((String f) => f.contains('/domain/')),
      isNotEmpty,
    );
  });

  test('domain is pure Dart and depends on no other layer', () {
    const List<String> forbidden = <String>[
      'package:flutter/',
      'package:material_ui/',
      'package:cupertino_ui/',
      'package:dio/',
      'package:drift/',
      'package:flutter_riverpod/',
      'package:riverpod_annotation/',
      'package:geolocator/',
      'package:flutter_secure_storage/',
      'package:profitnet/app/',
      'package:profitnet/l10n/',
      'dart:io',
      'dart:ui',
    ];
    expect(
      violations(
        (String file) => file.contains('/domain/'),
        (String _, String import) =>
            forbidden.any(import.startsWith) ||
            import.contains('/data/') ||
            import.contains('/presentation/') ||
            import.contains('/di/'),
      ),
      isEmpty,
    );
  });

  test('presentation does not import the data layer or I/O packages', () {
    expect(
      violations(
        (String file) => file.contains('/presentation/'),
        (String _, String import) =>
            import.contains('/data/') ||
            import.startsWith('package:dio/') ||
            import.startsWith('package:drift/'),
      ),
      isEmpty,
    );
  });

  test('data does not import presentation', () {
    expect(
      violations(
        (String file) => file.contains('/data/'),
        (String _, String import) => import.contains('/presentation/'),
      ),
      isEmpty,
    );
  });

  test('features do not import each other', () {
    expect(
      violations((String file) => featureOf(file) != null, (
        String file,
        String import,
      ) {
        final String? imported = featureOf(import);
        return imported != null && imported != featureOf(file);
      }),
      isEmpty,
    );
  });

  test('core depends on neither features nor the app shell', () {
    expect(
      violations(
        (String file) => file.startsWith('lib/core/'),
        (String _, String import) =>
            import.startsWith('package:profitnet/features/') ||
            import.startsWith('package:profitnet/app/'),
      ),
      isEmpty,
    );
  });

  test('features only use app/adaptive from the app shell, and '
      'app/adaptive depends on nothing above core', () {
    expect(
      violations(
        (String file) => file.startsWith('lib/features/'),
        (String _, String import) =>
            import.startsWith('package:profitnet/app/') &&
            !import.startsWith('package:profitnet/app/adaptive/'),
      ),
      isEmpty,
    );
    expect(
      violations(
        (String file) => file.startsWith('lib/app/adaptive/'),
        (String _, String import) =>
            import.startsWith('package:profitnet/features/') ||
            (import.startsWith('package:profitnet/app/') &&
                !import.startsWith('package:profitnet/app/adaptive/')),
      ),
      isEmpty,
    );
  });

  test('widgets use material_ui / cupertino_ui, not the deprecated '
      'package:flutter/material.dart and cupertino.dart', () {
    expect(
      violations(
        (String file) => !file.startsWith('lib/l10n/'),
        (String _, String import) =>
            import == 'package:flutter/material.dart' ||
            import == 'package:flutter/cupertino.dart',
      ),
      isEmpty,
    );
  });
}
