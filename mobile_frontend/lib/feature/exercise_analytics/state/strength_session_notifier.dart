import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/repositories/workout_repository.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/validate_strength_set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/state/strength_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'strength_session_notifier.g.dart';

/// Owns live strength session state and coordinates load / persist / add / finish.
@riverpod
class StrengthSessionNotifier extends _$StrengthSessionNotifier {
  late String? _routineExerciseId;
  late int _maxSets;

  WorkoutRepository get _workouts => ref.read(workoutRepositoryProvider);

  @override
  StrengthSessionState build(String? routineExerciseId, int maxSets) {
    _routineExerciseId = routineExerciseId;
    _maxSets = maxSets;
    if (routineExerciseId != null) {
      Future.microtask(_load);
    }
    return StrengthSessionState.initial(maxSets);
  }

  /// Loads today's saved sets for this exercise, or starts fresh.
  Future<void> _load() async {
    final routineExerciseId = _routineExerciseId;
    if (routineExerciseId == null) return;

    state = state.copyWith(sessionReady: false);
    try {
      final workout = await _workouts.getOrCreateTodaysWorkout(
        routineExerciseId,
      );
      final loaded = await _workouts.loadSets(workout.id);
      var next = state.copyWith(workoutId: workout.id);

      if (loaded.isNotEmpty && next.hasPristineFirstRow) {
        next = next.copyWith(sets: loaded);
      }

      state = next.copyWith(
        workoutFinished: strengthSessionLooksComplete(next.sets, _maxSets),
        sessionReady: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Strength session load failed: $error $stackTrace');
      state = state.copyWith(sessionReady: true);
    }
  }

  /// Applies an edited row locally, then persists when a workout log exists.
  Future<void> commitRow(int index, Set entry) async {
    final sets = List<Set>.from(state.sets)..[index] = entry;
    state = state.copyWith(sets: sets);

    final workoutId = state.workoutId;
    if (workoutId == null) return;

    try {
      final saved = await _workouts.persistSet(workoutId, entry);
      final persistedSets = List<Set>.from(state.sets)..[index] = saved;
      state = state.copyWith(sets: persistedSets);
    } catch (error, stackTrace) {
      debugPrint('Strength session persist failed: $error $stackTrace');
    }
  }

  /// **ADD SET**: persist the current row, then append a new empty row.
  Future<void> addNextSet() async {
    final workoutId = state.workoutId;
    if (workoutId == null) {
      final nextNumber = state.sets.length + 1;
      state = state.copyWith(
        sets: [
          ...state.sets,
          Set(setNumber: nextNumber),
        ],
      );
      return;
    }

    state = state.copyWith(addingSet: true);
    try {
      final lastIndex = state.sets.length - 1;
      final nextNumber = state.sets.length + 1;
      final savedLast = await _workouts.persistSet(
        workoutId,
        state.sets[lastIndex],
      );
      final sets = List<Set>.from(state.sets)..[lastIndex] = savedLast;
      final newRow = await _workouts.persistSet(
        workoutId,
        Set(setNumber: nextNumber),
      );
      state = state.copyWith(sets: [...sets, newRow], addingSet: false);
    } catch (error, stackTrace) {
      debugPrint('Strength session add set failed: $error $stackTrace');
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
      debugPrint('Strength session finish failed: $error $stackTrace');
    }
  }
}
