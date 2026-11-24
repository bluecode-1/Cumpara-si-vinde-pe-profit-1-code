import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

/// Single-row table with the local onboarding progress of the signed-in
/// user. No row means "nobody is signed in on this device".
@DataClassName('OnboardingProgressRow')
class OnboardingProgress extends Table {
  /// Always [singletonId]; the table holds at most one row.
  IntColumn get id => integer()();

  /// The step to resume at; `NULL` once onboarding has been completed.
  TextColumn get pendingStep => textEnum<OnboardingStep>().nullable()();

  TextColumn get displayName => text().withDefault(const Constant(''))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  static const int singletonId = 1;
}

/// The local SQLite database.
@DriftDatabase(tables: <Type>[OnboardingProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'profitnet'));

  // Bump on every schema change and add a step to [migration].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (Migrator migrator) => migrator.createAll());
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}
