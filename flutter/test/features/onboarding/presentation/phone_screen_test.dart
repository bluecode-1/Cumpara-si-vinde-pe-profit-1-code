import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/phone_screen.dart';

import '../../../support/controller_harness.dart';
import '../../../support/test_app.dart';

const OtpChallenge _challenge = OtpChallenge(
  phone: '+40712345678',
  challengeId: 'challenge-1',
  retryAfterSeconds: 30,
);

void main() {
  late Harness harness;
  late int codeSentCalls;

  Future<void> pump(
    WidgetTester tester, {
    double textScale = 1,
    TargetPlatform platform = TargetPlatform.android,
  }) => pumpScreen(
    tester,
    PhoneScreen(onCodeSent: () => codeSentCalls++),
    overrides: harness.overrides,
    textScale: textScale,
    platform: platform,
  );

  Future<void> submit(WidgetTester tester, String input) async {
    await tester.enterText(find.byType(TextField), input);
    await tapText(tester, ro.phoneCta);
    await tester.pumpAndSettle();
  }

  setUp(() {
    harness = Harness();
    codeSentCalls = 0;
  });

  testWidgets('shows the texts from the specification and the +40 prefix', (
    WidgetTester tester,
  ) async {
    await pump(tester);

    expect(find.text('Care este numărul tău de telefon?'), findsOneWidget);
    expect(
      find.text('Îți trimitem un cod prin SMS ca să-ți confirmăm numărul.'),
      findsOneWidget,
    );
    expect(find.text('Număr de telefon'), findsOneWidget);
    expect(find.text('+40 '), findsOneWidget);
    expect(find.text('Trimite codul'), findsOneWidget);
    expect(find.text(ro.phoneErrorInvalid), findsNothing);
  });

  testWidgets('an invalid number shows the validation message and does not '
      'call the server', (WidgetTester tester) async {
    await pump(tester);

    await submit(tester, '0212 345 678');

    expect(
      find.text('Introdu un număr de mobil valid, de exemplu 0712 345 678.'),
      findsOneWidget,
    );
    verifyNever(() => harness.repository.requestOtp(any()));
    expect(codeSentCalls, 0);
  });

  testWidgets('the validation message is announced to screen readers', (
    WidgetTester tester,
  ) async {
    await pump(tester);
    await submit(tester, '123');

    expect(
      tester.takeAnnouncements().map(
        (CapturedAccessibilityAnnouncement a) => a.message,
      ),
      contains(ro.phoneErrorInvalid),
    );
  });

  testWidgets('editing the number removes the validation message', (
    WidgetTester tester,
  ) async {
    await pump(tester);
    await submit(tester, '123');
    await tester.enterText(find.byType(TextField), '0712');
    await tester.pump();

    expect(find.text(ro.phoneErrorInvalid), findsNothing);
  });

  testWidgets('a valid number requests the code and moves on', (
    WidgetTester tester,
  ) async {
    when(() => harness.repository.requestOtp(any()))
        .thenAnswer((_) async => _challenge);
    await pump(tester);

    await submit(tester, '0712 345 678');

    verify(() => harness.repository.requestOtp('+40712345678')).called(1);
    expect(codeSentCalls, 1);
    expect(find.text(ro.phoneErrorInvalid), findsNothing);
  });

  testWidgets('the keyboard "done" action submits too', (
    WidgetTester tester,
  ) async {
    when(() => harness.repository.requestOtp(any()))
        .thenAnswer((_) async => _challenge);
    await pump(tester);

    await tester.enterText(find.byType(TextField), '712345678');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(codeSentCalls, 1);
  });

  testWidgets('a network failure shows the connection message, not the '
      'server text', (WidgetTester tester) async {
    when(() => harness.repository.requestOtp(any()))
        .thenThrow(const AppError.network());
    await pump(tester);

    await submit(tester, '0712345678');

    expect(
      find.text(
        'Nu există conexiune la internet. Verifică rețeaua și încearcă din nou.',
      ),
      findsOneWidget,
    );
    expect(codeSentCalls, 0);
  });

  testWidgets('RATE_LIMITED shows its own message', (
    WidgetTester tester,
  ) async {
    when(() => harness.repository.requestOtp(any()))
        .thenThrow(const AppError(code: 'RATE_LIMITED', status: 429));
    await pump(tester);

    await submit(tester, '0712345678');

    expect(find.text(ro.errorRateLimited), findsOneWidget);
  });

  testWidgets('only digits, spaces and + can be typed', (
    WidgetTester tester,
  ) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField), '07a1-2(3)x 4+');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '07123 4+',
    );
  });

  testWidgets('text scale 2.0 on a small phone: nothing overflows and the '
      'error and the button stay reachable', (WidgetTester tester) async {
    await pump(tester, textScale: 2);
    expect(tester.takeException(), isNull);

    await submit(tester, '123');
    expect(tester.takeException(), isNull);
    expect(anywhere(ro.phoneErrorInvalid), findsOneWidget);

    await scrollToText(tester, ro.phoneCta);
    expect(tester.takeException(), isNull);
    // The whole message is laid out (wrapped), not clipped to one line.
    final Size errorSize = tester.getSize(anywhere(ro.phoneErrorInvalid));
    expect(errorSize.height, greaterThan(40));
  });

  for (final TargetPlatform platform in <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
  ]) {
    testWidgets('accessibility guidelines on ${platform.name}: tap targets, '
        'labels, contrast', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pump(tester, platform: platform);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      expect(find.bySemanticsLabel(ro.phoneLabel), findsOneWidget);
      handle.dispose();
    });
  }
}
