// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    title,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String title;
  final String? description;
  const Routine({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.title,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
    };
  }

  Routine copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
  }) => Routine(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    title,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Routine> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineExercisesTable extends RoutineExercises
    with TableInfo<$RoutineExercisesTable, RoutineExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<String> targetReps = GeneratedColumn<String>(
    'target_reps',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _techniqueNoteMeta = const VerificationMeta(
    'techniqueNote',
  );
  @override
  late final GeneratedColumn<String> techniqueNote = GeneratedColumn<String>(
    'technique_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timerTargetMeta = const VerificationMeta(
    'timerTarget',
  );
  @override
  late final GeneratedColumn<String> timerTarget = GeneratedColumn<String>(
    'timer_target',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    routineId,
    title,
    targetSets,
    targetReps,
    techniqueNote,
    timerTarget,
    orderIndex,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    if (data.containsKey('technique_note')) {
      context.handle(
        _techniqueNoteMeta,
        techniqueNote.isAcceptableOrUnknown(
          data['technique_note']!,
          _techniqueNoteMeta,
        ),
      );
    }
    if (data.containsKey('timer_target')) {
      context.handle(
        _timerTargetMeta,
        timerTarget.isAcceptableOrUnknown(
          data['timer_target']!,
          _timerTargetMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineExercise(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      ),
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_reps'],
      ),
      techniqueNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique_note'],
      ),
      timerTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timer_target'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $RoutineExercisesTable createAlias(String alias) {
    return $RoutineExercisesTable(attachedDatabase, alias);
  }
}

class RoutineExercise extends DataClass implements Insertable<RoutineExercise> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String routineId;
  final String title;
  final int? targetSets;
  final String? targetReps;
  final String? techniqueNote;
  final String? timerTarget;
  final int orderIndex;
  final String type;
  const RoutineExercise({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.routineId,
    required this.title,
    this.targetSets,
    this.targetReps,
    this.techniqueNote,
    this.timerTarget,
    required this.orderIndex,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || targetSets != null) {
      map['target_sets'] = Variable<int>(targetSets);
    }
    if (!nullToAbsent || targetReps != null) {
      map['target_reps'] = Variable<String>(targetReps);
    }
    if (!nullToAbsent || techniqueNote != null) {
      map['technique_note'] = Variable<String>(techniqueNote);
    }
    if (!nullToAbsent || timerTarget != null) {
      map['timer_target'] = Variable<String>(timerTarget);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['type'] = Variable<String>(type);
    return map;
  }

  RoutineExercisesCompanion toCompanion(bool nullToAbsent) {
    return RoutineExercisesCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      routineId: Value(routineId),
      title: Value(title),
      targetSets: targetSets == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSets),
      targetReps: targetReps == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReps),
      techniqueNote: techniqueNote == null && nullToAbsent
          ? const Value.absent()
          : Value(techniqueNote),
      timerTarget: timerTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(timerTarget),
      orderIndex: Value(orderIndex),
      type: Value(type),
    );
  }

  factory RoutineExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineExercise(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      title: serializer.fromJson<String>(json['title']),
      targetSets: serializer.fromJson<int?>(json['targetSets']),
      targetReps: serializer.fromJson<String?>(json['targetReps']),
      techniqueNote: serializer.fromJson<String?>(json['techniqueNote']),
      timerTarget: serializer.fromJson<String?>(json['timerTarget']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'title': serializer.toJson<String>(title),
      'targetSets': serializer.toJson<int?>(targetSets),
      'targetReps': serializer.toJson<String?>(targetReps),
      'techniqueNote': serializer.toJson<String?>(techniqueNote),
      'timerTarget': serializer.toJson<String?>(timerTarget),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'type': serializer.toJson<String>(type),
    };
  }

  RoutineExercise copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? routineId,
    String? title,
    Value<int?> targetSets = const Value.absent(),
    Value<String?> targetReps = const Value.absent(),
    Value<String?> techniqueNote = const Value.absent(),
    Value<String?> timerTarget = const Value.absent(),
    int? orderIndex,
    String? type,
  }) => RoutineExercise(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    title: title ?? this.title,
    targetSets: targetSets.present ? targetSets.value : this.targetSets,
    targetReps: targetReps.present ? targetReps.value : this.targetReps,
    techniqueNote: techniqueNote.present
        ? techniqueNote.value
        : this.techniqueNote,
    timerTarget: timerTarget.present ? timerTarget.value : this.timerTarget,
    orderIndex: orderIndex ?? this.orderIndex,
    type: type ?? this.type,
  );
  RoutineExercise copyWithCompanion(RoutineExercisesCompanion data) {
    return RoutineExercise(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      title: data.title.present ? data.title.value : this.title,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      techniqueNote: data.techniqueNote.present
          ? data.techniqueNote.value
          : this.techniqueNote,
      timerTarget: data.timerTarget.present
          ? data.timerTarget.value
          : this.timerTarget,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercise(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('techniqueNote: $techniqueNote, ')
          ..write('timerTarget: $timerTarget, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    routineId,
    title,
    targetSets,
    targetReps,
    techniqueNote,
    timerTarget,
    orderIndex,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineExercise &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.title == this.title &&
          other.targetSets == this.targetSets &&
          other.targetReps == this.targetReps &&
          other.techniqueNote == this.techniqueNote &&
          other.timerTarget == this.timerTarget &&
          other.orderIndex == this.orderIndex &&
          other.type == this.type);
}

class RoutineExercisesCompanion extends UpdateCompanion<RoutineExercise> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> routineId;
  final Value<String> title;
  final Value<int?> targetSets;
  final Value<String?> targetReps;
  final Value<String?> techniqueNote;
  final Value<String?> timerTarget;
  final Value<int> orderIndex;
  final Value<String> type;
  final Value<int> rowid;
  const RoutineExercisesCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.title = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.techniqueNote = const Value.absent(),
    this.timerTarget = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineExercisesCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String routineId,
    required String title,
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.techniqueNote = const Value.absent(),
    this.timerTarget = const Value.absent(),
    required int orderIndex,
    required String type,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineId = Value(routineId),
       title = Value(title),
       orderIndex = Value(orderIndex),
       type = Value(type);
  static Insertable<RoutineExercise> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? title,
    Expression<int>? targetSets,
    Expression<String>? targetReps,
    Expression<String>? techniqueNote,
    Expression<String>? timerTarget,
    Expression<int>? orderIndex,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (title != null) 'title': title,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetReps != null) 'target_reps': targetReps,
      if (techniqueNote != null) 'technique_note': techniqueNote,
      if (timerTarget != null) 'timer_target': timerTarget,
      if (orderIndex != null) 'order_index': orderIndex,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineExercisesCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? routineId,
    Value<String>? title,
    Value<int?>? targetSets,
    Value<String?>? targetReps,
    Value<String?>? techniqueNote,
    Value<String?>? timerTarget,
    Value<int>? orderIndex,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return RoutineExercisesCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      title: title ?? this.title,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      techniqueNote: techniqueNote ?? this.techniqueNote,
      timerTarget: timerTarget ?? this.timerTarget,
      orderIndex: orderIndex ?? this.orderIndex,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<String>(targetReps.value);
    }
    if (techniqueNote.present) {
      map['technique_note'] = Variable<String>(techniqueNote.value);
    }
    if (timerTarget.present) {
      map['timer_target'] = Variable<String>(timerTarget.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercisesCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('techniqueNote: $techniqueNote, ')
          ..write('timerTarget: $timerTarget, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CircuitsTable extends Circuits with TableInfo<$CircuitsTable, Circuit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CircuitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<String> order = GeneratedColumn<String>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restMeta = const VerificationMeta('rest');
  @override
  late final GeneratedColumn<int> rest = GeneratedColumn<int>(
    'rest',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roundsMeta = const VerificationMeta('rounds');
  @override
  late final GeneratedColumn<int> rounds = GeneratedColumn<int>(
    'rounds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countdownMeta = const VerificationMeta(
    'countdown',
  );
  @override
  late final GeneratedColumn<int> countdown = GeneratedColumn<int>(
    'countdown',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stationDurationMeta = const VerificationMeta(
    'stationDuration',
  );
  @override
  late final GeneratedColumn<int> stationDuration = GeneratedColumn<int>(
    'station_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    title,
    order,
    rest,
    rounds,
    countdown,
    stationDuration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'circuits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Circuit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('rest')) {
      context.handle(
        _restMeta,
        rest.isAcceptableOrUnknown(data['rest']!, _restMeta),
      );
    }
    if (data.containsKey('rounds')) {
      context.handle(
        _roundsMeta,
        rounds.isAcceptableOrUnknown(data['rounds']!, _roundsMeta),
      );
    }
    if (data.containsKey('countdown')) {
      context.handle(
        _countdownMeta,
        countdown.isAcceptableOrUnknown(data['countdown']!, _countdownMeta),
      );
    }
    if (data.containsKey('station_duration')) {
      context.handle(
        _stationDurationMeta,
        stationDuration.isAcceptableOrUnknown(
          data['station_duration']!,
          _stationDurationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Circuit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Circuit(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order'],
      )!,
      rest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest'],
      ),
      rounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds'],
      ),
      countdown: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}countdown'],
      ),
      stationDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}station_duration'],
      ),
    );
  }

  @override
  $CircuitsTable createAlias(String alias) {
    return $CircuitsTable(attachedDatabase, alias);
  }
}

