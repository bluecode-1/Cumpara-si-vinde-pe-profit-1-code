import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/code_controller.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';

import '../../../support/controller_harness.dart';

const OtpChallenge _challenge = OtpChallenge(
  phone: '+40712345678',
  challengeId: 'challenge-1',
  retryAfterSeconds: 30,
);

const AppError _otpInvalid = AppError(code: 'OTP_INVALID', status: 422);
const AppError _rateLimited = AppError(code: 'RATE_LIMITED', status: 429);

VerifiedSession _verified({required bool onboardingCompleted}) =>
    VerifiedSession(
      tokens: testTokens,
      user: UserProfile(
        id: 'user-1',
        displayName: onboardingCompleted ? 'Ioana' : '',
        onboardingCompleted: onboardingCompleted,
      ),
    );

void main() {
  late Harness harness;

  CodeController controller() =>
      harness.container.read(codeControllerProvider.notifier);
  CodeState state() => harness.container.read(codeControllerProvider);

  void whenVerify(Future<VerifiedSession> Function() answer) => when(
    () => harness.repository.verifyOtp(
      challengeId: any(named: 'challengeId'),
      code: any(named: 'code'),
    ),
  ).thenAnswer((_) => answer());

  setUp(() {
    harness = Harness();
    harness.container
        .read(pendingOtpChallengeProvider.notifier)
        .set(_challenge);
    // Keep the auto-dispose controller alive for the duration of the test.
    harness.container.listen<CodeState>(
      codeControllerProvider,
      (CodeState? _, CodeState _) {},
    );
  });

  test('starts with the phone and the countdown from the challenge', () {
    expect(
      state(),
      const CodeState(phone: '+40712345678', secondsUntilResend: 30),
    );
    expect(state().canResend, isFalse);
  });

  test('success (new user): stores the tokens and continues with '
      'Consents', () async {
    whenVerify(() async => _verified(onboardingCompleted: false));

    await controller().submit('123456');

    verify(
      () => harness.repository.verifyOtp(
        challengeId: 'challenge-1',
        code: '123456',
      ),
    ).called(1);
    expect(await harness.tokenStore.read(), testTokens);
    expect(
      harness.session,
      const SessionState.signedIn(
        displayName: '',
        pendingStep: OnboardingStep.consents,
      ),
    );
    expect(harness.container.read(pendingOtpChallengeProvider), isNull);
    expect(state().error, isNull);
  });

  test('success (onboarding already completed): goes to Home', () async {
    whenVerify(() async => _verified(onboardingCompleted: true));

    await controller().submit('123456');

    expect(harness.session, const SessionState.signedIn(displayName: 'Ioana'));
  });

  test('OTP_INVALID: shows the error and asks the screen to clear the '
      'field', () async {
    whenVerify(() async => throw _otpInvalid);

    await controller().submit('000000');

    expect(state().error, _otpInvalid);
    expect(state().clearInputSignal, 1);
    expect(state().isSubmitting, isFalse);
    expect(harness.session, const SessionState.signedOut());
    expect(await harness.tokenStore.read(), isNull);
    // The challenge is still valid for another attempt.
    expect(harness.container.read(pendingOtpChallengeProvider), _challenge);

    await controller().submit('111111');
    expect(state().clearInputSignal, 2);
  });

  test('network error: shows the error, keeps the field', () async {
    whenVerify(() async => throw const AppError.network());

    await controller().submit('123456');

    expect(state().error, const AppError.network());
    expect(state().clearInputSignal, 0);
    expect(state().isSubmitting, isFalse);
    expect(harness.session, const SessionState.signedOut());
  });

  test('a new attempt clears the previous error and can succeed', () async {
    whenVerify(() async => throw const AppError.network());
    await controller().submit('123456');
    whenVerify(() async => _verified(onboardingCompleted: false));
    await controller().submit('123456');

    expect(state().error, isNull);
    expect(harness.session, isA<SignedIn>());
  });

  test('anything but exactly 6 digits is not sent', () async {
    for (final String code in <String>[
      '',
      '12345',
      '1234567',
      '12a456',
      '12 456',
    ]) {
      await controller().submit(code);
    }
    verifyNever(
      () => harness.repository.verifyOtp(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
      ),
    );
  });

  test('the countdown ticks down to zero and then enables resend', () {
    fakeAsync((FakeAsync async) {
      final Harness local = Harness();
      local.container
          .read(pendingOtpChallengeProvider.notifier)
          .set(_challenge);
      local.container.listen<CodeState>(
        codeControllerProvider,
        (CodeState? _, CodeState _) {},
      );
      CodeState current() => local.container.read(codeControllerProvider);

      expect(current().secondsUntilResend, 30);
      async.elapse(const Duration(seconds: 1));
      expect(current().secondsUntilResend, 29);
      async.elapse(const Duration(seconds: 28));
      expect(current().secondsUntilResend, 1);
      expect(current().canResend, isFalse);
      async.elapse(const Duration(seconds: 1));
      expect(current().secondsUntilResend, 0);
      expect(current().canResend, isTrue);
      async.elapse(const Duration(minutes: 1));
      expect(current().secondsUntilResend, 0);
      expect(async.periodicTimerCount, 0);
    });
  });

  test('resend is ignored while the countdown runs', () async {
    await controller().resend();
    verifyNever(() => harness.repository.requestOtp(any()));
  });

  test('resend requests a new code and restarts the countdown', () {
    fakeAsync((FakeAsync async) {
      final Harness local = Harness();
      const OtpChallenge renewed = OtpChallenge(
        phone: '+40712345678',
        challengeId: 'challenge-2',
        retryAfterSeconds: 45,
      );
      when(() => local.repository.requestOtp(any()))
          .thenAnswer((_) async => renewed);
      whenVerifyOn(local, () async => _verified(onboardingCompleted: false));
      local.container
          .read(pendingOtpChallengeProvider.notifier)
          .set(_challenge);
      local.container.listen<CodeState>(
        codeControllerProvider,
        (CodeState? _, CodeState _) {},
      );
      final CodeController notifier = local.container.read(
        codeControllerProvider.notifier,
      );
      CodeState current() => local.container.read(codeControllerProvider);

      async.elapse(const Duration(seconds: 30));
      unawaited(notifier.resend());
      async.flushMicrotasks();

      verify(() => local.repository.requestOtp('+40712345678')).called(1);
      expect(current().secondsUntilResend, 45);
      expect(current().isResending, isFalse);
      async.elapse(const Duration(seconds: 5));
      expect(current().secondsUntilResend, 40);

      // The new challenge is the one that gets verified.
      unawaited(notifier.submit('123456'));
      async.flushMicrotasks();
      verify(
        () => local.repository.verifyOtp(
          challengeId: 'challenge-2',
          code: '123456',
        ),
      ).called(1);
    });
  });

  test('RATE_LIMITED: shows the error and blocks resend for a full '
      'countdown', () {
    fakeAsync((FakeAsync async) {
      final Harness local = Harness();
      when(() => local.repository.requestOtp(any())).thenThrow(_rateLimited);
      local.container
          .read(pendingOtpChallengeProvider.notifier)
          .set(_challenge);
      local.container.listen<CodeState>(
        codeControllerProvider,
        (CodeState? _, CodeState _) {},
      );
      final CodeController notifier = local.container.read(
        codeControllerProvider.notifier,
      );
      CodeState current() => local.container.read(codeControllerProvider);

      async.elapse(const Duration(seconds: 30));
      expect(current().canResend, isTrue);
      unawaited(notifier.resend());
      async.flushMicrotasks();

      expect(current().error, _rateLimited);
      expect(current().secondsUntilResend, 30);
      expect(current().canResend, isFalse);
      expect(current().clearInputSignal, 0);

      // Still blocked: another tap does not reach the server.
      unawaited(notifier.resend());
      async.flushMicrotasks();
      verify(() => local.repository.requestOtp(any())).called(1);

      async.elapse(const Duration(seconds: 30));
      expect(current().canResend, isTrue);
    });
  });

  test('RATE_LIMITED while verifying keeps the running countdown', () async {
    whenVerify(() async => throw _rateLimited);

    await controller().submit('123456');

    expect(state().error, _rateLimited);
    expect(state().secondsUntilResend, 30);
    expect(state().canResend, isFalse);
  });

  test('without a pending challenge nothing is sent', () async {
    harness.container.read(pendingOtpChallengeProvider.notifier).clear();
    await controller().submit('123456');
    verifyNever(
      () => harness.repository.verifyOtp(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
      ),
    );
  });
}

void whenVerifyOn(Harness harness, Future<VerifiedSession> Function() answer) =>
    when(
      () => harness.repository.verifyOtp(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) => answer());
