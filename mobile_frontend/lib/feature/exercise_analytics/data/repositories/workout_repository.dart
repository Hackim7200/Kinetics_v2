import 'dart:math';

import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/sources/workout_local_source.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/workout_metrics.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/training_load.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'workout_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes workouts and their sets, scoped per [RoutineExercise]
/// via workout [exerciseId]. Maps Drift rows to drift-free domain entities.
class WorkoutRepository {
  WorkoutRepository(this._local);

  final WorkoutLocalSource _local;

  Set _setFromRow(drift.SetEntry row) {
    final load =
        row.trainingLoad ??
        trainingLoadForSet(
          weight: row.weight,
          reps: row.reps,
          timeElapsed: row.timeElapsed,
        );
    return Set(
      id: row.id,
      workoutId: row.workoutLogId,
      setNumber: row.setNumber,
      reps: row.reps,
      timeElapsed: row.timeElapsed,
      weight: row.weight,
      trainingLoad: load,
    );
  }

  Workout _workoutFromRow(drift.WorkoutLog row, List<Set> sets) {
    return Workout(
      id: row.id,
      exerciseId: row.exerciseId,
      date: row.date.toLocal(),
      sets: sets,
      totalTrainingLoad: row.totalTrainingLoad,
    );
  }

  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<drift.WorkoutLog?> _findTodaysWorkout(String routineExerciseId) async {
    final rows = await _local.workoutLogsForExercise(routineExerciseId);
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

  Future<Workout> getOrCreateTodaysWorkout(String routineExerciseId) async {
    final existing = await _findTodaysWorkout(routineExerciseId);
    if (existing != null) return _workoutFromRow(existing, const []);

    final id = _uuid.v4();
    final date = DateTime.now().toUtc();
    await _local.insertWorkoutLog(
      id: id,
      exerciseId: routineExerciseId,
      date: date,
    );
    return Workout(id: id, exerciseId: routineExerciseId, date: date.toLocal());
  }

  Future<List<Set>> loadSets(String workoutId) async {
    final rows = await _local.setEntriesForWorkout(workoutId);
    return rows.map(_setFromRow).toList();
  }

  Future<void> saveTotalTrainingLoad(String workoutId, List<Set> sets) async {
    final total = aggregateMetricForWorkoutSets(sets);
    await _local.updateWorkoutTotalTrainingLoad(workoutId, total);
  }

  Future<Set> persistSet(String workoutId, Set entry) async {
    final load = trainingLoadForSet(
      weight: entry.weight,
      reps: entry.reps,
      timeElapsed: entry.timeElapsed,
    );
    final id = entry.id ?? _uuid.v4();

    await _local.upsertSetEntry(
      id: id,
      workoutLogId: workoutId,
      setNumber: entry.setNumber,
      weight: entry.weight,
      reps: entry.reps,
      trainingLoad: load,
      timeElapsed: entry.timeElapsed,
    );

    final saved = entry.copyWith(
      id: id,
      workoutId: workoutId,
      trainingLoad: load,
    );
    final allSets = await loadSets(workoutId);
    await saveTotalTrainingLoad(workoutId, allSets);
    return saved;
  }

  Future<List<Workout>> listWorkouts(
    String routineExerciseId, {
    int? limit,
  }) async {
    final rows = await _local.workoutLogsForExerciseNewestFirst(
      routineExerciseId,
    );
    if (rows.isEmpty) return [];

    final selected = (limit != null ? rows.take(limit) : rows).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final workouts = <Workout>[];
    for (final row in selected) {
      final sets = await loadSets(row.id);
      workouts.add(_workoutFromRow(row, sets));
    }
    return workouts;
  }

  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final rows = await _local.workoutLogsForExercise(routineExerciseId);
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

  /// Strength volume change for the most recent session with data vs the prior one.
  Future<double?> latestSessionTrainingLoadChangePercent(
    String routineExerciseId,
  ) async {
    final rows = await _local.workoutLogsForExercise(routineExerciseId);
    final ordered = rows.toList()..sort((a, b) => b.date.compareTo(a.date));

    for (var index = 0; index < ordered.length; index++) {
      final currentTotal = await _sessionTotal(ordered[index]);
      if (currentTotal <= 0) continue;

      if (index + 1 < ordered.length) {
        final previousTotal = await _sessionTotal(ordered[index + 1]);
        if (previousTotal > 0) {
          return WorkoutMetrics.trainingLoadChangePercentVsPrevious(
            currentTotal,
            previousTotal,
          );
        }
      }
    }
    return null;
  }

  Future<double> _sessionTotal(drift.WorkoutLog row) async {
    final stored = row.totalTrainingLoad;
    if (stored != null) return stored;
    final sets = await loadSets(row.id);
    return aggregateMetricForWorkoutSets(sets);
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

    final existing = await _local.workoutLogsForExercise(routineExerciseId);

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
    await _local.insertWorkoutLog(
      id: workoutId,
      exerciseId: routineExerciseId,
      date: sessionLocal.toUtc(),
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
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepository(WorkoutLocalSource(ref.watch(appDatabaseProvider)));
}
