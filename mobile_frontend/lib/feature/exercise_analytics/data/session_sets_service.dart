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
/// calendar day, scoped by [RoutineExercise] via [WorkoutLog.routineExerciseId].
class SessionSetsService {
  SessionSetsService(this._db);

  final drift.AppDatabase _db;

  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<drift.WorkoutLog?> _findTodaysLog(String routineExerciseId) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.routineExerciseId.equals(routineExerciseId)))
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
      routineExerciseId: routineExerciseId,
      date: DateTime.now().toUtc(),
    );
    await _db.into(_db.workoutLogs).insert(
          drift.WorkoutLogsCompanion.insert(
            id: log.id,
            routineExerciseId: routineExerciseId,
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
      isCompleted: row.isCompleted ?? false,
      trainingLoad: load,
      durationSeconds: row.durationSeconds,
      datastoreId: row.id,
    );
  }

  Future<double> _resolvedTotalTrainingLoadForLog(drift.WorkoutLog log) async {
    final stored = log.totalTrainingLoad;
    if (stored != null) return stored;
    final sets = await loadSets(log.id);
    return session.aggregateMetricForWorkoutLogSets(sets);
  }

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) =>
      WorkoutLogStats.trainingLoadChangePercentVsPrevious(
        currentTotal,
        previousTotal,
      );

  static double? trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<drift.WorkoutLog> allLogs,
  ) =>
      WorkoutLogStats.trainingLoadChangePercentForLatestSession(
        routineExerciseId,
        allLogs,
      );

  Future<void> saveWorkoutLogTotalTrainingLoad(
    String workoutLogId,
    List<session.SetEntry> sets,
  ) async {
    final total = session.aggregateMetricForWorkoutLogSets(sets);
    final rows = await (_db.select(_db.workoutLogs)
          ..where((l) => l.id.equals(workoutLogId)))
        .get();
    if (rows.isEmpty) return;
    final current = rows.first;

    final siblings = await (_db.select(_db.workoutLogs)
          ..where((l) => l.routineExerciseId.equals(current.routineExerciseId))
          ..orderBy([(l) => OrderingTerm.asc(l.date)]))
        .get();
    final idx = siblings.indexWhere((l) => l.id == workoutLogId);

    double? changePercent;
    if (idx > 0) {
      final previousTotal =
          await _resolvedTotalTrainingLoadForLog(siblings[idx - 1]);
      changePercent =
          trainingLoadChangePercentVsPrevious(total, previousTotal);
    }

    await (_db.update(_db.workoutLogs)..where((l) => l.id.equals(workoutLogId)))
        .write(
      drift.WorkoutLogsCompanion(
        totalTrainingLoad: Value(total),
        trainingLoadChangePercent: changePercent != null
            ? Value(changePercent)
            : const Value.absent(),
      ),
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
            durationSeconds: Value(entry.durationSeconds),
            isCompleted: Value(entry.isCompleted),
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
            totalTrainingLoad: session.totalTrainingLoadForSets(w.sets),
          ),
        )
        .toList();
  }

  Future<List<session.WorkoutLog>> recentWorkoutsWithSets(
    String routineExerciseId, {
    int limit = 20,
  }) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.routineExerciseId.equals(routineExerciseId))
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
          trainingLoadChangePercent: log.trainingLoadChangePercent,
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
          ..where((l) => l.routineExerciseId.equals(routineExerciseId)))
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

  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.routineExerciseId.equals(routineExerciseId)))
        .get();
    if (logs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int? best;
    for (final log in logs) {
      if (log.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(log.id);
      for (final s in sets) {
        final d = s.durationSeconds;
        if (d == null || d < 1) continue;
        if (best == null || d > best) best = d;
      }
    }
    return best;
  }
}
