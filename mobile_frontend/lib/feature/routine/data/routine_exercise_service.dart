import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Routine exercises, exercise definitions, and related workout history (Drift).
class RoutineExerciseService {
  RoutineExerciseService(this._db);

  final AppDatabase _db;

  /// Watches every [RoutineExercise] row (all routines), ordered by routine then slot.
  Stream<List<RoutineExercise>> watchAllRoutineExercises() {
    return (_db.select(_db.routineExercises)
          ..orderBy([
            (t) => OrderingTerm.asc(t.routineId),
            (t) => OrderingTerm.asc(t.orderIndex),
          ]))
        .watch();
  }

  /// Watches all [WorkoutLog] rows (used for “last performed” on the dashboard).
  Stream<List<WorkoutLog>> watchAllWorkoutLogs() {
    return _db.select(_db.workoutLogs).watch();
  }

  /// Builds `routineId → latest workout date` from routine exercises and logs (pure, no I/O).
  static Map<String, DateTime> lastPerformedByRoutineId({
    required List<RoutineExercise> routineExercises,
    required List<WorkoutLog> logs,
  }) {
    if (routineExercises.isEmpty || logs.isEmpty) return {};
    final routineExerciseIdToRoutineId = {
      for (final re in routineExercises) re.id: re.routineId,
    };
    final best = <String, DateTime>{};
    for (final log in logs) {
      final routineId = routineExerciseIdToRoutineId[log.routineExerciseId];
      if (routineId == null) continue;
      final at = log.date.toUtc();
      best.update(
        routineId,
        (prev) => at.isAfter(prev) ? at : prev,
        ifAbsent: () => at,
      );
    }
    return best;
  }

  /// Builds `routineId → number of exercises` from [RoutineExercise] rows (pure, no I/O).
  static Map<String, int> exerciseCountsByRoutineId(
    List<RoutineExercise> routineExercises,
  ) {
    final map = <String, int>{};
    for (final routineExercise in routineExercises) {
      map.update(
        routineExercise.routineId,
        (c) => c + 1,
        ifAbsent: () => 1,
      );
    }
    return map;
  }

  /// Watches ordered exercise slots for one routine ([Routine] → [RoutineExercise]).
  Stream<List<RoutineExercise>> watchForRoutine(String routineId) {
    return (_db.select(_db.routineExercises)
          ..where((t) => t.routineId.equals(routineId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .watch();
  }

  /// One-shot fetch of ordered [RoutineExercise] rows for a routine.
  Future<List<RoutineExercise>> routineExercisesForRoutine(String routineId) {
    return (_db.select(_db.routineExercises)
          ..where((t) => t.routineId.equals(routineId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  /// Loads [Exercise] rows for the given ids as a map keyed by id.
  Future<Map<String, Exercise>> exerciseMapForIds(Set<String> ids) async {
    if (ids.isEmpty) return {};
    final rows = await (_db.select(_db.exercises)
          ..where((e) => e.id.isIn(ids)))
        .get();
    return {for (final e in rows) e.id: e};
  }

  /// Creates an [Exercise] and appends a [RoutineExercise] slot at the end of the routine.
  Future<void> addExerciseToRoutine({
    required String routineId,
    required String name,
    required String type,
    String? muscleGroup,
    int? targetSets,
    String? targetReps,
    int? restSeconds,
    String? timerTarget,
  }) async {
    final routineExercises = await routineExercisesForRoutine(routineId);
    final nextOrder = routineExercises.isEmpty
        ? 0
        : routineExercises.last.orderIndex + 1;

    final trimmedMuscle = muscleGroup?.trim();
    final exerciseId = _uuid.v4();

    await _db.into(_db.exercises).insert(
          ExercisesCompanion.insert(
            id: exerciseId,
            name: name.trim(),
            type: type,
            muscleGroup: trimmedMuscle != null && trimmedMuscle.isNotEmpty
                ? Value(trimmedMuscle)
                : const Value.absent(),
          ),
        );

    await _db.into(_db.routineExercises).insert(
          RoutineExercisesCompanion.insert(
            id: _uuid.v4(),
            routineId: routineId,
            exerciseId: exerciseId,
            orderIndex: nextOrder,
            targetSets: Value(targetSets),
            targetReps: Value(targetReps),
            restSeconds: Value(restSeconds),
            timerTarget: Value(type == 'timer' ? timerTarget : null),
          ),
        );
  }

  /// Removes only the [RoutineExercise] row; leaves [Exercise] and logs intact.
  Future<void> removeRoutineExercise(RoutineExercise routineExercise) async {
    await (_db.delete(_db.routineExercises)
          ..where((t) => t.id.equals(routineExercise.id)))
        .go();
  }

  /// Updates [Exercise] name/type and [RoutineExercise] targets for a slot.
  Future<void> updateExerciseInRoutine({
    required Exercise exercise,
    required RoutineExercise routineExercise,
    required String name,
    required String type,
    int? targetSets,
    String? targetReps,
    String? timerTarget,
  }) async {
    await (_db.update(_db.exercises)..where((e) => e.id.equals(exercise.id)))
        .write(
      ExercisesCompanion(
        name: Value(name.trim()),
        type: Value(type),
      ),
    );

    final repsForStore = type == 'strength' &&
            targetReps != null &&
            targetReps.trim().isNotEmpty
        ? targetReps.trim()
        : null;

    final timerTargetForStore = type == 'timer' ? timerTarget : null;

    await (_db.update(_db.routineExercises)
          ..where((t) => t.id.equals(routineExercise.id)))
        .write(
      RoutineExercisesCompanion(
        targetSets: Value(targetSets),
        targetReps: Value(repsForStore),
        timerTarget: Value(timerTargetForStore),
      ),
    );
  }

  /// Deletes the [RoutineExercise], its workout logs/set entries, and the [Exercise] row.
  Future<void> deleteExerciseEntry({
    required RoutineExercise routineExercise,
    required Exercise exercise,
  }) async {
    await _db.transaction(() async {
      final logs = await (_db.select(_db.workoutLogs)
            ..where((l) => l.routineExerciseId.equals(routineExercise.id)))
          .get();

      for (final log in logs) {
        await (_db.delete(_db.setEntries)
              ..where((s) => s.workoutLogId.equals(log.id)))
            .go();
        await (_db.delete(_db.workoutLogs)..where((l) => l.id.equals(log.id)))
            .go();
      }

      await (_db.delete(_db.routineExercises)
            ..where((t) => t.id.equals(routineExercise.id)))
          .go();
      await (_db.delete(_db.exercises)..where((e) => e.id.equals(exercise.id)))
          .go();
    });
  }
}
