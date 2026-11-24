import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_controller.freezed.dart';
part 'code_controller.g.dart';

@freezed
abstract class CodeState with _$CodeState {
  const factory CodeState({
    /// E.164 number the code was sent to; empty if there is no challenge.
    @Default('') String phone,

    /// Remaining wait before the code can be re-sent; 0 enables "Resend".
    @Default(0) int secondsUntilResend,
    @Default(false) bool isSubmitting,
    @Default(false) bool isResending,
    AppError? error,

    /// Incremented every time the input field must be emptied
    /// (after `OTP_INVALID`).
    @Default(0) int clearInputSignal,
  }) = _CodeState;

  const CodeState._();

  bool get canResend =>
      secondsUntilResend == 0 && !isSubmitting && !isResending;
}

/// Step 3: verifies the 6-digit code and owns the resend countdown.
@riverpod
class CodeController extends _$CodeController {
  static final RegExp _sixDigits = RegExp(r'^\d{6}$');

  Timer? _countdown;

  @override
  CodeState build() {
    ref.onDispose(() => _countdown?.cancel());
    final OtpChallenge? challenge = ref.read(pendingOtpChallengeProvider);
    if (challenge == null) {
      return const CodeState();
    }
    _startCountdown();
    return CodeState(
      phone: challenge.phone,
      secondsUntilResend: challenge.retryAfterSeconds,
    );
  }

  /// Verifies [code]. Ignored unless it is exactly 6 digits.
  Future<void> submit(String code) async {
    final OtpChallenge? challenge = ref.read(pendingOtpChallengeProvider);
    if (state.isSubmitting || challenge == null || !_sixDigits.hasMatch(code)) {
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    final PendingOtpChallenge pending = ref.read(
      pendingOtpChallengeProvider.notifier,
    );
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final VerifiedSession verified = await repository.verifyOtp(
        challengeId: challenge.challengeId,
        code: code,
      );
      // Persists the tokens securely; the router reacts to the new session
      // (Home if onboarding was completed before, Consents otherwise).
      await session.signIn(
        tokens: verified.tokens,
        displayName: verified.user.displayName,
        onboardingCompleted: verified.user.onboardingCompleted,
      );
      pending.clear();
    } on AppError catch (error) {
      _fail(error, retryAfterSeconds: challenge.retryAfterSeconds);
    }
  }

  /// Requests a new code once the countdown has expired.
  Future<void> resend() async {
    final OtpChallenge? challenge = ref.read(pendingOtpChallengeProvider);
    if (!state.canResend || challenge == null) {
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final PendingOtpChallenge pending = ref.read(
      pendingOtpChallengeProvider.notifier,
    );
    state = state.copyWith(isResending: true, error: null);
    try {
      final OtpChallenge renewed = await repository.requestOtp(challenge.phone);
      pending.set(renewed);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isResending: false,
        secondsUntilResend: renewed.retryAfterSeconds,
      );
      _startCountdown();
    } on AppError catch (error) {
      _fail(error, retryAfterSeconds: challenge.retryAfterSeconds);
    }
  }

  void _fail(AppError error, {required int retryAfterSeconds}) {
    if (!ref.mounted) {
      return;
    }
    final bool rateLimited = error.code == AppErrorCode.rateLimited;
    state = state.copyWith(
      isSubmitting: false,
      isResending: false,
      error: error,
      clearInputSignal: error.code == AppErrorCode.otpInvalid
          ? state.clearInputSignal + 1
          : state.clearInputSignal,
      // Rate limiting keeps "Resend" blocked for a full countdown.
      secondsUntilResend: rateLimited && state.secondsUntilResend == 0
          ? retryAfterSeconds
          : state.secondsUntilResend,
    );
    if (rateLimited) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!ref.mounted || state.secondsUntilResend <= 1) {
        timer.cancel();
      }
      if (ref.mounted && state.secondsUntilResend > 0) {
        state = state.copyWith(
          secondsUntilResend: state.secondsUntilResend - 1,
        );
      }
    });
  }
}
