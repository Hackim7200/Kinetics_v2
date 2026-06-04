import 'dart:math';

import 'package:drift/drift.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_stats.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';
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

/// Loads and saves workout [Set] rows in Drift for the current
/// calendar day, scoped by [RoutineExercise] via workout [exerciseId].
class WorkoutService {
  WorkoutService(this._db);

  final drift.AppDatabase _db;

  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<drift.WorkoutLog?> _findTodaysWorkout(String routineExerciseId) async {
    final rows = await (_db.select(
      _db.workoutLogs,
    )..where((l) => l.exerciseId.equals(routineExerciseId))).get();
    final nowLocal = DateTime.now();
    drift.WorkoutLog? best;
    for (final row in rows) {
      final local = row.date.toLocal();
      if (_isSameLocalCalendarDay(local, nowLocal)) {
        if (best == null || row.date.isAfter(best.date)) {
          best = row;
        }
      }
    }
    return best;
  }

  Future<drift.WorkoutLog> getOrCreateTodaysWorkout(
    String routineExerciseId,
  ) async {
    final existing = await _findTodaysWorkout(routineExerciseId);
    if (existing != null) return existing;

    final row = drift.WorkoutLog(
      id: _uuid.v4(),
      exerciseId: routineExerciseId,
      date: DateTime.now().toUtc(),
    );
    await _db
        .into(_db.workoutLogs)
        .insert(
          drift.WorkoutLogsCompanion.insert(
            id: row.id,
            exerciseId: routineExerciseId,
            date: row.date,
          ),
        );
    return row;
  }

  Future<List<Set>> loadSets(String workoutId) async {
    final rows =
        await (_db.select(_db.setEntries)
              ..where((s) => s.workoutLogId.equals(workoutId))
              ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
            .get();
    return rows.map(Set.fromDriftRow).toList();
  }

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) => WorkoutStats.trainingLoadChangePercentVsPrevious(
    currentTotal,
    previousTotal,
  );

