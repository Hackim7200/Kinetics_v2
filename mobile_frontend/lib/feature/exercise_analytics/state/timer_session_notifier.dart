import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/repositories/workout_repository.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/validate_timer_set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/state/timer_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_session_notifier.g.dart';

/// Owns live timer session state and coordinates load / log-set / finish.
@riverpod
class TimerSessionNotifier extends _$TimerSessionNotifier {
  static const missingRoutineMessage =
      'Open this exercise from a routine to save timed sets.';

  late String? _routineExerciseId;
  late int _maxSets;

  WorkoutRepository get _workouts => ref.read(workoutRepositoryProvider);

  @override
  TimerSessionState build(String? routineExerciseId, int maxSets) {
    _routineExerciseId = routineExerciseId;
    _maxSets = maxSets;
    if (routineExerciseId != null) {
      Future.microtask(_load);
    }
    return TimerSessionState.initial(maxSets);
  }

  /// Loads personal best and today's saved timed sets.
  Future<void> _load() async {
    final routineExerciseId = _routineExerciseId;
    if (routineExerciseId == null) return;

    state = state.copyWith(sessionReady: false);
    try {
      final maxHold = await _workouts.maxTimerHoldSecondsLastDays(
        routineExerciseId,
        days: 30,
      );
      state = state.copyWith(maxHoldSecondsLast30Days: maxHold);

      final workout = await _workouts.getOrCreateTodaysWorkout(
        routineExerciseId,
      );
      final loaded = await _workouts.loadSets(workout.id);
      var next = state.copyWith(workoutId: workout.id);

      if (loaded.isNotEmpty && next.hasPristineFirstRow) {
        next = next.copyWith(sets: loaded);
      }

      state = next.copyWith(
        workoutFinished: timerSessionLooksComplete(next.sets, _maxSets),
        sessionReady: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Timer session load failed: $error $stackTrace');
      state = state.copyWith(sessionReady: true);
    }
  }

  void setAddingSet(bool value) {
    state = state.copyWith(addingSet: value);
  }

  /// **LOG SET**: save the stopwatch duration on the current row.
  Future<void> logSet(int durationSeconds) async {
    if (durationSeconds < 1) {
      state = state.copyWith(addingSet: false);
      return;
    }

    final workoutId = state.workoutId;
    if (workoutId == null) {
      state = state.copyWith(addingSet: false);
      return;
    }

    try {
      final index = state.sets.length - 1;
      final setNumber = state.sets[index].setNumber;
      final entry = state.sets[index].copyWith(timeElapsed: durationSeconds);
      final saved = await _workouts.persistSet(workoutId, entry);
      final sets = List<Set>.from(state.sets)..[index] = saved;

      if (setNumber < _maxSets) {
        final newRow = await _workouts.persistSet(
          workoutId,
          Set(setNumber: setNumber + 1),
        );
        state = state.copyWith(sets: [...sets, newRow], addingSet: false);
      } else {
        state = state.copyWith(sets: sets, addingSet: false);
      }
    } catch (error, stackTrace) {
      debugPrint('Timer session log set failed: $error $stackTrace');
      state = state.copyWith(addingSet: false);
    }
  }

  /// **FINISH WORKOUT**: persist the last row and mark the session complete.
  Future<void> finish() async {
    if (state.workoutFinished) return;

    final workoutId = state.workoutId;
    if (workoutId == null) {
      state = state.copyWith(workoutFinished: true);
      return;
    }

    try {
      final lastIndex = state.sets.length - 1;
      final saved = await _workouts.persistSet(
        workoutId,
        state.sets[lastIndex],
      );
      final sets = List<Set>.from(state.sets)..[lastIndex] = saved;
      state = state.copyWith(sets: sets, workoutFinished: true);
    } catch (error, stackTrace) {
      debugPrint('Timer session finish failed: $error $stackTrace');
    }
  }
}
