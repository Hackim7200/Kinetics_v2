import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Routine ↔ exercise links, exercises, and related workout history (Drift).
class RoutineExerciseService {
  RoutineExerciseService(this._db);

  final AppDatabase _db;

  /// Watches every [RoutineExercise] row (all routines), ordered by routine then slot.
  Stream<List<RoutineExercise>> watchAllRoutineExerciseLinks() {
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

  /// Builds `routineId → latest workout date` from links and logs (pure, no I/O).
  static Map<String, DateTime> lastPerformedByRoutineId({
    required List<RoutineExercise> links,
    required List<WorkoutLog> logs,
  }) {
    if (links.isEmpty || logs.isEmpty) return {};
    final linkIdToRoutineId = {for (final l in links) l.id: l.routineId};
    final best = <String, DateTime>{};
    for (final log in logs) {
      final routineId = linkIdToRoutineId[log.routineExerciseId];
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

  /// Builds `routineId → number of exercises` from link rows (pure, no I/O).
  static Map<String, int> exerciseCountsByRoutineId(
    List<RoutineExercise> links,
  ) {
    final map = <String, int>{};
    for (final link in links) {
      map.update(link.routineId, (c) => c + 1, ifAbsent: () => 1);
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
  Future<List<RoutineExercise>> linksForRoutine(String routineId) {
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
    final links = await linksForRoutine(routineId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;

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

  /// Removes only the [RoutineExercise] link; leaves [Exercise] and logs intact.
  Future<void> removeLink(RoutineExercise link) async {
    await (_db.delete(_db.routineExercises)..where((t) => t.id.equals(link.id)))
        .go();
  }

  /// Updates [Exercise] name/type and [RoutineExercise] targets for a slot.
  Future<void> updateExerciseInRoutine({
    required Exercise exercise,
    required RoutineExercise link,
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

    await (_db.update(_db.routineExercises)..where((t) => t.id.equals(link.id)))
        .write(
      RoutineExercisesCompanion(
        targetSets: Value(targetSets),
        targetReps: Value(repsForStore),
        timerTarget: Value(timerTargetForStore),
      ),
    );
  }

  /// Deletes the link, its workout logs/set entries, and the [Exercise] row.
  Future<void> deleteExerciseEntry({
    required RoutineExercise link,
    required Exercise exercise,
  }) async {
    await _db.transaction(() async {
      final logs = await (_db.select(_db.workoutLogs)
            ..where((l) => l.routineExerciseId.equals(link.id)))
          .get();

      for (final log in logs) {
        await (_db.delete(_db.setEntries)
              ..where((s) => s.workoutLogId.equals(log.id)))
            .go();
        await (_db.delete(_db.workoutLogs)..where((l) => l.id.equals(log.id)))
            .go();
      }

      await (_db.delete(_db.routineExercises)
            ..where((t) => t.id.equals(link.id)))
          .go();
      await (_db.delete(_db.exercises)..where((e) => e.id.equals(exercise.id)))
          .go();
    });
  }
}
