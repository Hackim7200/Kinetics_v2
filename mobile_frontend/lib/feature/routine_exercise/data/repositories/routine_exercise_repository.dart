import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/routine_exercise/data/sources/routine_exercise_local_source.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/exercise_session_log.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'routine_exercise_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes routine exercises. Maps Drift rows to domain entities.
class RoutineExerciseRepository {
  RoutineExerciseRepository(this._local);

  final RoutineExerciseLocalSource _local;

  RoutineExercise _routineExerciseFromDrift(drift.RoutineExercise driftRoutineExercise) {
    return RoutineExercise(
      id: driftRoutineExercise.id,
      routineId: driftRoutineExercise.routineId,
      title: driftRoutineExercise.title,
      targetSets: driftRoutineExercise.targetSets,
      targetReps: driftRoutineExercise.targetReps,
      techniqueNote: driftRoutineExercise.techniqueNote,
      timerTarget: driftRoutineExercise.timerTarget,
      orderIndex: driftRoutineExercise.orderIndex,
      type: driftRoutineExercise.type,
    );
  }

  ExerciseSessionLog _exerciseSessionLogFromDriftWorkoutLog(
    drift.WorkoutLog driftWorkoutLog,
  ) {
    return ExerciseSessionLog(
      routineExerciseId: driftWorkoutLog.exerciseId,
      date: driftWorkoutLog.date,
    );
  }

  static String _storageTypeForFormType(String formType) {
    return formType == 'timer' ? 'timer' : 'weight';
  }

  Stream<List<RoutineExercise>> watchAllRoutineExercises() {
    return _local.watchAllRoutineExercises().map(
          (driftRoutineExercises) =>
              driftRoutineExercises.map(_routineExerciseFromDrift).toList(),
        );
  }

  Stream<List<ExerciseSessionLog>> watchAllExerciseSessionLogs() {
    return _local.watchAllWorkoutLogs().map(
          (driftWorkoutLogs) => driftWorkoutLogs
              .where((workoutLog) => (workoutLog.totalTrainingLoad ?? 0) > 0)
              .map(_exerciseSessionLogFromDriftWorkoutLog)
              .toList(),
        );
  }

  Stream<List<RoutineExercise>> watchForRoutine(String routineId) {
    return _local.watchForRoutine(routineId).map(
          (driftRoutineExercises) =>
              driftRoutineExercises.map(_routineExerciseFromDrift).toList(),
        );
  }

  Future<void> addExerciseToRoutine({
    required String routineId,
    required String title,
    required String type,
    String? techniqueNote,
    int? targetSets,
    String? targetReps,
    String? timerTarget,
  }) async {
    final routineExercises = await _local.routineExercisesForRoutine(routineId);
    final nextOrder = routineExercises.isEmpty
        ? 0
        : routineExercises.last.orderIndex + 1;
    final storageType = _storageTypeForFormType(type);

    await _local.insertRoutineExercise(
      id: _uuid.v4(),
      routineId: routineId,
      title: title.trim(),
      type: storageType,
      orderIndex: nextOrder,
      targetSets: targetSets,
      targetReps: storageType == 'weight' ? targetReps?.trim() : null,
      timerTarget: storageType == 'timer' ? timerTarget : null,
      techniqueNote: techniqueNote?.trim(),
    );
  }

  Future<void> updateExerciseInRoutine({
    required RoutineExercise routineExercise,
    required String title,
    required String type,
    int? targetSets,
    String? targetReps,
    String? timerTarget,
  }) {
    final storageType = _storageTypeForFormType(type);
    final repsForStore = storageType == 'weight' &&
            targetReps != null &&
            targetReps.trim().isNotEmpty
        ? targetReps.trim()
        : null;

    return _local.updateRoutineExercise(
      id: routineExercise.id,
      title: title.trim(),
      type: storageType,
      targetSets: targetSets,
      targetReps: repsForStore,
      timerTarget: storageType == 'timer' ? timerTarget : null,
    );
  }

  Future<void> deleteRoutineExercise(RoutineExercise routineExercise) {
    return _local.deleteRoutineExerciseWithLogs(routineExercise.id);
  }
}

@Riverpod(keepAlive: true)
RoutineExerciseRepository routineExerciseRepository(Ref ref) {
  return RoutineExerciseRepository(
    RoutineExerciseLocalSource(ref.watch(appDatabaseProvider)),
  );
}
