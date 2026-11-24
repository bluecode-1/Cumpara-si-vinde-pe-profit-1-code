import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';
import 'package:profitnet/features/onboarding/presentation/phone_controller.dart';

import '../../../support/controller_harness.dart';

const OtpChallenge _challenge = OtpChallenge(
  phone: '+40712345678',
  challengeId: 'challenge-1',
  retryAfterSeconds: 30,
);

void main() {
  late Harness harness;
  late List<PhoneState> states;

  PhoneController controller() =>
      harness.container.read(phoneControllerProvider.notifier);

  setUp(() {
    harness = Harness();
    states = <PhoneState>[];
    harness.container.listen<PhoneState>(
      phoneControllerProvider,
      (PhoneState? _, PhoneState next) => states.add(next),
    );
  });

  test(
    'success: sends the normalised number and exposes the challenge',
    () async {
      when(() => harness.repository.requestOtp(any()))
          .thenAnswer((_) async => _challenge);

      await controller().submit('0712 345 678');

      verify(() => harness.repository.requestOtp('+40712345678')).called(1);
      expect(states, const <PhoneState>[
        PhoneState(isSubmitting: true),
        PhoneState(sentChallenge: _challenge),
      ]);
      expect(harness.container.read(pendingOtpChallengeProvider), _challenge);
    },
  );

  test('every accepted input form reaches the server as E.164', () async {
    when(() => harness.repository.requestOtp(any()))
        .thenAnswer((_) async => _challenge);

    for (final String input in <String>[
      '0712345678',
      '712345678',
      '+40712345678',
      '+40 712 345 678',
    ]) {
      await controller().submit(input);
    }
    verify(() => harness.repository.requestOtp('+40712345678')).called(4);
  });

  test('invalid number: validation error, no server call', () async {
    for (final String input in <String>['', '0212345678', '07123', 'abc']) {
      await controller().submit(input);
      expect(
        harness.container.read(phoneControllerProvider),
        const PhoneState(isInvalidNumber: true),
      );
    }
    verifyNever(() => harness.repository.requestOtp(any()));
    expect(harness.container.read(pendingOtpChallengeProvider), isNull);
  });

  test('network error is exposed and no challenge is stored', () async {
    when(() => harness.repository.requestOtp(any()))
        .thenThrow(const AppError.network());

    await controller().submit('0712345678');

    expect(states, const <PhoneState>[
      PhoneState(isSubmitting: true),
      PhoneState(error: AppError.network()),
    ]);
    expect(harness.container.read(pendingOtpChallengeProvider), isNull);
  });

  test('RATE_LIMITED is exposed', () async {
    const AppError rateLimited = AppError(code: 'RATE_LIMITED', status: 429);
    when(() => harness.repository.requestOtp(any())).thenThrow(rateLimited);

    await controller().submit('0712345678');

    expect(harness.container.read(phoneControllerProvider).error, rateLimited);
  });

  test('editing the number clears the error', () async {
    await controller().submit('123');
    controller().inputChanged();
    expect(harness.container.read(phoneControllerProvider), const PhoneState());
  });

  test('a second submit while one is in flight is ignored', () async {
    final Completer<OtpChallenge> pending = Completer<OtpChallenge>();
    when(() => harness.repository.requestOtp(any()))
        .thenAnswer((_) => pending.future);

    final Future<void> first = controller().submit('0712345678');
    await controller().submit('0712345678');
    pending.complete(_challenge);
    await first;

    verify(() => harness.repository.requestOtp(any())).called(1);
  });

  test('can be retried after a failure', () async {
    when(() => harness.repository.requestOtp(any()))
        .thenThrow(const AppError.network());
    await controller().submit('0712345678');
    when(() => harness.repository.requestOtp(any()))
        .thenAnswer((_) async => _challenge);
    await controller().submit('0712345678');

    expect(
      harness.container.read(phoneControllerProvider),
      const PhoneState(sentChallenge: _challenge),
    );
  });
}
