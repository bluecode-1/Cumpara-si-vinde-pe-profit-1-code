import 'package:profitnet/core/database/drift_session_progress_store.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_controller.g.dart';

/// Owns the session: tokens in the secure store plus the locally persisted
/// onboarding progress. Every change is written through before the state is
/// published, so a process death never loses a completed step.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  SessionState build() => const SessionState.signedOut();

  TokenStore get _tokens => ref.read(tokenStoreProvider);

  SessionProgressStore get _progress => ref.read(sessionProgressStoreProvider);

  /// Loads the persisted session. Called once before the first frame.
  Future<void> restore() async {
    try {
      final AuthTokens? tokens = await _tokens.read();
      final SessionProgress? progress = await _progress.read();
      if (tokens != null && progress != null) {
        state = SessionState.signedIn(
          displayName: progress.displayName,
          pendingStep: progress.pendingStep,
        );
        return;
      }
    } on Exception {
      // Unreadable secure storage or database: start from a clean slate.
    }
    // Covers half-states too, e.g. Keychain items that survived a reinstall.
    await signOut();
  }

  /// Starts a session right after the phone number has been verified.
  Future<void> signIn({
    required AuthTokens tokens,
    required String displayName,
    required bool onboardingCompleted,
  }) async {
    await _tokens.write(tokens);
    await _publish(
      SessionProgress(
        displayName: displayName,
        pendingStep: onboardingCompleted ? null : OnboardingStep.values.first,
      ),
    );
  }

  /// Records that the flow moved on to [step].
  Future<void> advanceTo(OnboardingStep step, {String? displayName}) =>
      _update(pendingStep: step, displayName: displayName);

  Future<void> completeOnboarding() => _update(pendingStep: null);

  /// Clears the local session. Also invoked when the refresh token is
  /// rejected; the router then redirects to Welcome.
  Future<void> signOut() async {
    try {
      await _tokens.clear();
      await _progress.clear();
    } finally {
      state = const SessionState.signedOut();
    }
  }

  Future<void> _update({
    required OnboardingStep? pendingStep,
    String? displayName,
  }) async {
    final SessionState current = state;
    if (current is! SignedIn) {
      return;
    }
    await _publish(
      SessionProgress(
        displayName: displayName ?? current.displayName,
        pendingStep: pendingStep,
      ),
    );
  }

  Future<void> _publish(SessionProgress progress) async {
    await _progress.write(progress);
    state = SessionState.signedIn(
      displayName: progress.displayName,
      pendingStep: progress.pendingStep,
    );
  }
}
