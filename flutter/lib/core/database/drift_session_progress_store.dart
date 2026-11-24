import 'package:drift/drift.dart';
import 'package:profitnet/core/database/app_database.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drift_session_progress_store.g.dart';

/// [SessionProgressStore] on the `onboarding_progress` table.
final class DriftSessionProgressStore implements SessionProgressStore {
  DriftSessionProgressStore(this._database);

  final AppDatabase _database;

  @override
  Future<SessionProgress?> read() async {
    final OnboardingProgressRow? row = await _database
        .select(_database.onboardingProgress)
        .getSingleOrNull();
    return row == null
        ? null
        : SessionProgress(
            displayName: row.displayName,
            pendingStep: row.pendingStep,
          );
  }

  @override
  Future<void> write(SessionProgress progress) => _database
      .into(_database.onboardingProgress)
      .insertOnConflictUpdate(
        OnboardingProgressCompanion.insert(
          id: const Value<int>(OnboardingProgress.singletonId),
          pendingStep: Value<OnboardingStep?>(progress.pendingStep),
          displayName: Value<String>(progress.displayName),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

  @override
  Future<void> clear() => _database.delete(_database.onboardingProgress).go();
}

@Riverpod(keepAlive: true)
SessionProgressStore sessionProgressStore(Ref ref) =>
    DriftSessionProgressStore(ref.watch(appDatabaseProvider));
