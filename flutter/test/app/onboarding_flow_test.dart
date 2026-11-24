import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/app.dart';
import 'package:profitnet/core/database/drift_session_progress_store.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/network/api_config.dart';
import 'package:profitnet/core/network/dio_provider.dart';
import 'package:profitnet/core/network/fake_api_interceptor.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/home/presentation/home_screen.dart';
import 'package:profitnet/features/onboarding/presentation/code_screen.dart';
import 'package:profitnet/features/onboarding/presentation/consents_screen.dart';
import 'package:profitnet/features/onboarding/presentation/name_screen.dart';
import 'package:profitnet/features/onboarding/presentation/phone_screen.dart';
import 'package:profitnet/features/onboarding/presentation/welcome_screen.dart';

import '../support/fakes.dart';
import '../support/fixtures.dart';
import '../support/onboarding_flow_robot.dart';
import '../support/test_app.dart';

/// The whole app (router, themes, localisation, real repositories and Dio
/// pipeline) against the fake API. Only the device-bound pieces are
/// replaced: secure storage, SQLite file and the location plugin.
void main() {
  late FakeApiInterceptor fakeApi;
  late InMemoryTokenStore tokenStore;
  late InMemorySessionProgressStore progressStore;

  List<Override> overrides() => <Override>[
    apiConfigProvider.overrideWithValue(
      const ApiConfig(baseUrl: 'https://api.invalid/v1', useFakeApi: true),
    ),
    fakeApiProvider.overrideWithValue(fakeApi),
    tokenStoreProvider.overrideWithValue(tokenStore),
    sessionProgressStoreProvider.overrideWithValue(progressStore),
    locationServiceProvider.overrideWithValue(
      FakeLocationService(const LocationPermissionDenied()),
    ),
  ];

  /// Starts the app like `bootstrap()` does. A new call simulates a cold
  /// start on the same device storage.
  Future<ProviderContainer> launch(
    WidgetTester tester, {
    Locale locale = const Locale('ro', 'RO'),
    double textScale = 1,
  }) async {
    tester.view
      ..physicalSize = smallPhone
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher
      ..localesTestValue = <Locale>[locale]
      ..textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final ProviderContainer container = ProviderContainer(
      overrides: overrides(),
    );
    addTearDown(container.dispose);
    await tester.runAsync(
      () => container.read(sessionControllerProvider.notifier).restore(),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        // A fresh key forces a brand new widget tree for every launch.
        key: UniqueKey(),
        container: container,
        child: const ProfitNetApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  setUp(() {
    fakeApi = FakeApiInterceptor(loadFixture: loadSharedFixture);
    tokenStore = InMemoryTokenStore();
    progressStore = InMemorySessionProgressStore();
  });

  testWidgets('happy path: Welcome to Home, then logout', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await launch(tester);
    final OnboardingFlowRobot robot = OnboardingFlowRobot(tester);

    await robot.completeOnboarding();

    expect(find.text('Bună, Ioana'), findsOneWidget);
    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedIn(displayName: 'Ioana'),
    );
    expect(await tokenStore.read(), isNotNull);

    // What the (fake) server received.
    final Map<String, bool> consents = <String, bool>{
      for (final Map<String, dynamic> consent in fakeApi.consents)
        consent['purpose'] as String: consent['granted'] as bool,
    };
    expect(consents, <String, bool>{
      'TERMS': true,
      'PRIVACY': true,
      'MARKETING': false,
      'ANALYTICS': false,
      'AI_PHOTO_PROCESSING': false,
      // No LOCATION consent: the permission was refused, a city was chosen.
    });
    expect(
      fakeApi.consents.every(
        (Map<String, dynamic> c) => c['policyVersion'] == '2026-11',
      ),
      isTrue,
    );
    expect(fakeApi.interestCategoryIds, <String>[
      '0193f6a0-3c00-7000-8000-000000000002',
    ]);

    await robot.logout();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedOut(),
    );
    expect(await tokenStore.read(), isNull);
    expect(await progressStore.read(), isNull);
  });

  testWidgets('happy path at text scale 2.0 on a small phone has no '
      'overflow', (WidgetTester tester) async {
    await launch(tester, textScale: 2);
    await OnboardingFlowRobot(tester).completeOnboarding();
    expect(tester.takeException(), isNull);
  });

  testWidgets('runs in English when the device language is English', (
    WidgetTester tester,
  ) async {
    await launch(tester, locale: const Locale('en', 'US'));
    expect(find.text('Good things deserve a second home'), findsOneWidget);
    await OnboardingFlowRobot(tester).completeOnboarding();
    expect(find.text('Hi, Ioana'), findsOneWidget);
  });

  testWidgets('falls back to Romanian for unsupported device languages', (
    WidgetTester tester,
  ) async {
    await launch(tester, locale: const Locale('de', 'DE'));
    expect(find.text('Lucrurile bune merită o a doua casă'), findsOneWidget);
  });

  testWidgets('a wrong code shows OTP_INVALID and empties the field', (
    WidgetTester tester,
  ) async {
    await launch(tester);
    final OnboardingFlowRobot robot = OnboardingFlowRobot(tester);
    await robot.tap(ro.welcomeCta);
    await robot.waitFor<PhoneScreen>();
    await tester.enterText(find.byType(TextField), '712345678');
    await robot.tap(ro.phoneCta);
    await robot.waitFor<CodeScreen>();
    expect(find.text('Poți retrimite codul în 30 s'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '000000');
    await tester.pumpAndSettle();

    expect(find.byType(CodeScreen), findsOneWidget);
    expect(find.text('Codul nu este corect sau a expirat.'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );

    // The countdown runs and then offers "Resend".
    await tester.pump(const Duration(seconds: 31));
    expect(find.text('Retrimite codul'), findsOneWidget);

    // The right code still works afterwards.
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();
    expect(find.byType(ConsentsScreen), findsOneWidget);
  });

  testWidgets('back navigation walks Code -> Phone -> Welcome', (
    WidgetTester tester,
  ) async {
    await launch(tester);
    final OnboardingFlowRobot robot = OnboardingFlowRobot(tester);
    await robot.tap(ro.welcomeCta);
    await robot.waitFor<PhoneScreen>();
    await tester.enterText(find.byType(TextField), '712345678');
    await robot.tap(ro.phoneCta);
    await robot.waitFor<CodeScreen>();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(CodeScreen), findsNothing);
    expect(find.byType(PhoneScreen), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('the flow resumes at the saved step after the app is killed', (
    WidgetTester tester,
  ) async {
    await launch(tester);
    final OnboardingFlowRobot robot = OnboardingFlowRobot(tester);
    await robot.tap(ro.welcomeCta);
    await robot.waitFor<PhoneScreen>();
    await tester.enterText(find.byType(TextField), '0712345678');
    await robot.tap(ro.phoneCta);
    await robot.waitFor<CodeScreen>();
    await tester.enterText(find.byType(TextField), '123456');
    await robot.waitFor<ConsentsScreen>();
    await robot.tap(ro.consentTerms);
    await robot.tap(ro.consentPrivacy);
    await robot.tap(ro.actionContinue);
    await robot.waitFor<NameScreen>();

    // Cold start on the same storage.
    final ProviderContainer relaunched = await launch(tester);

    expect(find.byType(NameScreen), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsNothing);
    expect(
      relaunched.read(sessionControllerProvider),
      const SessionState.signedIn(
        displayName: '',
        pendingStep: OnboardingStep.name,
      ),
    );
  });

  testWidgets('a completed onboarding opens directly on Home', (
    WidgetTester tester,
  ) async {
    await launch(tester);
    await OnboardingFlowRobot(tester).completeOnboarding();

    await launch(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Bună, Ioana'), findsOneWidget);
  });

  testWidgets('an expired session sends the user back to Welcome', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await launch(tester);
    await OnboardingFlowRobot(tester).completeOnboarding();

    // What the auth interceptor does when the refresh token is rejected.
    await container.read(sessionControllerProvider.notifier).signOut();
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });
}
