import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/session/onboarding_step.dart';

part 'session_progress_store.freezed.dart';

/// What is remembered locally about the signed-in user between launches.
@freezed
abstract class SessionProgress with _$SessionProgress {
  const factory SessionProgress({
    required String displayName,

    /// `null` once onboarding has been completed.
    OnboardingStep? pendingStep,
  }) = _SessionProgress;
}

/// Local persistence of [SessionProgress]; implemented on Drift.
abstract interface class SessionProgressStore {
  Future<SessionProgress?> read();

  Future<void> write(SessionProgress progress);

  Future<void> clear();
}

/// Volatile implementation for tests.
final class InMemorySessionProgressStore implements SessionProgressStore {
  InMemorySessionProgressStore([this._progress]);

  SessionProgress? _progress;

  @override
  Future<SessionProgress?> read() async => _progress;

  @override
  Future<void> write(SessionProgress progress) async => _progress = progress;

  @override
  Future<void> clear() async => _progress = null;
}
