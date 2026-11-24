import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/session/onboarding_step.dart';

part 'session_state.freezed.dart';

/// Who is using the app right now. Drives the router redirect.
@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.signedOut() = SignedOut;

  /// [pendingStep] is `null` once onboarding has been completed.
  const factory SessionState.signedIn({
    required String displayName,
    OnboardingStep? pendingStep,
  }) = SignedIn;
}