class Circuit extends DataClass implements Insertable<Circuit> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String title;
  final String order;
  final int? rest;
  final int? rounds;
  final int? countdown;
  final int? stationDuration;
  const Circuit({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.title,
    required this.order,
    this.rest,
    this.rounds,
    this.countdown,
    this.stationDuration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['order'] = Variable<String>(order);
    if (!nullToAbsent || rest != null) {
      map['rest'] = Variable<int>(rest);
    }
    if (!nullToAbsent || rounds != null) {
      map['rounds'] = Variable<int>(rounds);
    }
    if (!nullToAbsent || countdown != null) {
      map['countdown'] = Variable<int>(countdown);
    }
    if (!nullToAbsent || stationDuration != null) {
      map['station_duration'] = Variable<int>(stationDuration);
    }
    return map;
  }

  CircuitsCompanion toCompanion(bool nullToAbsent) {
    return CircuitsCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      title: Value(title),
      order: Value(order),
      rest: rest == null && nullToAbsent ? const Value.absent() : Value(rest),
      rounds: rounds == null && nullToAbsent
          ? const Value.absent()
          : Value(rounds),
      countdown: countdown == null && nullToAbsent
          ? const Value.absent()
          : Value(countdown),
      stationDuration: stationDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(stationDuration),
    );
  }

  factory Circuit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Circuit(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      order: serializer.fromJson<String>(json['order']),
      rest: serializer.fromJson<int?>(json['rest']),
      rounds: serializer.fromJson<int?>(json['rounds']),
      countdown: serializer.fromJson<int?>(json['countdown']),
      stationDuration: serializer.fromJson<int?>(json['stationDuration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'order': serializer.toJson<String>(order),
      'rest': serializer.toJson<int?>(rest),
      'rounds': serializer.toJson<int?>(rounds),
      'countdown': serializer.toJson<int?>(countdown),
      'stationDuration': serializer.toJson<int?>(stationDuration),
    };
  }

  Circuit copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? title,
    String? order,
    Value<int?> rest = const Value.absent(),
    Value<int?> rounds = const Value.absent(),
    Value<int?> countdown = const Value.absent(),
    Value<int?> stationDuration = const Value.absent(),
  }) => Circuit(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    title: title ?? this.title,
    order: order ?? this.order,
    rest: rest.present ? rest.value : this.rest,
    rounds: rounds.present ? rounds.value : this.rounds,
    countdown: countdown.present ? countdown.value : this.countdown,
    stationDuration: stationDuration.present
        ? stationDuration.value
        : this.stationDuration,
  );
  Circuit copyWithCompanion(CircuitsCompanion data) {
    return Circuit(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      order: data.order.present ? data.order.value : this.order,
      rest: data.rest.present ? data.rest.value : this.rest,
      rounds: data.rounds.present ? data.rounds.value : this.rounds,
      countdown: data.countdown.present ? data.countdown.value : this.countdown,
      stationDuration: data.stationDuration.present
          ? data.stationDuration.value
          : this.stationDuration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Circuit(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('rest: $rest, ')
          ..write('rounds: $rounds, ')
          ..write('countdown: $countdown, ')
          ..write('stationDuration: $stationDuration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    title,
    order,
    rest,
    rounds,
    countdown,
    stationDuration,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Circuit &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.title == this.title &&
          other.order == this.order &&
          other.rest == this.rest &&
          other.rounds == this.rounds &&
          other.countdown == this.countdown &&
          other.stationDuration == this.stationDuration);
}

class CircuitsCompanion extends UpdateCompanion<Circuit> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> title;
  final Value<String> order;
  final Value<int?> rest;
  final Value<int?> rounds;
  final Value<int?> countdown;
  final Value<int?> stationDuration;
  final Value<int> rowid;
  const CircuitsCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.order = const Value.absent(),
    this.rest = const Value.absent(),
    this.rounds = const Value.absent(),
    this.countdown = const Value.absent(),
    this.stationDuration = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CircuitsCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String title,
    required String order,
    this.rest = const Value.absent(),
    this.rounds = const Value.absent(),
    this.countdown = const Value.absent(),
    this.stationDuration = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       order = Value(order);
  static Insertable<Circuit> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? order,
    Expression<int>? rest,
    Expression<int>? rounds,
    Expression<int>? countdown,
    Expression<int>? stationDuration,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (order != null) 'order': order,
      if (rest != null) 'rest': rest,
      if (rounds != null) 'rounds': rounds,
      if (countdown != null) 'countdown': countdown,
      if (stationDuration != null) 'station_duration': stationDuration,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CircuitsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? title,
    Value<String>? order,
    Value<int?>? rest,
    Value<int?>? rounds,
    Value<int?>? countdown,
    Value<int?>? stationDuration,
    Value<int>? rowid,
  }) {
    return CircuitsCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      rest: rest ?? this.rest,
      rounds: rounds ?? this.rounds,
      countdown: countdown ?? this.countdown,
      stationDuration: stationDuration ?? this.stationDuration,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (order.present) {
      map['order'] = Variable<String>(order.value);
    }
    if (rest.present) {
      map['rest'] = Variable<int>(rest.value);
    }
    if (rounds.present) {
      map['rounds'] = Variable<int>(rounds.value);
    }
    if (countdown.present) {
      map['countdown'] = Variable<int>(countdown.value);
    }
    if (stationDuration.present) {
      map['station_duration'] = Variable<int>(stationDuration.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CircuitsCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('rest: $rest, ')
          ..write('rounds: $rounds, ')
          ..write('countdown: $countdown, ')
          ..write('stationDuration: $stationDuration, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CircuitExercisesTable extends CircuitExercises
    with TableInfo<$CircuitExercisesTable, CircuitExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CircuitExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _circuitIdMeta = const VerificationMeta(
    'circuitId',
  );
  @override
  late final GeneratedColumn<String> circuitId = GeneratedColumn<String>(
    'circuit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES circuits (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    circuitId,
    title,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'circuit_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CircuitExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('circuit_id')) {
      context.handle(
        _circuitIdMeta,
        circuitId.isAcceptableOrUnknown(data['circuit_id']!, _circuitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_circuitIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CircuitExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CircuitExercise(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      circuitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}circuit_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $CircuitExercisesTable createAlias(String alias) {
    return $CircuitExercisesTable(attachedDatabase, alias);
  }
}

class CircuitExercise extends DataClass implements Insertable<CircuitExercise> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String circuitId;
  final String title;
  final int orderIndex;
  const CircuitExercise({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.circuitId,
    required this.title,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['circuit_id'] = Variable<String>(circuitId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  CircuitExercisesCompanion toCompanion(bool nullToAbsent) {
    return CircuitExercisesCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      circuitId: Value(circuitId),
      title: Value(title),
      orderIndex: Value(orderIndex),
    );
  }

  factory CircuitExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CircuitExercise(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      circuitId: serializer.fromJson<String>(json['circuitId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'circuitId': serializer.toJson<String>(circuitId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  CircuitExercise copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? circuitId,
    String? title,
    int? orderIndex,
  }) => CircuitExercise(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    circuitId: circuitId ?? this.circuitId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  CircuitExercise copyWithCompanion(CircuitExercisesCompanion data) {
    return CircuitExercise(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      circuitId: data.circuitId.present ? data.circuitId.value : this.circuitId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CircuitExercise(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('circuitId: $circuitId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    circuitId,
    title,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CircuitExercise &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.circuitId == this.circuitId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex);
}

class CircuitExercisesCompanion extends UpdateCompanion<CircuitExercise> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> circuitId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const CircuitExercisesCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.circuitId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CircuitExercisesCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String circuitId,
    required String title,
    required int orderIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       circuitId = Value(circuitId),
       title = Value(title),
       orderIndex = Value(orderIndex);
  static Insertable<CircuitExercise> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? circuitId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (circuitId != null) 'circuit_id': circuitId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CircuitExercisesCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? circuitId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return CircuitExercisesCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      circuitId: circuitId ?? this.circuitId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (circuitId.present) {
      map['circuit_id'] = Variable<String>(circuitId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CircuitExercisesCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('circuitId: $circuitId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutLogsTable extends WorkoutLogs
    with TableInfo<$WorkoutLogsTable, WorkoutLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_exercises (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTrainingLoadMeta = const VerificationMeta(
    'totalTrainingLoad',
  );
  @override
  late final GeneratedColumn<double> totalTrainingLoad =
      GeneratedColumn<double>(
        'total_training_load',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    exerciseId,
    date,
    totalTrainingLoad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_training_load')) {
      context.handle(
        _totalTrainingLoadMeta,
        totalTrainingLoad.isAcceptableOrUnknown(
          data['total_training_load']!,
          _totalTrainingLoadMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLog(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalTrainingLoad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_training_load'],
      ),
    );
  }

  @override
  $WorkoutLogsTable createAlias(String alias) {
    return $WorkoutLogsTable(attachedDatabase, alias);
  }
}

class WorkoutLog extends DataClass implements Insertable<WorkoutLog> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String exerciseId;
  final DateTime date;
  final double? totalTrainingLoad;
  const WorkoutLog({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.exerciseId,
    required this.date,
    this.totalTrainingLoad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || totalTrainingLoad != null) {
      map['total_training_load'] = Variable<double>(totalTrainingLoad);
    }
    return map;
  }

  WorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      exerciseId: Value(exerciseId),
      date: Value(date),
      totalTrainingLoad: totalTrainingLoad == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTrainingLoad),
    );
  }

  factory WorkoutLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLog(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalTrainingLoad: serializer.fromJson<double?>(
        json['totalTrainingLoad'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'date': serializer.toJson<DateTime>(date),
      'totalTrainingLoad': serializer.toJson<double?>(totalTrainingLoad),
    };
  }

  WorkoutLog copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? exerciseId,
    DateTime? date,
    Value<double?> totalTrainingLoad = const Value.absent(),
  }) => WorkoutLog(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    date: date ?? this.date,
    totalTrainingLoad: totalTrainingLoad.present
        ? totalTrainingLoad.value
        : this.totalTrainingLoad,
  );
  WorkoutLog copyWithCompanion(WorkoutLogsCompanion data) {
    return WorkoutLog(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      date: data.date.present ? data.date.value : this.date,
      totalTrainingLoad: data.totalTrainingLoad.present
          ? data.totalTrainingLoad.value
          : this.totalTrainingLoad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLog(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('date: $date, ')
          ..write('totalTrainingLoad: $totalTrainingLoad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    exerciseId,
    date,
    totalTrainingLoad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLog &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.date == this.date &&
          other.totalTrainingLoad == this.totalTrainingLoad);
}

class WorkoutLogsCompanion extends UpdateCompanion<WorkoutLog> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<DateTime> date;
  final Value<double?> totalTrainingLoad;
  final Value<int> rowid;
  const WorkoutLogsCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalTrainingLoad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutLogsCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String exerciseId,
    required DateTime date,
    this.totalTrainingLoad = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseId = Value(exerciseId),
       date = Value(date);
  static Insertable<WorkoutLog> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<DateTime>? date,
    Expression<double>? totalTrainingLoad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (date != null) 'date': date,
      if (totalTrainingLoad != null) 'total_training_load': totalTrainingLoad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutLogsCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? exerciseId,
    Value<DateTime>? date,
    Value<double?>? totalTrainingLoad,
    Value<int>? rowid,
  }) {
    return WorkoutLogsCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      date: date ?? this.date,
      totalTrainingLoad: totalTrainingLoad ?? this.totalTrainingLoad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalTrainingLoad.present) {
      map['total_training_load'] = Variable<double>(totalTrainingLoad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('date: $date, ')
          ..write('totalTrainingLoad: $totalTrainingLoad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetEntriesTable extends SetEntries
    with TableInfo<$SetEntriesTable, SetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutLogIdMeta = const VerificationMeta(
    'workoutLogId',
  );
  @override
  late final GeneratedColumn<String> workoutLogId = GeneratedColumn<String>(
    'workout_log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_logs (id)',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeElapsedMeta = const VerificationMeta(
    'timeElapsed',
  );
  @override
  late final GeneratedColumn<int> timeElapsed = GeneratedColumn<int>(
    'time_elapsed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingLoadMeta = const VerificationMeta(
    'trainingLoad',
  );
  @override
  late final GeneratedColumn<double> trainingLoad = GeneratedColumn<double>(
    'training_load',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    workoutLogId,
    setNumber,
    reps,
    timeElapsed,
    weight,
    trainingLoad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_log_id')) {
      context.handle(
        _workoutLogIdMeta,
        workoutLogId.isAcceptableOrUnknown(
          data['workout_log_id']!,
          _workoutLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutLogIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('time_elapsed')) {
      context.handle(
        _timeElapsedMeta,
        timeElapsed.isAcceptableOrUnknown(
          data['time_elapsed']!,
          _timeElapsedMeta,
        ),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('training_load')) {
      context.handle(
        _trainingLoadMeta,
        trainingLoad.isAcceptableOrUnknown(
          data['training_load']!,
          _trainingLoadMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetEntry(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_log_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      timeElapsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_elapsed'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      trainingLoad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}training_load'],
      ),
    );
  }

  @override
  $SetEntriesTable createAlias(String alias) {
    return $SetEntriesTable(attachedDatabase, alias);
  }
}

class SetEntry extends DataClass implements Insertable<SetEntry> {
  final int version;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isDeleted;
  final String syncStatus;
  final String id;
  final String workoutLogId;
  final int setNumber;
  final int? reps;
  final int? timeElapsed;
  final double? weight;
  final double? trainingLoad;
  const SetEntry({
    required this.version,
    required this.updatedAt,
    required this.createdAt,
    required this.isDeleted,
    required this.syncStatus,
    required this.id,
    required this.workoutLogId,
    required this.setNumber,
    this.reps,
    this.timeElapsed,
    this.weight,
    this.trainingLoad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['id'] = Variable<String>(id);
    map['workout_log_id'] = Variable<String>(workoutLogId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || timeElapsed != null) {
      map['time_elapsed'] = Variable<int>(timeElapsed);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || trainingLoad != null) {
      map['training_load'] = Variable<double>(trainingLoad);
    }
    return map;
  }

  SetEntriesCompanion toCompanion(bool nullToAbsent) {
    return SetEntriesCompanion(
      version: Value(version),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
      syncStatus: Value(syncStatus),
      id: Value(id),
      workoutLogId: Value(workoutLogId),
      setNumber: Value(setNumber),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      timeElapsed: timeElapsed == null && nullToAbsent
          ? const Value.absent()
          : Value(timeElapsed),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      trainingLoad: trainingLoad == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingLoad),
    );
  }

  factory SetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetEntry(
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      id: serializer.fromJson<String>(json['id']),
      workoutLogId: serializer.fromJson<String>(json['workoutLogId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      reps: serializer.fromJson<int?>(json['reps']),
      timeElapsed: serializer.fromJson<int?>(json['timeElapsed']),
      weight: serializer.fromJson<double?>(json['weight']),
      trainingLoad: serializer.fromJson<double?>(json['trainingLoad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'id': serializer.toJson<String>(id),
      'workoutLogId': serializer.toJson<String>(workoutLogId),
      'setNumber': serializer.toJson<int>(setNumber),
      'reps': serializer.toJson<int?>(reps),
      'timeElapsed': serializer.toJson<int?>(timeElapsed),
      'weight': serializer.toJson<double?>(weight),
      'trainingLoad': serializer.toJson<double?>(trainingLoad),
    };
  }

  SetEntry copyWith({
    int? version,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isDeleted,
    String? syncStatus,
    String? id,
    String? workoutLogId,
    int? setNumber,
    Value<int?> reps = const Value.absent(),
    Value<int?> timeElapsed = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<double?> trainingLoad = const Value.absent(),
  }) => SetEntry(
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
    syncStatus: syncStatus ?? this.syncStatus,
    id: id ?? this.id,
    workoutLogId: workoutLogId ?? this.workoutLogId,
    setNumber: setNumber ?? this.setNumber,
    reps: reps.present ? reps.value : this.reps,
    timeElapsed: timeElapsed.present ? timeElapsed.value : this.timeElapsed,
    weight: weight.present ? weight.value : this.weight,
    trainingLoad: trainingLoad.present ? trainingLoad.value : this.trainingLoad,
  );
  SetEntry copyWithCompanion(SetEntriesCompanion data) {
    return SetEntry(
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      id: data.id.present ? data.id.value : this.id,
      workoutLogId: data.workoutLogId.present
          ? data.workoutLogId.value
          : this.workoutLogId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      reps: data.reps.present ? data.reps.value : this.reps,
      timeElapsed: data.timeElapsed.present
          ? data.timeElapsed.value
          : this.timeElapsed,
      weight: data.weight.present ? data.weight.value : this.weight,
      trainingLoad: data.trainingLoad.present
          ? data.trainingLoad.value
          : this.trainingLoad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetEntry(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('timeElapsed: $timeElapsed, ')
          ..write('weight: $weight, ')
          ..write('trainingLoad: $trainingLoad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    version,
    updatedAt,
    createdAt,
    isDeleted,
    syncStatus,
    id,
    workoutLogId,
    setNumber,
    reps,
    timeElapsed,
    weight,
    trainingLoad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetEntry &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted &&
          other.syncStatus == this.syncStatus &&
          other.id == this.id &&
          other.workoutLogId == this.workoutLogId &&
          other.setNumber == this.setNumber &&
          other.reps == this.reps &&
          other.timeElapsed == this.timeElapsed &&
          other.weight == this.weight &&
          other.trainingLoad == this.trainingLoad);
}

class SetEntriesCompanion extends UpdateCompanion<SetEntry> {
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<String> syncStatus;
  final Value<String> id;
  final Value<String> workoutLogId;
  final Value<int> setNumber;
  final Value<int?> reps;
  final Value<int?> timeElapsed;
  final Value<double?> weight;
  final Value<double?> trainingLoad;
  final Value<int> rowid;
  const SetEntriesCompanion({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.id = const Value.absent(),
    this.workoutLogId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.reps = const Value.absent(),
    this.timeElapsed = const Value.absent(),
    this.weight = const Value.absent(),
    this.trainingLoad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetEntriesCompanion.insert({
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String id,
    required String workoutLogId,
    required int setNumber,
    this.reps = const Value.absent(),
    this.timeElapsed = const Value.absent(),
    this.weight = const Value.absent(),
    this.trainingLoad = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutLogId = Value(workoutLogId),
       setNumber = Value(setNumber);
  static Insertable<SetEntry> custom({
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<String>? syncStatus,
    Expression<String>? id,
    Expression<String>? workoutLogId,
    Expression<int>? setNumber,
    Expression<int>? reps,
    Expression<int>? timeElapsed,
    Expression<double>? weight,
    Expression<double>? trainingLoad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (id != null) 'id': id,
      if (workoutLogId != null) 'workout_log_id': workoutLogId,
      if (setNumber != null) 'set_number': setNumber,
      if (reps != null) 'reps': reps,
      if (timeElapsed != null) 'time_elapsed': timeElapsed,
      if (weight != null) 'weight': weight,
      if (trainingLoad != null) 'training_load': trainingLoad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetEntriesCompanion copyWith({
    Value<int>? version,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<String>? syncStatus,
    Value<String>? id,
    Value<String>? workoutLogId,
    Value<int>? setNumber,
    Value<int?>? reps,
    Value<int?>? timeElapsed,
    Value<double?>? weight,
    Value<double?>? trainingLoad,
    Value<int>? rowid,
  }) {
    return SetEntriesCompanion(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
      id: id ?? this.id,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      weight: weight ?? this.weight,
      trainingLoad: trainingLoad ?? this.trainingLoad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutLogId.present) {
      map['workout_log_id'] = Variable<String>(workoutLogId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (timeElapsed.present) {
      map['time_elapsed'] = Variable<int>(timeElapsed.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (trainingLoad.present) {
      map['training_load'] = Variable<double>(trainingLoad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetEntriesCompanion(')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('timeElapsed: $timeElapsed, ')
          ..write('weight: $weight, ')
          ..write('trainingLoad: $trainingLoad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineExercisesTable routineExercises = $RoutineExercisesTable(
    this,
  );
  late final $CircuitsTable circuits = $CircuitsTable(this);
  late final $CircuitExercisesTable circuitExercises = $CircuitExercisesTable(
    this,
  );
  late final $WorkoutLogsTable workoutLogs = $WorkoutLogsTable(this);
  late final $SetEntriesTable setEntries = $SetEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    routineExercises,
    circuits,
    circuitExercises,
    workoutLogs,
    setEntries,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String title,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: $_aliasNameGenerator(
      db.routines.id,
      db.routineExercises.routineId,
    ),
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({bool routineExercisesRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                title: title,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                title: title,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineExercisesRefs) db.routineExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineExercisesRefs)
                    await $_getPrefetchedData<
                      Routine,
                      $RoutinesTable,
                      RoutineExercise
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableReferences
                          ._routineExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutinesTableReferences(
                        db,
                        table,
                        p0,
                      ).routineExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({bool routineExercisesRefs})
    >;
typedef $$RoutineExercisesTableCreateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String routineId,
      required String title,
      Value<int?> targetSets,
      Value<String?> targetReps,
      Value<String?> techniqueNote,
      Value<String?> timerTarget,
      required int orderIndex,
      required String type,
      Value<int> rowid,
    });
typedef $$RoutineExercisesTableUpdateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> routineId,
      Value<String> title,
      Value<int?> targetSets,
      Value<String?> targetReps,
      Value<String?> techniqueNote,
      Value<String?> timerTarget,
      Value<int> orderIndex,
      Value<String> type,
      Value<int> rowid,
    });

final class $$RoutineExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineExercisesTable, RoutineExercise> {
  $$RoutineExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias(
        $_aliasNameGenerator(db.routineExercises.routineId, db.routines.id),
      );

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutLogsTable, List<WorkoutLog>>
  _workoutLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutLogs,
    aliasName: $_aliasNameGenerator(
      db.routineExercises.id,
      db.workoutLogs.exerciseId,
    ),
  );

  $$WorkoutLogsTableProcessedTableManager get workoutLogsRefs {
    final manager = $$WorkoutLogsTableTableManager(
      $_db,
      $_db.workoutLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get techniqueNote => $composableBuilder(
    column: $table.techniqueNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timerTarget => $composableBuilder(
    column: $table.timerTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutLogsRefs(
    Expression<bool> Function($$WorkoutLogsTableFilterComposer f) f,
  ) {
    final $$WorkoutLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableFilterComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get techniqueNote => $composableBuilder(
    column: $table.techniqueNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timerTarget => $composableBuilder(
    column: $table.timerTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get techniqueNote => $composableBuilder(
    column: $table.techniqueNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timerTarget => $composableBuilder(
    column: $table.timerTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutLogsRefs<T extends Object>(
    Expression<T> Function($$WorkoutLogsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineExercisesTable,
          RoutineExercise,
          $$RoutineExercisesTableFilterComposer,
          $$RoutineExercisesTableOrderingComposer,
          $$RoutineExercisesTableAnnotationComposer,
          $$RoutineExercisesTableCreateCompanionBuilder,
          $$RoutineExercisesTableUpdateCompanionBuilder,
          (RoutineExercise, $$RoutineExercisesTableReferences),
          RoutineExercise,
          PrefetchHooks Function({bool routineId, bool workoutLogsRefs})
        > {
  $$RoutineExercisesTableTableManager(
    _$AppDatabase db,
    $RoutineExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> targetSets = const Value.absent(),
                Value<String?> targetReps = const Value.absent(),
                Value<String?> techniqueNote = const Value.absent(),
                Value<String?> timerTarget = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                routineId: routineId,
                title: title,
                targetSets: targetSets,
                targetReps: targetReps,
                techniqueNote: techniqueNote,
                timerTarget: timerTarget,
                orderIndex: orderIndex,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String routineId,
                required String title,
                Value<int?> targetSets = const Value.absent(),
                Value<String?> targetReps = const Value.absent(),
                Value<String?> techniqueNote = const Value.absent(),
                Value<String?> timerTarget = const Value.absent(),
                required int orderIndex,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                routineId: routineId,
                title: title,
                targetSets: targetSets,
                targetReps: targetReps,
                techniqueNote: techniqueNote,
                timerTarget: timerTarget,
                orderIndex: orderIndex,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineId = false, workoutLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutLogsRefs) db.workoutLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineId,
                                    referencedTable:
                                        $$RoutineExercisesTableReferences
                                            ._routineIdTable(db),
                                    referencedColumn:
                                        $$RoutineExercisesTableReferences
                                            ._routineIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutLogsRefs)
                        await $_getPrefetchedData<
                          RoutineExercise,
                          $RoutineExercisesTable,
                          WorkoutLog
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineExercisesTableReferences
                              ._workoutLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutineExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineExercisesTable,
      RoutineExercise,
      $$RoutineExercisesTableFilterComposer,
      $$RoutineExercisesTableOrderingComposer,
      $$RoutineExercisesTableAnnotationComposer,
      $$RoutineExercisesTableCreateCompanionBuilder,
      $$RoutineExercisesTableUpdateCompanionBuilder,
      (RoutineExercise, $$RoutineExercisesTableReferences),
      RoutineExercise,
      PrefetchHooks Function({bool routineId, bool workoutLogsRefs})
    >;
typedef $$CircuitsTableCreateCompanionBuilder =
    CircuitsCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String title,
      required String order,
      Value<int?> rest,
      Value<int?> rounds,
      Value<int?> countdown,
      Value<int?> stationDuration,
      Value<int> rowid,
    });
typedef $$CircuitsTableUpdateCompanionBuilder =
    CircuitsCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> title,
      Value<String> order,
      Value<int?> rest,
      Value<int?> rounds,
      Value<int?> countdown,
      Value<int?> stationDuration,
      Value<int> rowid,
    });

final class $$CircuitsTableReferences
    extends BaseReferences<_$AppDatabase, $CircuitsTable, Circuit> {
  $$CircuitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CircuitExercisesTable, List<CircuitExercise>>
  _circuitExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.circuitExercises,
    aliasName: $_aliasNameGenerator(
      db.circuits.id,
      db.circuitExercises.circuitId,
    ),
  );

  $$CircuitExercisesTableProcessedTableManager get circuitExercisesRefs {
    final manager = $$CircuitExercisesTableTableManager(
      $_db,
      $_db.circuitExercises,
    ).filter((f) => f.circuitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _circuitExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CircuitsTableFilterComposer
    extends Composer<_$AppDatabase, $CircuitsTable> {
  $$CircuitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rest => $composableBuilder(
    column: $table.rest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countdown => $composableBuilder(
    column: $table.countdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stationDuration => $composableBuilder(
    column: $table.stationDuration,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> circuitExercisesRefs(
    Expression<bool> Function($$CircuitExercisesTableFilterComposer f) f,
  ) {
    final $$CircuitExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.circuitExercises,
      getReferencedColumn: (t) => t.circuitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CircuitExercisesTableFilterComposer(
            $db: $db,
            $table: $db.circuitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CircuitsTableOrderingComposer
    extends Composer<_$AppDatabase, $CircuitsTable> {
  $$CircuitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rest => $composableBuilder(
    column: $table.rest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countdown => $composableBuilder(
    column: $table.countdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stationDuration => $composableBuilder(
    column: $table.stationDuration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CircuitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CircuitsTable> {
  $$CircuitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get rest =>
      $composableBuilder(column: $table.rest, builder: (column) => column);

  GeneratedColumn<int> get rounds =>
      $composableBuilder(column: $table.rounds, builder: (column) => column);

  GeneratedColumn<int> get countdown =>
      $composableBuilder(column: $table.countdown, builder: (column) => column);

  GeneratedColumn<int> get stationDuration => $composableBuilder(
    column: $table.stationDuration,
    builder: (column) => column,
  );

  Expression<T> circuitExercisesRefs<T extends Object>(
    Expression<T> Function($$CircuitExercisesTableAnnotationComposer a) f,
  ) {
    final $$CircuitExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.circuitExercises,
      getReferencedColumn: (t) => t.circuitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CircuitExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.circuitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CircuitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CircuitsTable,
          Circuit,
          $$CircuitsTableFilterComposer,
          $$CircuitsTableOrderingComposer,
          $$CircuitsTableAnnotationComposer,
          $$CircuitsTableCreateCompanionBuilder,
          $$CircuitsTableUpdateCompanionBuilder,
          (Circuit, $$CircuitsTableReferences),
          Circuit,
          PrefetchHooks Function({bool circuitExercisesRefs})
        > {
  $$CircuitsTableTableManager(_$AppDatabase db, $CircuitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CircuitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CircuitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CircuitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> order = const Value.absent(),
                Value<int?> rest = const Value.absent(),
                Value<int?> rounds = const Value.absent(),
                Value<int?> countdown = const Value.absent(),
                Value<int?> stationDuration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CircuitsCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                title: title,
                order: order,
                rest: rest,
                rounds: rounds,
                countdown: countdown,
                stationDuration: stationDuration,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String title,
                required String order,
                Value<int?> rest = const Value.absent(),
                Value<int?> rounds = const Value.absent(),
                Value<int?> countdown = const Value.absent(),
                Value<int?> stationDuration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CircuitsCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                title: title,
                order: order,
                rest: rest,
                rounds: rounds,
                countdown: countdown,
                stationDuration: stationDuration,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CircuitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({circuitExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (circuitExercisesRefs) db.circuitExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (circuitExercisesRefs)
                    await $_getPrefetchedData<
                      Circuit,
                      $CircuitsTable,
                      CircuitExercise
                    >(
                      currentTable: table,
                      referencedTable: $$CircuitsTableReferences
                          ._circuitExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$CircuitsTableReferences(
                        db,
                        table,
                        p0,
                      ).circuitExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.circuitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CircuitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CircuitsTable,
      Circuit,
      $$CircuitsTableFilterComposer,
      $$CircuitsTableOrderingComposer,
      $$CircuitsTableAnnotationComposer,
      $$CircuitsTableCreateCompanionBuilder,
      $$CircuitsTableUpdateCompanionBuilder,
      (Circuit, $$CircuitsTableReferences),
      Circuit,
      PrefetchHooks Function({bool circuitExercisesRefs})
    >;
typedef $$CircuitExercisesTableCreateCompanionBuilder =
    CircuitExercisesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String circuitId,
      required String title,
      required int orderIndex,
      Value<int> rowid,
    });
typedef $$CircuitExercisesTableUpdateCompanionBuilder =
    CircuitExercisesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> circuitId,
      Value<String> title,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$CircuitExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CircuitExercisesTable, CircuitExercise> {
  $$CircuitExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CircuitsTable _circuitIdTable(_$AppDatabase db) =>
      db.circuits.createAlias(
        $_aliasNameGenerator(db.circuitExercises.circuitId, db.circuits.id),
      );

  $$CircuitsTableProcessedTableManager get circuitId {
    final $_column = $_itemColumn<String>('circuit_id')!;

    final manager = $$CircuitsTableTableManager(
      $_db,
      $_db.circuits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_circuitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CircuitExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CircuitExercisesTable> {
  $$CircuitExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$CircuitsTableFilterComposer get circuitId {
    final $$CircuitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.circuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CircuitsTableFilterComposer(
            $db: $db,
            $table: $db.circuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CircuitExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CircuitExercisesTable> {
  $$CircuitExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$CircuitsTableOrderingComposer get circuitId {
    final $$CircuitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.circuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CircuitsTableOrderingComposer(
            $db: $db,
            $table: $db.circuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CircuitExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CircuitExercisesTable> {
  $$CircuitExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$CircuitsTableAnnotationComposer get circuitId {
    final $$CircuitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.circuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CircuitsTableAnnotationComposer(
            $db: $db,
            $table: $db.circuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CircuitExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CircuitExercisesTable,
          CircuitExercise,
          $$CircuitExercisesTableFilterComposer,
          $$CircuitExercisesTableOrderingComposer,
          $$CircuitExercisesTableAnnotationComposer,
          $$CircuitExercisesTableCreateCompanionBuilder,
          $$CircuitExercisesTableUpdateCompanionBuilder,
          (CircuitExercise, $$CircuitExercisesTableReferences),
          CircuitExercise,
          PrefetchHooks Function({bool circuitId})
        > {
  $$CircuitExercisesTableTableManager(
    _$AppDatabase db,
    $CircuitExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CircuitExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CircuitExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CircuitExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> circuitId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CircuitExercisesCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                circuitId: circuitId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String circuitId,
                required String title,
                required int orderIndex,
                Value<int> rowid = const Value.absent(),
              }) => CircuitExercisesCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                circuitId: circuitId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CircuitExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({circuitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (circuitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.circuitId,
                                referencedTable:
                                    $$CircuitExercisesTableReferences
                                        ._circuitIdTable(db),
                                referencedColumn:
                                    $$CircuitExercisesTableReferences
                                        ._circuitIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CircuitExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CircuitExercisesTable,
      CircuitExercise,
      $$CircuitExercisesTableFilterComposer,
      $$CircuitExercisesTableOrderingComposer,
      $$CircuitExercisesTableAnnotationComposer,
      $$CircuitExercisesTableCreateCompanionBuilder,
      $$CircuitExercisesTableUpdateCompanionBuilder,
      (CircuitExercise, $$CircuitExercisesTableReferences),
      CircuitExercise,
      PrefetchHooks Function({bool circuitId})
    >;
typedef $$WorkoutLogsTableCreateCompanionBuilder =
    WorkoutLogsCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String exerciseId,
      required DateTime date,
      Value<double?> totalTrainingLoad,
      Value<int> rowid,
    });
typedef $$WorkoutLogsTableUpdateCompanionBuilder =
    WorkoutLogsCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> exerciseId,
      Value<DateTime> date,
      Value<double?> totalTrainingLoad,
      Value<int> rowid,
    });

final class $$WorkoutLogsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLog> {
  $$WorkoutLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutineExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.routineExercises.createAlias(
        $_aliasNameGenerator(db.workoutLogs.exerciseId, db.routineExercises.id),
      );

  $$RoutineExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetEntriesTable, List<SetEntry>>
  _setEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.setEntries,
    aliasName: $_aliasNameGenerator(
      db.workoutLogs.id,
      db.setEntries.workoutLogId,
    ),
  );

  $$SetEntriesTableProcessedTableManager get setEntriesRefs {
    final manager = $$SetEntriesTableTableManager(
      $_db,
      $_db.setEntries,
    ).filter((f) => f.workoutLogId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalTrainingLoad => $composableBuilder(
    column: $table.totalTrainingLoad,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineExercisesTableFilterComposer get exerciseId {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setEntriesRefs(
    Expression<bool> Function($$SetEntriesTableFilterComposer f) f,
  ) {
    final $$SetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setEntries,
      getReferencedColumn: (t) => t.workoutLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.setEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalTrainingLoad => $composableBuilder(
    column: $table.totalTrainingLoad,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineExercisesTableOrderingComposer get exerciseId {
    final $$RoutineExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get totalTrainingLoad => $composableBuilder(
    column: $table.totalTrainingLoad,
    builder: (column) => column,
  );

  $$RoutineExercisesTableAnnotationComposer get exerciseId {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setEntriesRefs<T extends Object>(
    Expression<T> Function($$SetEntriesTableAnnotationComposer a) f,
  ) {
    final $$SetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setEntries,
      getReferencedColumn: (t) => t.workoutLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.setEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutLogsTable,
          WorkoutLog,
          $$WorkoutLogsTableFilterComposer,
          $$WorkoutLogsTableOrderingComposer,
          $$WorkoutLogsTableAnnotationComposer,
          $$WorkoutLogsTableCreateCompanionBuilder,
          $$WorkoutLogsTableUpdateCompanionBuilder,
          (WorkoutLog, $$WorkoutLogsTableReferences),
          WorkoutLog,
          PrefetchHooks Function({bool exerciseId, bool setEntriesRefs})
        > {
  $$WorkoutLogsTableTableManager(_$AppDatabase db, $WorkoutLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> totalTrainingLoad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutLogsCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                exerciseId: exerciseId,
                date: date,
                totalTrainingLoad: totalTrainingLoad,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String exerciseId,
                required DateTime date,
                Value<double?> totalTrainingLoad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutLogsCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                exerciseId: exerciseId,
                date: date,
                totalTrainingLoad: totalTrainingLoad,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({exerciseId = false, setEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (setEntriesRefs) db.setEntries],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$WorkoutLogsTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$WorkoutLogsTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (setEntriesRefs)
                        await $_getPrefetchedData<
                          WorkoutLog,
                          $WorkoutLogsTable,
                          SetEntry
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutLogsTableReferences
                              ._setEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutLogsTableReferences(
                                db,
                                table,
                                p0,
                              ).setEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutLogId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutLogsTable,
      WorkoutLog,
      $$WorkoutLogsTableFilterComposer,
      $$WorkoutLogsTableOrderingComposer,
      $$WorkoutLogsTableAnnotationComposer,
      $$WorkoutLogsTableCreateCompanionBuilder,
      $$WorkoutLogsTableUpdateCompanionBuilder,
      (WorkoutLog, $$WorkoutLogsTableReferences),
      WorkoutLog,
      PrefetchHooks Function({bool exerciseId, bool setEntriesRefs})
    >;
typedef $$SetEntriesTableCreateCompanionBuilder =
    SetEntriesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      required String id,
      required String workoutLogId,
      required int setNumber,
      Value<int?> reps,
      Value<int?> timeElapsed,
      Value<double?> weight,
      Value<double?> trainingLoad,
      Value<int> rowid,
    });
typedef $$SetEntriesTableUpdateCompanionBuilder =
    SetEntriesCompanion Function({
      Value<int> version,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<String> syncStatus,
      Value<String> id,
      Value<String> workoutLogId,
      Value<int> setNumber,
      Value<int?> reps,
      Value<int?> timeElapsed,
      Value<double?> weight,
      Value<double?> trainingLoad,
      Value<int> rowid,
    });

final class $$SetEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $SetEntriesTable, SetEntry> {
  $$SetEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutLogsTable _workoutLogIdTable(_$AppDatabase db) =>
      db.workoutLogs.createAlias(
        $_aliasNameGenerator(db.setEntries.workoutLogId, db.workoutLogs.id),
      );

  $$WorkoutLogsTableProcessedTableManager get workoutLogId {
    final $_column = $_itemColumn<String>('workout_log_id')!;

    final manager = $$WorkoutLogsTableTableManager(
      $_db,
      $_db.workoutLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeElapsed => $composableBuilder(
    column: $table.timeElapsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutLogsTableFilterComposer get workoutLogId {
    final $$WorkoutLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableFilterComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeElapsed => $composableBuilder(
    column: $table.timeElapsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutLogsTableOrderingComposer get workoutLogId {
    final $$WorkoutLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetEntriesTable> {
  $$SetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get timeElapsed => $composableBuilder(
    column: $table.timeElapsed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => column,
  );

  $$WorkoutLogsTableAnnotationComposer get workoutLogId {
    final $$WorkoutLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetEntriesTable,
          SetEntry,
          $$SetEntriesTableFilterComposer,
          $$SetEntriesTableOrderingComposer,
          $$SetEntriesTableAnnotationComposer,
          $$SetEntriesTableCreateCompanionBuilder,
          $$SetEntriesTableUpdateCompanionBuilder,
          (SetEntry, $$SetEntriesTableReferences),
          SetEntry,
          PrefetchHooks Function({bool workoutLogId})
        > {
  $$SetEntriesTableTableManager(_$AppDatabase db, $SetEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> workoutLogId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> timeElapsed = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> trainingLoad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetEntriesCompanion(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                workoutLogId: workoutLogId,
                setNumber: setNumber,
                reps: reps,
                timeElapsed: timeElapsed,
                weight: weight,
                trainingLoad: trainingLoad,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required String id,
                required String workoutLogId,
                required int setNumber,
                Value<int?> reps = const Value.absent(),
                Value<int?> timeElapsed = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> trainingLoad = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetEntriesCompanion.insert(
                version: version,
                updatedAt: updatedAt,
                createdAt: createdAt,
                isDeleted: isDeleted,
                syncStatus: syncStatus,
                id: id,
                workoutLogId: workoutLogId,
                setNumber: setNumber,
                reps: reps,
                timeElapsed: timeElapsed,
                weight: weight,
                trainingLoad: trainingLoad,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutLogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutLogId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutLogId,
                                referencedTable: $$SetEntriesTableReferences
                                    ._workoutLogIdTable(db),
                                referencedColumn: $$SetEntriesTableReferences
                                    ._workoutLogIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetEntriesTable,
      SetEntry,
      $$SetEntriesTableFilterComposer,
      $$SetEntriesTableOrderingComposer,
      $$SetEntriesTableAnnotationComposer,
      $$SetEntriesTableCreateCompanionBuilder,
      $$SetEntriesTableUpdateCompanionBuilder,
      (SetEntry, $$SetEntriesTableReferences),
      SetEntry,
      PrefetchHooks Function({bool workoutLogId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineExercisesTableTableManager get routineExercises =>
      $$RoutineExercisesTableTableManager(_db, _db.routineExercises);
  $$CircuitsTableTableManager get circuits =>
      $$CircuitsTableTableManager(_db, _db.circuits);
  $$CircuitExercisesTableTableManager get circuitExercises =>
      $$CircuitExercisesTableTableManager(_db, _db.circuitExercises);
  $$WorkoutLogsTableTableManager get workoutLogs =>
      $$WorkoutLogsTableTableManager(_db, _db.workoutLogs);
  $$SetEntriesTableTableManager get setEntries =>
      $$SetEntriesTableTableManager(_db, _db.setEntries);
}
