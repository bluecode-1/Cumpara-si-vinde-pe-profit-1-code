import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_page.dart';
import 'package:profitnet/core/design/app_theme.dart';
import 'package:profitnet/l10n/app_localizations.dart';
import 'package:profitnet/l10n/app_localizations_ro.dart';

/// The Romanian (base) texts, for assertions.
final AppLocalizations ro = AppLocalizationsRo();

/// A small phone (iPhone SE 1st gen size) to make layout problems show.
const Size smallPhone = Size(320, 568);

/// Pumps [child] inside the app's theme and localisation, with Riverpod
/// [overrides] (or an existing [container]), an optional text scale and
/// target platform.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const <Override>[],
  ProviderContainer? container,
  double textScale = 1,
  TargetPlatform platform = TargetPlatform.android,
  Brightness brightness = Brightness.light,
  Size surfaceSize = smallPhone,
}) async {
  tester.view
    ..physicalSize = surfaceSize
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeData base = brightness == Brightness.light
      ? AppTheme.light(pageTransitions: adaptivePageTransitions)
      : AppTheme.dark(pageTransitions: adaptivePageTransitions);
  final Widget app = MaterialApp(
    theme: base.copyWith(platform: platform),
    locale: const Locale('ro'),
    localizationsDelegates: const <LocalizationsDelegate<Object?>>[
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (BuildContext context, Widget? child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: child,
  );
  await tester.pumpWidget(
    container == null
        ? ProviderScope(overrides: overrides, child: app)
        : UncontrolledProviderScope(container: container, child: app),
  );
  await tester.pump();
}

/// Finds [text] even when it is scrolled out of the viewport.
Finder anywhere(String text) => find.text(text, skipOffstage: false);

/// Scrolls the widget showing [text] to the middle of its scroll view, so
/// that it can be tapped, and returns its finder.
Future<Finder> scrollToText(WidgetTester tester, String text) async {
  await Scrollable.ensureVisible(
    tester.element(anywhere(text)),
    alignment: 0.5,
  );
  await tester.pumpAndSettle();
  return find.text(text);
}

/// Scrolls to the widget showing [text] and taps it.
Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(await scrollToText(tester, text));
  await tester.pump();
}
