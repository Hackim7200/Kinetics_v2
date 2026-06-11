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

  Set _setFromDriftSetEntry(drift.SetEntry driftSetEntry) {
    final load =
        driftSetEntry.trainingLoad ??
        trainingLoadForSet(
          weight: driftSetEntry.weight,
          reps: driftSetEntry.reps,
          timeElapsed: driftSetEntry.timeElapsed,
        );
    return Set(
      id: driftSetEntry.id,
      workoutId: driftSetEntry.workoutLogId,
      setNumber: driftSetEntry.setNumber,
      reps: driftSetEntry.reps,
      timeElapsed: driftSetEntry.timeElapsed,
      weight: driftSetEntry.weight,
      trainingLoad: load,
    );
  }

  Workout _workoutFromDriftWorkoutLog(
    drift.WorkoutLog driftWorkoutLog,
    List<Set> sets,
  ) {
    return Workout(
      id: driftWorkoutLog.id,
      exerciseId: driftWorkoutLog.exerciseId,
      date: driftWorkoutLog.date.toLocal(),
      sets: sets,
      totalTrainingLoad: driftWorkoutLog.totalTrainingLoad,
    );
  }

  bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<drift.WorkoutLog?> _findTodaysWorkout(String routineExerciseId) async {
    final workoutLogs = await _local.workoutLogsForExercise(routineExerciseId);
    final nowLocal = DateTime.now();
    drift.WorkoutLog? best;
    for (final workoutLog in workoutLogs) {
      final local = workoutLog.date.toLocal();
      if (_isSameLocalCalendarDay(local, nowLocal)) {
        if (best == null || workoutLog.date.isAfter(best.date)) {
          best = workoutLog;
        }
      }
    }
    return best;
  }

  Future<void> _deleteEmptyWorkout(String workoutId) async {
    await _local.deleteSetEntriesForWorkout(workoutId);
    await _local.deleteWorkoutLog(workoutId);
  }

  /// Today's session only when it already has logged sets; removes empty legacy rows.
  Future<Workout?> findTodaysWorkoutWithLoggedData(
    String routineExerciseId,
  ) async {
    final todaysWorkoutLog = await _findTodaysWorkout(routineExerciseId);
    if (todaysWorkoutLog == null) return null;

    final sets = await loadSets(todaysWorkoutLog.id);
    final workout = _workoutFromDriftWorkoutLog(todaysWorkoutLog, sets);
    if (WorkoutMetrics.hasLoggedData(workout)) return workout;

    await _deleteEmptyWorkout(todaysWorkoutLog.id);
    return null;
  }

  /// Creates a workout log on first persist; reuses today's row when it has data.
  Future<String> ensureWorkoutIdForSession({
    required String routineExerciseId,
    String? currentWorkoutId,
  }) async {
    if (currentWorkoutId != null) return currentWorkoutId;

    final existingWorkoutLog = await _findTodaysWorkout(routineExerciseId);
    if (existingWorkoutLog != null) {
      final sets = await loadSets(existingWorkoutLog.id);
      final workout = _workoutFromDriftWorkoutLog(existingWorkoutLog, sets);
      if (WorkoutMetrics.hasLoggedData(workout)) return existingWorkoutLog.id;
      await _deleteEmptyWorkout(existingWorkoutLog.id);
    }

    final id = _uuid.v4();
    await _local.insertWorkoutLog(
      id: id,
      exerciseId: routineExerciseId,
      date: DateTime.now().toUtc(),
    );
    return id;
  }

  Future<List<Set>> loadSets(String workoutId) async {
    final setEntries = await _local.setEntriesForWorkout(workoutId);
    return setEntries.map(_setFromDriftSetEntry).toList();
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
    final workoutLogs = await _local.workoutLogsForExerciseNewestFirst(
      routineExerciseId,
    );
    if (workoutLogs.isEmpty) return [];

    final workouts = <Workout>[];
    for (final workoutLog in workoutLogs) {
      final sets = await loadSets(workoutLog.id);
      final workout = _workoutFromDriftWorkoutLog(workoutLog, sets);
      if (WorkoutMetrics.hasLoggedData(workout)) {
        workouts.add(workout);
      } else {
        await _deleteEmptyWorkout(workoutLog.id);
      }
    }

    workouts.sort((a, b) => a.date.compareTo(b.date));
    if (limit != null && workouts.length > limit) {
      return workouts.sublist(workouts.length - limit);
    }
    return workouts;
  }

  Future<int?> maxTimerHoldSecondsLastDays(
    String routineExerciseId, {
    int days = 30,
  }) async {
    final workoutLogs = await _local.workoutLogsForExercise(routineExerciseId);
    if (workoutLogs.isEmpty) return null;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int? best;
    for (final workoutLog in workoutLogs) {
      if (workoutLog.date.toLocal().isBefore(cutoff)) continue;
      final sets = await loadSets(workoutLog.id);
      for (final set in sets) {
        final duration = set.timeElapsed;
        if (duration == null || duration < 1) continue;
        if (best == null || duration > best) best = duration;
      }
    }
    return best;
  }

  /// Volume change for the newest session with data vs the prior session with data.
  Future<double?> latestSessionTrainingLoadChangePercent(
    String routineExerciseId,
  ) async {
    final workouts = await listWorkouts(routineExerciseId);
    return WorkoutMetrics.latestSessionPercentChange(workouts);
  }

  /// Picks a random past calendar day with no logged session for this exercise.
  Future<DateTime?> _pickRandomOpenPastSessionLocal({
    required String routineExerciseId,
    int maxDaysAgo = 90,
  }) async {
    final random = Random();
    final nowLocal = DateTime.now();
    final todayStart = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

    final existingWorkoutLogs = await _local.workoutLogsForExercise(
      routineExerciseId,
    );

    final occupiedDays = <String>{};
    for (final workoutLog in existingWorkoutLogs) {
      final sets = await loadSets(workoutLog.id);
      final workout = _workoutFromDriftWorkoutLog(workoutLog, sets);
      if (!WorkoutMetrics.hasLoggedData(workout)) continue;
      final local = workoutLog.date.toLocal();
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
    return DateTime(
      pickedDay.year,
      pickedDay.month,
      pickedDay.day,
      8 + random.nextInt(12),
      random.nextInt(60),
    );
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
    final sessionLocal = await _pickRandomOpenPastSessionLocal(
      routineExerciseId: routineExerciseId,
      maxDaysAgo: maxDaysAgo,
    );
    if (sessionLocal == null) return null;

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

  /// Inserts a completed timer session on a random free day in the past.
  /// Returns the local session [DateTime], or null if no day is available.
  /// For dev/testing only.
  Future<DateTime?> insertRandomDummyTimerWorkoutInPast({
    required String routineExerciseId,
    required int setCount,
    int durationHintSeconds = 45,
    int maxDaysAgo = 90,
  }) async {
    final setsToCreate = setCount.clamp(1, 20);
    final random = Random();
    final sessionLocal = await _pickRandomOpenPastSessionLocal(
      routineExerciseId: routineExerciseId,
      maxDaysAgo: maxDaysAgo,
    );
    if (sessionLocal == null) return null;

    final workoutId = _uuid.v4();
    await _local.insertWorkoutLog(
      id: workoutId,
      exerciseId: routineExerciseId,
      date: sessionLocal.toUtc(),
    );

    final persistedSets = <Set>[];
    for (var setNumber = 1; setNumber <= setsToCreate; setNumber++) {
      final durationSeconds = _randomDummyHoldSeconds(
        random,
        durationHintSeconds,
      );
      final entry = Set(setNumber: setNumber, timeElapsed: durationSeconds);
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

  static int _randomDummyHoldSeconds(Random random, int hintSeconds) {
    final center = hintSeconds > 0 ? hintSeconds : 45;
    final minSeconds = (center - 20).clamp(5, 600);
    final maxSeconds = (center + 20).clamp(5, 600);
    return minSeconds + random.nextInt(maxSeconds - minSeconds + 1);
  }
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepository(WorkoutLocalSource(ref.watch(appDatabaseProvider)));
}