  Future<double?> trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<drift.WorkoutLog> allWorkouts,
  ) => WorkoutStats.trainingLoadChangePercentForLatestSession(
    routineExerciseId,
    allWorkouts,
    loadSets,
  );

  Future<void> saveTotalTrainingLoad(String workoutId, List<Set> sets) async {
    final total = aggregateMetricForWorkoutSets(sets);
    await (_db.update(_db.workoutLogs)..where((l) => l.id.equals(workoutId)))
        .write(drift.WorkoutLogsCompanion(totalTrainingLoad: Value(total)));
  }

  Future<Set> persistSet(String workoutId, Set entry) async {
    final load = trainingLoadForStrengthSet(entry.weight, entry.reps);
    final id = entry.id ?? _uuid.v4();

    await _db
        .into(_db.setEntries)
        .insertOnConflictUpdate(
          drift.SetEntriesCompanion.insert(
            id: id,
            workoutLogId: workoutId,
            setNumber: entry.setNumber,
            weight: Value(entry.weight),
            reps: Value(entry.reps),
            trainingLoad: Value(load),
            timeElapsed: Value(entry.timeElapsed),
          ),
        );
    return entry.copyWith(id: id, workoutId: workoutId, trainingLoad: load);
  }

  Future<List<WorkoutTrainingLoadPoint>> lastWorkoutsTrainingLoad(
    String routineExerciseId, {
    int limit = 7,
  }) async {
    final withSets = await allWorkoutSince(routineExerciseId, limit: limit);
    return withSets
        .map(
          (workout) => WorkoutTrainingLoadPoint(
            date: workout.date,
            totalTrainingLoad:
                workout.totalTrainingLoad ??
                totalTrainingLoadForSets(workout.sets),
          ),
        )
        .toList();
  }

  Future<List<Workout>> allWorkoutSince(
    String routineExerciseId, {
    int? limit,
  }) async {
    final rows =
        await (_db.select(_db.workoutLogs)
              ..where((l) => l.exerciseId.equals(routineExerciseId))
              ..orderBy([(l) => OrderingTerm.desc(l.date)]))
            .get();
    if (rows.isEmpty) return [];

    final selected = (limit != null ? rows.take(limit) : rows).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final workouts = <Workout>[];
    for (final row in selected) {
      final sets = await loadSets(row.id);
      workouts.add(
        Workout.fromDrift(
          id: row.id,
          exerciseId: row.exerciseId,
          date: row.date,
          sets: sets,
          totalTrainingLoad: row.totalTrainingLoad,
        ),
      );
    }
    return workouts;
  }

  Future<double?> maxStrengthWeightLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final rows = await (_db.select(
      _db.workoutLogs,
    )..where((l) => l.exerciseId.equals(routineExerciseId))).get();
    if (rows.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    double? best;
    for (final row in rows) {
      if (row.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(row.id);
      for (final set in sets) {
        if (trainingLoadForStrengthSet(set.weight, set.reps) == null) {
          continue;
        }
        final weight = set.weight!;
        if (best == null || weight > best) best = weight;
      }
    }
    return best;
  }

  /// Inserts a completed strength session on a random free day in the past.
  /// Returns the local session [DateTime], or null if no day is available.
  /// For dev/testing only.
  Future<DateTime?> insertRandomDummyStrengthWorkoutInPast({
    required String routineExerciseId,
    required int setCount,
    double weightHintKg = 60,
    int repsHint = 8,
    int maxDaysAgo = 90,
  }) async {
    final setsToCreate = setCount.clamp(1, 20);
    final random = Random();
    final nowLocal = DateTime.now();
    final todayStart = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

    final existing = await (_db.select(
      _db.workoutLogs,
    )..where((l) => l.exerciseId.equals(routineExerciseId))).get();

    final occupiedDays = <String>{};
    for (final row in existing) {
      final local = row.date.toLocal();
      occupiedDays.add('${local.year}-${local.month}-${local.day}');
    }

    final openPastDays = <DateTime>[];
    for (var daysAgo = 1; daysAgo <= maxDaysAgo; daysAgo++) {
      final day = todayStart.subtract(Duration(days: daysAgo));
      final key = '${day.year}-${day.month}-${day.day}';
      if (!occupiedDays.contains(key)) {
        openPastDays.add(day);
      }
    }
    if (openPastDays.isEmpty) return null;

    final pickedDay = openPastDays[random.nextInt(openPastDays.length)];
    final sessionLocal = DateTime(
      pickedDay.year,
      pickedDay.month,
      pickedDay.day,
      8 + random.nextInt(12),
      random.nextInt(60),
    );

    final workoutId = _uuid.v4();
    await _db
        .into(_db.workoutLogs)
        .insert(
          drift.WorkoutLogsCompanion.insert(
            id: workoutId,
            exerciseId: routineExerciseId,
            date: sessionLocal.toUtc(),
          ),
        );

    final persistedSets = <Set>[];
    for (var setNumber = 1; setNumber <= setsToCreate; setNumber++) {
      final weight = _randomDummyWeightKg(random, weightHintKg);
      final reps = _randomDummyReps(random, repsHint);
      final entry = Set(setNumber: setNumber, weight: weight, reps: reps);
      persistedSets.add(await persistSet(workoutId, entry));
    }
    await saveTotalTrainingLoad(workoutId, persistedSets);
    return sessionLocal;
  }

  static double _randomDummyWeightKg(Random random, double hintKg) {
    final center = hintKg > 0 ? hintKg : 60.0;
    final minKg = (center - 25).clamp(20.0, 999.5);
    final maxKg = (center + 25).clamp(20.0, 999.5);
    final stepCount = ((maxKg - minKg) / 2.5).floor();
    return minKg + random.nextInt(stepCount + 1) * 2.5;
  }

  static int _randomDummyReps(Random random, int hint) {
    final center = hint > 0 ? hint : 10;
    final minReps = (center - 4).clamp(
      TrainingTargetInput.minReps,
      TrainingTargetInput.maxReps,
    );
    final maxReps = (center + 4).clamp(
      TrainingTargetInput.minReps,
      TrainingTargetInput.maxReps,
    );
    return minReps + random.nextInt(maxReps - minReps + 1);
  }

  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final rows = await (_db.select(
      _db.workoutLogs,
    )..where((l) => l.exerciseId.equals(routineExerciseId))).get();
    if (rows.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int? best;
    for (final row in rows) {
      if (row.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(row.id);
      for (final set in sets) {
        final duration = set.timeElapsed;
        if (duration == null || duration < 1) continue;
        if (best == null || duration > best) best = duration;
      }
    }
    return best;
  }
}
