import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_page.dart';
import 'package:profitnet/app/router.dart';
import 'package:profitnet/core/design/app_theme.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Root widget: router, Livadă light/dark themes and localisation
/// (Romanian is the base language, English the second).
class ProfitNetApp extends ConsumerWidget {
  const ProfitNetApp({super.key});

  static const Locale fallbackLocale = Locale('ro');

  /// Uses the device language when it is supported, Romanian otherwise.
  static Locale resolveLocale(
    List<Locale>? preferred,
    Iterable<Locale> supported,
  ) {
    for (final Locale locale in preferred ?? const <Locale>[]) {
      for (final Locale candidate in supported) {
        if (candidate.languageCode == locale.languageCode) {
          return candidate;
        }
      }
    }
    return fallbackLocale;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,
      theme: AppTheme.light(pageTransitions: adaptivePageTransitions),
      darkTheme: AppTheme.dark(pageTransitions: adaptivePageTransitions),
      // Material, Cupertino and widget strings come from material_ui;
      // AppLocalizations carries the app's own texts.
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveLocale,
    );
  }
}
