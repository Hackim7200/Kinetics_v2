import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_log_stats.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart' as session;
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// One saved workout session’s total strength training load (Σ set loads).
class WorkoutTrainingLoadPoint {
  const WorkoutTrainingLoadPoint({
    required this.date,
    required this.totalTrainingLoad,
  });

  final DateTime date;
  final double totalTrainingLoad;
}

/// Loads and saves workout [session.SetEntry] rows in Drift for the current
/// calendar day, scoped by [RoutineExercise] via [WorkoutLog.exerciseId].
class SessionSetsService {
  SessionSetsService(this._db);

  final drift.AppDatabase _db;

  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<drift.WorkoutLog?> _findTodaysLog(String routineExerciseId) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId)))
        .get();
    final nowLocal = DateTime.now();
    drift.WorkoutLog? best;
    for (final log in logs) {
      final local = log.date.toLocal();
      if (_isSameLocalCalendarDay(local, nowLocal)) {
        if (best == null || log.date.isAfter(best.date)) {
          best = log;
        }
      }
    }
    return best;
  }

  Future<drift.WorkoutLog> getOrCreateTodaysLog(String routineExerciseId) async {
    final existing = await _findTodaysLog(routineExerciseId);
    if (existing != null) return existing;

    final log = drift.WorkoutLog(
      id: _uuid.v4(),
      exerciseId: routineExerciseId,
      date: DateTime.now().toUtc(),
    );
    await _db.into(_db.workoutLogs).insert(
          drift.WorkoutLogsCompanion.insert(
            id: log.id,
            exerciseId: routineExerciseId,
            date: log.date,
          ),
        );
    return log;
  }

  Future<List<session.SetEntry>> loadSets(String workoutLogId) async {
    final rows = await (_db.select(_db.setEntries)
          ..where((s) => s.workoutLogId.equals(workoutLogId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  session.SetEntry _fromRow(drift.SetEntry row) {
    final load = row.trainingLoad ??
        session.trainingLoadForStrengthSet(row.weight, row.reps);
    return session.SetEntry(
      setNumber: row.setNumber,
      weight: row.weight,
      reps: row.reps,
      isCompleted: load != null ||
          (row.timeElapsed != null && row.timeElapsed! > 0),
      trainingLoad: load,
      timeElapsed: row.timeElapsed,
      datastoreId: row.id,
    );
  }

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) =>
      WorkoutLogStats.trainingLoadChangePercentVsPrevious(
        currentTotal,
        previousTotal,
      );

  Future<double?> trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<drift.WorkoutLog> allLogs,
  ) =>
      WorkoutLogStats.trainingLoadChangePercentForLatestSession(
        routineExerciseId,
        allLogs,
        loadSets,
      );

  Future<void> saveWorkoutLogTotalTrainingLoad(
    String workoutLogId,
    List<session.SetEntry> sets,
  ) async {
    final total = session.aggregateMetricForWorkoutLogSets(sets);
    await (_db.update(_db.workoutLogs)..where((l) => l.id.equals(workoutLogId)))
        .write(
      drift.WorkoutLogsCompanion(totalTrainingLoad: Value(total)),
    );
  }

  Future<session.SetEntry> persistSet(
    String workoutLogId,
    session.SetEntry entry,
  ) async {
    final load = session.trainingLoadForStrengthSet(entry.weight, entry.reps);
    final id = entry.datastoreId ?? _uuid.v4();

    await _db.into(_db.setEntries).insertOnConflictUpdate(
          drift.SetEntriesCompanion.insert(
            id: id,
            workoutLogId: workoutLogId,
            setNumber: entry.setNumber,
            weight: Value(entry.weight),
            reps: Value(entry.reps),
            trainingLoad: Value(load),
            timeElapsed: Value(entry.timeElapsed),
          ),
        );
    return entry.copyWith(datastoreId: id, trainingLoad: load);
  }

  Future<List<WorkoutTrainingLoadPoint>> lastWorkoutsTrainingLoad(
    String routineExerciseId, {
    int limit = 7,
  }) async {
    final withSets = await recentWorkoutsWithSets(
      routineExerciseId,
      limit: limit,
    );
    return withSets
        .map(
          (w) => WorkoutTrainingLoadPoint(
            date: w.date,
            totalTrainingLoad:
                w.totalTrainingLoad ?? session.totalTrainingLoadForSets(w.sets),
          ),
        )
        .toList();
  }

  Future<List<session.WorkoutLog>> recentWorkoutsWithSets(
    String routineExerciseId, {
    int limit = 20,
  }) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId))
          ..orderBy([(l) => OrderingTerm.desc(l.date)]))
        .get();
    if (logs.isEmpty) return [];

    final selected = logs.take(limit).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final out = <session.WorkoutLog>[];
    for (final log in selected) {
      final sets = await loadSets(log.id);
      out.add(
        session.WorkoutLog(
          id: log.id,
          exerciseId: routineExerciseId,
          date: log.date.toLocal(),
          sets: sets,
          totalTrainingLoad: log.totalTrainingLoad,
        ),
      );
    }
    return out;
  }

  Future<double?> maxStrengthWeightLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId)))
        .get();
    if (logs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    double? best;
    for (final log in logs) {
      if (log.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(log.id);
      for (final s in sets) {
        if (session.trainingLoadForStrengthSet(s.weight, s.reps) == null) {
          continue;
        }
        final w = s.weight!;
        if (best == null || w > best) best = w;
      }
    }
    return best;
  }

  /// Inserts a completed strength session dated yesterday (local calendar day).
  /// Returns false if a log already exists for that day. For dev/testing only.
  Future<bool> insertDummyStrengthWorkoutForYesterday({
    required String routineExerciseId,
    required int setCount,
    double baseWeightKg = 60,
    int repsPerSet = 8,
  }) async {
    final setsToCreate = setCount.clamp(1, 20);
    final nowLocal = DateTime.now();
    final yesterdayStart = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day,
    ).subtract(const Duration(days: 1));

    final existing = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId)))
        .get();
    for (final log in existing) {
      final local = log.date.toLocal();
      if (local.year == yesterdayStart.year &&
          local.month == yesterdayStart.month &&
          local.day == yesterdayStart.day) {
        return false;
      }
    }

    final sessionLocal = DateTime(
      yesterdayStart.year,
      yesterdayStart.month,
      yesterdayStart.day,
      18,
      0,
    );
    final logId = _uuid.v4();
    await _db.into(_db.workoutLogs).insert(
          drift.WorkoutLogsCompanion.insert(
            id: logId,
            exerciseId: routineExerciseId,
            date: sessionLocal.toUtc(),
          ),
        );

    final persistedSets = <session.SetEntry>[];
    for (var n = 1; n <= setsToCreate; n++) {
      final weight = baseWeightKg + (n - 1) * 2.5;
      final entry = session.SetEntry(
        setNumber: n,
        weight: weight,
        reps: repsPerSet,
        isCompleted: true,
      );
      persistedSets.add(await persistSet(logId, entry));
    }
    await saveWorkoutLogTotalTrainingLoad(logId, persistedSets);
    return true;
  }

  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId)))
        .get();
    if (logs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int? best;
    for (final log in logs) {
      if (log.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(log.id);
      for (final s in sets) {
        final d = s.timeElapsed;
        if (d == null || d < 1) continue;
        if (best == null || d > best) best = d;
      }
    }
    return best;
  }
}
