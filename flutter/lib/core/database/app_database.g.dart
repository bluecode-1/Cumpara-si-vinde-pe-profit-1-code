// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OnboardingProgressTable extends OnboardingProgress
    with TableInfo<$OnboardingProgressTable, OnboardingProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OnboardingStep?, String>
  pendingStep =
      GeneratedColumn<String>(
        'pending_step',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<OnboardingStep?>(
        $OnboardingProgressTable.$converterpendingStepn,
      );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pendingStep,
    displayName,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OnboardingProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingProgressRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pendingStep: $OnboardingProgressTable.$converterpendingStepn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pending_step'],
        ),
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OnboardingProgressTable createAlias(String alias) {
    return $OnboardingProgressTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OnboardingStep, String, String>
  $converterpendingStep = const EnumNameConverter<OnboardingStep>(
    OnboardingStep.values,
  );
  static JsonTypeConverter2<OnboardingStep?, String?, String?>
  $converterpendingStepn = JsonTypeConverter2.asNullable($converterpendingStep);
}

class OnboardingProgressRow extends DataClass
    implements Insertable<OnboardingProgressRow> {
  /// Always [singletonId]; the table holds at most one row.
  final int id;

  /// The step to resume at; `NULL` once onboarding has been completed.
  final OnboardingStep? pendingStep;
  final String displayName;
  final DateTime updatedAt;
  const OnboardingProgressRow({
    required this.id,
    this.pendingStep,
    required this.displayName,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || pendingStep != null) {
      map['pending_step'] = Variable<String>(
        $OnboardingProgressTable.$converterpendingStepn.toSql(pendingStep),
      );
    }
    map['display_name'] = Variable<String>(displayName);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OnboardingProgressCompanion toCompanion(bool nullToAbsent) {
    return OnboardingProgressCompanion(
      id: Value(id),
      pendingStep: pendingStep == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingStep),
      displayName: Value(displayName),
      updatedAt: Value(updatedAt),
    );
  }

  factory OnboardingProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingProgressRow(
      id: serializer.fromJson<int>(json['id']),
      pendingStep: $OnboardingProgressTable.$converterpendingStepn.fromJson(
        serializer.fromJson<String?>(json['pendingStep']),
      ),
      displayName: serializer.fromJson<String>(json['displayName']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pendingStep': serializer.toJson<String?>(
        $OnboardingProgressTable.$converterpendingStepn.toJson(pendingStep),
      ),
      'displayName': serializer.toJson<String>(displayName),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OnboardingProgressRow copyWith({
    int? id,
    Value<OnboardingStep?> pendingStep = const Value.absent(),
    String? displayName,
    DateTime? updatedAt,
  }) => OnboardingProgressRow(
    id: id ?? this.id,
    pendingStep: pendingStep.present ? pendingStep.value : this.pendingStep,
    displayName: displayName ?? this.displayName,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OnboardingProgressRow copyWithCompanion(OnboardingProgressCompanion data) {
    return OnboardingProgressRow(
      id: data.id.present ? data.id.value : this.id,
      pendingStep: data.pendingStep.present
          ? data.pendingStep.value
          : this.pendingStep,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingProgressRow(')
          ..write('id: $id, ')
          ..write('pendingStep: $pendingStep, ')
          ..write('displayName: $displayName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pendingStep, displayName, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingProgressRow &&
          other.id == this.id &&
          other.pendingStep == this.pendingStep &&
          other.displayName == this.displayName &&
          other.updatedAt == this.updatedAt);
}

class OnboardingProgressCompanion
    extends UpdateCompanion<OnboardingProgressRow> {
  final Value<int> id;
  final Value<OnboardingStep?> pendingStep;
  final Value<String> displayName;
  final Value<DateTime> updatedAt;
  const OnboardingProgressCompanion({
    this.id = const Value.absent(),
    this.pendingStep = const Value.absent(),
    this.displayName = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OnboardingProgressCompanion.insert({
    this.id = const Value.absent(),
    this.pendingStep = const Value.absent(),
    this.displayName = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<OnboardingProgressRow> custom({
    Expression<int>? id,
    Expression<String>? pendingStep,
    Expression<String>? displayName,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pendingStep != null) 'pending_step': pendingStep,
      if (displayName != null) 'display_name': displayName,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OnboardingProgressCompanion copyWith({
    Value<int>? id,
    Value<OnboardingStep?>? pendingStep,
    Value<String>? displayName,
    Value<DateTime>? updatedAt,
  }) {
    return OnboardingProgressCompanion(
      id: id ?? this.id,
      pendingStep: pendingStep ?? this.pendingStep,
      displayName: displayName ?? this.displayName,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pendingStep.present) {
      map['pending_step'] = Variable<String>(
        $OnboardingProgressTable.$converterpendingStepn.toSql(
          pendingStep.value,
        ),
      );
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingProgressCompanion(')
          ..write('id: $id, ')
          ..write('pendingStep: $pendingStep, ')
          ..write('displayName: $displayName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OnboardingProgressTable onboardingProgress =
      $OnboardingProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [onboardingProgress];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$OnboardingProgressTableCreateCompanionBuilder =
    OnboardingProgressCompanion Function({
      Value<int> id,
      Value<OnboardingStep?> pendingStep,
      Value<String> displayName,
      required DateTime updatedAt,
    });
typedef $$OnboardingProgressTableUpdateCompanionBuilder =
    OnboardingProgressCompanion Function({
      Value<int> id,
      Value<OnboardingStep?> pendingStep,
      Value<String> displayName,
      Value<DateTime> updatedAt,
    });

class $$OnboardingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingProgressTable> {
  $$OnboardingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OnboardingStep?, OnboardingStep, String>
  get pendingStep => $composableBuilder(
    column: $table.pendingStep,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingProgressTable> {
  $$OnboardingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingStep => $composableBuilder(
    column: $table.pendingStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingProgressTable> {
  $$OnboardingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OnboardingStep?, String> get pendingStep =>
      $composableBuilder(
        column: $table.pendingStep,
        builder: (column) => column,
      );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OnboardingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingProgressTable,
          OnboardingProgressRow,
          $$OnboardingProgressTableFilterComposer,
          $$OnboardingProgressTableOrderingComposer,
          $$OnboardingProgressTableAnnotationComposer,
          $$OnboardingProgressTableCreateCompanionBuilder,
          $$OnboardingProgressTableUpdateCompanionBuilder,
          (
            OnboardingProgressRow,
            BaseReferences<
              _$AppDatabase,
              $OnboardingProgressTable,
              OnboardingProgressRow
            >,
          ),
          OnboardingProgressRow,
          PrefetchHooks Function()
        > {
  $$OnboardingProgressTableTableManager(
    _$AppDatabase db,
    $OnboardingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OnboardingStep?> pendingStep = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OnboardingProgressCompanion(
                id: id,
                pendingStep: pendingStep,
                displayName: displayName,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OnboardingStep?> pendingStep = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                required DateTime updatedAt,
              }) => OnboardingProgressCompanion.insert(
                id: id,
                pendingStep: pendingStep,
                displayName: displayName,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OnboardingProgressTable, OnboardingProgressRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $OnboardingProgressTable,
                    OnboardingProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingProgressTable,
      OnboardingProgressRow,
      $$OnboardingProgressTableFilterComposer,
      $$OnboardingProgressTableOrderingComposer,
      $$OnboardingProgressTableAnnotationComposer,
      $$OnboardingProgressTableCreateCompanionBuilder,
      $$OnboardingProgressTableUpdateCompanionBuilder,
      (
        OnboardingProgressRow,
        BaseReferences<
          _$AppDatabase,
          $OnboardingProgressTable,
          OnboardingProgressRow
        >,
      ),
      OnboardingProgressRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OnboardingProgressTableTableManager get onboardingProgress =>
      $$OnboardingProgressTableTableManager(_db, _db.onboardingProgress);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'79fbc893ebdcc6adbd4c31ca4e8922a8f9832d4d';
