import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/model/geo_point.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/features/home/presentation/home_screen.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/code_screen.dart';
import 'package:profitnet/features/onboarding/presentation/consents_screen.dart';
import 'package:profitnet/features/onboarding/presentation/interests_screen.dart';
import 'package:profitnet/features/onboarding/presentation/location_screen.dart';
import 'package:profitnet/features/onboarding/presentation/name_screen.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';
import 'package:profitnet/features/onboarding/presentation/phone_screen.dart';
import 'package:profitnet/features/onboarding/presentation/welcome_screen.dart';

import '../../../support/controller_harness.dart';
import '../../../support/test_app.dart';

const List<InterestCategory> _categories = <InterestCategory>[
  InterestCategory(id: 'c1', name: 'Haine și încălțăminte'),
  InterestCategory(id: 'c2', name: 'Electronice'),
  InterestCategory(id: 'c3', name: 'Sport și timp liber'),
  InterestCategory(id: 'c4', name: 'Casă și grădină'),
];

/// Every screen, in both themes and on both platforms, must lay out without
/// overflow at 200 % text size on a small phone and meet the tap-target,
/// label and contrast guidelines.
void main() {
  late Harness harness;

  setUpAll(() {
    registerFallbackValue(const <String>{});
    registerFallbackValue(const GeoPoint(lat: 0, lng: 0));
  });

  setUp(() async {
    harness = Harness();
    when(() => harness.repository.topLevelCategories())
        .thenAnswer((_) async => _categories);
    await harness.signInAt(OnboardingStep.interests, displayName: 'Ioana');
    harness.container
        .read(pendingOtpChallengeProvider.notifier)
        .set(
          const OtpChallenge(
            phone: '+40712345678',
            challengeId: 'c',
            retryAfterSeconds: 30,
          ),
        );
  });

  final Map<String, Widget> screens = <String, Widget>{
    'Welcome': WelcomeScreen(onStart: () {}),
    'Phone': PhoneScreen(onCodeSent: () {}),
    'Code': const CodeScreen(),
    'Consents': const ConsentsScreen(),
    'Name': const NameScreen(),
    'Location': const LocationScreen(),
    'Interests': const InterestsScreen(),
    'Home': const HomeScreen(),
  };

  for (final MapEntry<String, Widget> screen in screens.entries) {
    for (final TargetPlatform platform in <TargetPlatform>[
      TargetPlatform.android,
      TargetPlatform.iOS,
    ]) {
      testWidgets('${screen.key} on ${platform.name}: text scale 2.0 on a '
          'small phone does not overflow', (WidgetTester tester) async {
        await pumpScreen(
          tester,
          screen.value,
          container: harness.container,
          textScale: 2,
          platform: platform,
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);

        // Scroll through the whole page: nothing may overflow further down.
        await tester.drag(
          find.byType(Scrollable).first,
          const Offset(0, -3000),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);
        await unmountScreen(tester, harness.container);
      });

      for (final Brightness brightness in Brightness.values) {
        testWidgets('${screen.key} on ${platform.name} (${brightness.name}): '
            'tap targets, labels and contrast', (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await pumpScreen(
            tester,
            screen.value,
            container: harness.container,
            platform: platform,
            brightness: brightness,
            surfaceSize: const Size(400, 1400),
          );
          await tester.pump(const Duration(milliseconds: 500));

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
          await unmountScreen(tester, harness.container);
        });
      }
    }
  }

  testWidgets('Location: a refused permission shows the hint in a live '
      'region and the city list is offered', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await pumpScreen(
      tester,
      const LocationScreen(),
      container: harness.container,
      textScale: 2,
    );

    await tapText(tester, ro.locationUseMine);
    await tester.pumpAndSettle();

    expect(harness.locationService.calls, 1);
    expect(
      tester.getSemantics(anywhere(ro.locationDenied)),
      isSemantics(isLiveRegion: true),
    );
    expect(
      tester.takeAnnouncements().map(
        (CapturedAccessibilityAnnouncement a) => a.message,
      ),
      contains('Nu avem acces la locație. Poți alege orașul din listă.'),
    );

    await tapText(tester, ro.locationPickCity);
    await tester.pumpAndSettle();
    expect(find.text('București'), findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });

  testWidgets('Location on iOS: the city list is a Cupertino action sheet '
      'with a cancel action', (WidgetTester tester) async {
    harness.locationService.result = const LocationUnavailable();
    await pumpScreen(
      tester,
      const LocationScreen(),
      container: harness.container,
      platform: TargetPlatform.iOS,
      surfaceSize: const Size(400, 900),
    );

    await tapText(tester, ro.locationPickCity);
    await tester.pumpAndSettle();

    expect(find.text('Sibiu', skipOffstage: false), findsOneWidget);
    final String cancel = MaterialLocalizations.of(
      tester.element(find.byType(LocationScreen)),
    ).cancelButtonLabel;
    await tester.tap(find.text(cancel));
    await tester.pumpAndSettle();
    expect(find.text('București'), findsNothing);
    verifyNever(() => harness.repository.updateHomeLocation(any()));
  });

  testWidgets('Interests: a load failure offers "retry" and "skip" still '
      'works', (WidgetTester tester) async {
    when(() => harness.repository.topLevelCategories())
        .thenThrow(const AppError.network());
    when(() => harness.repository.completeOnboarding(any())).thenAnswer(
      (_) async => const UserProfile(
        id: 'u',
        displayName: 'Ioana',
        onboardingCompleted: true,
      ),
    );
    await pumpScreen(
      tester,
      const InterestsScreen(),
      container: harness.container,
    );
    await tester.pumpAndSettle();

    expect(find.text(ro.errorNetwork), findsOneWidget);
    expect(find.text('Reîncearcă'), findsOneWidget);

    when(() => harness.repository.topLevelCategories())
        .thenAnswer((_) async => _categories);
    await tapText(tester, ro.actionRetry);
    await tester.pumpAndSettle();
    expect(find.text('Electronice'), findsOneWidget);
    expect(find.text(ro.errorNetwork), findsNothing);

    await tapText(tester, 'Electronice');
    await tapText(tester, ro.interestsSkip);
    await tester.pump();
    verify(() => harness.repository.completeOnboarding(<String>{})).called(1);
  });
}
