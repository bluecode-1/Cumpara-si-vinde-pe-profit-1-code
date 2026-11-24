import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/features/home/presentation/home_screen.dart';
import 'package:profitnet/features/onboarding/presentation/code_screen.dart';
import 'package:profitnet/features/onboarding/presentation/consents_screen.dart';
import 'package:profitnet/features/onboarding/presentation/interests_screen.dart';
import 'package:profitnet/features/onboarding/presentation/location_screen.dart';
import 'package:profitnet/features/onboarding/presentation/name_screen.dart';
import 'package:profitnet/features/onboarding/presentation/phone_screen.dart';
import 'package:profitnet/features/onboarding/presentation/welcome_screen.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Drives the onboarding happy path through the real UI. Shared by the
/// widget-level flow test (`test/app/onboarding_flow_test.dart`) and the
/// on-device test (`integration_test/onboarding_flow_test.dart`); both run
/// the app against the fake API.
final class OnboardingFlowRobot {
  OnboardingFlowRobot(this.tester);

  final WidgetTester tester;

  /// The fake API only accepts this code.
  static const String validCode = '123456';
  static const String displayName = 'Ioana';
  static const String city = 'Cluj-Napoca';
  static const String interest = 'Electronice';

  /// Texts in whatever language the app is running in.
  AppLocalizations get l10n =>
      AppLocalizations.of(tester.element(find.byType(Scaffold).first));

  /// Pumps frames until a widget of type [T] is on screen.
  Future<void> waitFor<T extends Widget>() => waitForFinder(find.byType(T));

  Future<void> waitForFinder(
    Finder finder, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    const Duration step = Duration(milliseconds: 100);
    for (Duration waited = Duration.zero; waited < timeout; waited += step) {
      await tester.pump(step);
      if (finder.evaluate().isNotEmpty) {
        // Let the page transition finish.
        await tester.pumpAndSettle();
        return;
      }
    }
    fail('Timed out waiting for $finder');
  }

  Future<void> tap(String text) async {
    final Finder finder = find.text(text, skipOffstage: false);
    await Scrollable.ensureVisible(
      tester.element(finder.first),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pump();
  }

  /// Welcome -> Phone -> Code -> Consents -> Name -> Location (manual city
  /// after the permission is refused) -> Interests -> Home.
  Future<void> completeOnboarding() async {
    await waitFor<WelcomeScreen>();
    expect(find.text(l10n.welcomeTitle), findsOneWidget);
    await tap(l10n.welcomeCta);

    await waitFor<PhoneScreen>();
    await tester.enterText(find.byType(TextField), '0712 345 678');
    await tap(l10n.phoneCta);

    await waitFor<CodeScreen>();
    expect(find.text(l10n.codeSubtitle('+40712345678')), findsOneWidget);
    // The 6th digit submits automatically.
    await tester.enterText(find.byType(TextField), validCode);

    await waitFor<ConsentsScreen>();
    await tap(l10n.consentTerms);
    await tap(l10n.consentPrivacy);
    await tap(l10n.actionContinue);

    await waitFor<NameScreen>();
    await tester.enterText(find.byType(TextField), displayName);
    await tap(l10n.actionContinue);

    await waitFor<LocationScreen>();
    await tap(l10n.locationUseMine);
    await waitForFinder(find.text(l10n.locationDenied, skipOffstage: false));
    await tap(l10n.locationPickCity);
    await waitForFinder(find.text(city));
    await tester.tap(find.text(city));
    await tester.pump();

    await waitFor<InterestsScreen>();
    await waitForFinder(find.text(interest, skipOffstage: false));
    await tap(interest);
    await tap(l10n.actionFinish);

    await waitFor<HomeScreen>();
    expect(find.text(l10n.homeGreeting(displayName)), findsOneWidget);
    expect(find.text(l10n.homePlaceholder), findsOneWidget);
  }

  Future<void> logout() async {
    await tap(l10n.actionLogout);
    await waitFor<WelcomeScreen>();
  }
}
