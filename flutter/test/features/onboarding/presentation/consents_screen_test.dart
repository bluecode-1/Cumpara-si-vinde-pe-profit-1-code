import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/consents_screen.dart';

import '../../../support/controller_harness.dart';
import '../../../support/test_app.dart';

void main() {
  late Harness harness;

  Future<void> pump(
    WidgetTester tester, {
    double textScale = 1,
    TargetPlatform platform = TargetPlatform.android,
    Brightness brightness = Brightness.light,
    Size surfaceSize = smallPhone,
  }) async {
    await harness.signInAt(OnboardingStep.consents);
    await pumpScreen(
      tester,
      const ConsentsScreen(),
      container: harness.container,
      textScale: textScale,
      platform: platform,
      brightness: brightness,
      surfaceSize: surfaceSize,
    );
  }

  Future<void> toggle(WidgetTester tester, String label) async {
    await tapText(tester, label);
    await tester.pumpAndSettle();
  }

  FilledButton continueButton(WidgetTester tester) =>
      tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(ro.actionContinue),
          matching: find.byType(FilledButton),
        ),
      );

  setUpAll(() => registerFallbackValue(const <ConsentDecision>[]));

  setUp(() {
    harness = Harness();
    when(() => harness.repository.saveConsents(any())).thenAnswer((_) async {});
  });

  testWidgets('shows the five consents, the hint and the optional header', (
    WidgetTester tester,
  ) async {
    await pump(tester, surfaceSize: const Size(400, 1200));

    for (final String text in <String>[
      'Înainte să continui',
      'Sunt de acord cu Termenii și condițiile',
      'Am citit Politica de confidențialitate',
      'Primele două sunt necesare pentru a folosi aplicația.',
      'Opțional',
      'Vreau să primesc noutăți și oferte',
      'Ajut la îmbunătățirea aplicației cu date de utilizare anonime',
      ro.consentAi,
      'Continuă',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
  });

  testWidgets('nothing is ticked by default and Continue is disabled', (
    WidgetTester tester,
  ) async {
    await pump(tester, surfaceSize: const Size(400, 1200));

    final Iterable<Checkbox> boxes = tester.widgetList<Checkbox>(
      find.byType(Checkbox),
    );
    expect(boxes, hasLength(5));
    expect(boxes.every((Checkbox box) => box.value == false), isTrue);
    expect(continueButton(tester).onPressed, isNull);
  });

  testWidgets('Continue is enabled only when both required consents are '
      'ticked', (WidgetTester tester) async {
    await pump(tester, surfaceSize: const Size(400, 1200));

    // All optional ones: still disabled.
    await toggle(tester, ro.consentMarketing);
    await toggle(tester, ro.consentAnalytics);
    await toggle(tester, ro.consentAi);
    expect(continueButton(tester).onPressed, isNull);

    await toggle(tester, ro.consentTerms);
    expect(continueButton(tester).onPressed, isNull);

    await toggle(tester, ro.consentPrivacy);
    expect(continueButton(tester).onPressed, isNotNull);

    // Unticking a required one disables it again.
    await toggle(tester, ro.consentTerms);
    expect(continueButton(tester).onPressed, isNull);

    // A disabled button does nothing.
    await tester.tap(find.text(ro.actionContinue));
    await tester.pumpAndSettle();
    verifyNever(() => harness.repository.saveConsents(any()));
  });

  testWidgets('Continue saves the decisions with the optional ones off and '
      'advances to Name', (WidgetTester tester) async {
    await pump(tester, surfaceSize: const Size(400, 1200));

    await toggle(tester, ro.consentTerms);
    await toggle(tester, ro.consentPrivacy);
    await tapText(tester, ro.actionContinue);
    // No pumpAndSettle: the button keeps its progress indicator until the
    // router replaces the screen, which this isolated test does not have.
    await tester.pump();

    verify(
      () => harness.repository.saveConsents(const <ConsentDecision>[
        ConsentDecision(purpose: ConsentPurpose.terms, granted: true),
        ConsentDecision(purpose: ConsentPurpose.privacy, granted: true),
        ConsentDecision(purpose: ConsentPurpose.marketing, granted: false),
        ConsentDecision(purpose: ConsentPurpose.analytics, granted: false),
        ConsentDecision(
          purpose: ConsentPurpose.aiPhotoProcessing,
          granted: false,
        ),
      ]),
    ).called(1);
    expect((harness.session as SignedIn).pendingStep, OnboardingStep.name);
  });

  testWidgets('a failure is shown in a live region and announced', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    when(() => harness.repository.saveConsents(any()))
        .thenThrow(const AppError.network());
    await pump(tester, surfaceSize: const Size(400, 1200));

    await toggle(tester, ro.consentTerms);
    await toggle(tester, ro.consentPrivacy);
    await tester.tap(find.text(ro.actionContinue));
    await tester.pumpAndSettle();

    expect(find.text(ro.errorNetwork), findsOneWidget);
    expect(
      tester.getSemantics(find.text(ro.errorNetwork)),
      isSemantics(isLiveRegion: true),
    );
    expect(
      tester.takeAnnouncements().map(
        (CapturedAccessibilityAnnouncement a) => a.message,
      ),
      contains(ro.errorNetwork),
    );
    expect(continueButton(tester).onPressed, isNotNull);
    handle.dispose();
  });

  testWidgets('on iOS the consents are Cupertino switches', (
    WidgetTester tester,
  ) async {
    await pump(
      tester,
      platform: TargetPlatform.iOS,
      surfaceSize: const Size(400, 1200),
    );

    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(CupertinoSwitch), findsNWidgets(5));

    await toggle(tester, ro.consentTerms);
    await toggle(tester, ro.consentPrivacy);
    expect(continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('each consent is one labelled, toggleable semantics node', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await pump(tester, surfaceSize: const Size(400, 1200));

    expect(
      tester.getSemantics(find.bySemanticsLabel(ro.consentTerms)),
      isSemantics(
        label: ro.consentTerms,
        hasCheckedState: true,
        isChecked: false,
        hasTapAction: true,
      ),
    );
    await toggle(tester, ro.consentTerms);
    expect(
      tester.getSemantics(find.bySemanticsLabel(ro.consentTerms)),
      isSemantics(hasCheckedState: true, isChecked: true),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  for (final TargetPlatform platform in <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
  ]) {
    testWidgets('text scale 2.0 on a small phone (${platform.name}): no '
        'overflow, every control reachable by scrolling', (
      WidgetTester tester,
    ) async {
      await pump(tester, textScale: 2, platform: platform);
      expect(tester.takeException(), isNull);

      await toggle(tester, ro.consentTerms);
      await toggle(tester, ro.consentPrivacy);
      await toggle(tester, ro.consentAi);
      expect(tester.takeException(), isNull);

      await scrollToText(tester, ro.actionContinue);
      expect(tester.takeException(), isNull);
      expect(continueButton(tester).onPressed, isNotNull);
      await tapText(tester, ro.actionContinue);
      await tester.pump();
      expect(tester.takeException(), isNull);
      verify(() => harness.repository.saveConsents(any())).called(1);
    });
  }

  testWidgets('dark theme meets the contrast guideline', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await pump(
      tester,
      brightness: Brightness.dark,
      surfaceSize: const Size(400, 1200),
    );
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
