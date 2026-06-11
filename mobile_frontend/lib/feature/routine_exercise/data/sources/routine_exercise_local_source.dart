import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/soft_delete_writer.dart';

/// Raw Drift queries for routine exercise slots and related workout logs.
class RoutineExerciseLocalSource {
  RoutineExerciseLocalSource(this._db);

  final drift.AppDatabase _db;

  Stream<List<drift.RoutineExercise>> watchAllRoutineExercises() {
    return (_db.select(_db.routineExercises)
          ..where(
            (row) => row.isDeleted.equals(false),
          ) // filter out deleted rows
          ..orderBy([
            (row) => OrderingTerm.asc(row.routineId),
            (row) => OrderingTerm.asc(row.orderIndex),
          ]))
        .watch();
  }

  Stream<List<drift.WorkoutLog>> watchAllWorkoutLogs() {
    return (_db.select(
      _db.workoutLogs,
    )..where((log) => log.isDeleted.equals(false))).watch();
  }

  Stream<List<drift.RoutineExercise>> watchForRoutine(String routineId) {
    return (_db.select(_db.routineExercises)
          ..where(
            (row) =>
                row.routineId.equals(routineId) & row.isDeleted.equals(false),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.orderIndex)]))
        .watch();
  }

  Future<List<drift.RoutineExercise>> routineExercisesForRoutine(
    String routineId,
  ) {
    return (_db.select(_db.routineExercises)
          ..where(
            (row) =>
                row.routineId.equals(routineId) & row.isDeleted.equals(false),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.orderIndex)]))
        .get();
  }

  Future<void> insertRoutineExercise({
    required String id,
    required String routineId,
    required String title,
    required String type,
    required int orderIndex,
    int? targetSets,
    String? targetReps,
    String? timerTarget,
    String? techniqueNote,
  }) {
    return _db
        .into(_db.routineExercises)
        .insert(
          drift.RoutineExercisesCompanion.insert(
            id: id,
            routineId: routineId,
            title: title,
            orderIndex: orderIndex,
            type: type,
            targetSets: Value(targetSets),
            targetReps: Value(targetReps),
            timerTarget: Value(timerTarget),
            techniqueNote: techniqueNote != null && techniqueNote.isNotEmpty
                ? Value(techniqueNote)
                : const Value.absent(),
          ),
        );
  }

  Future<void> updateRoutineExercise({
    required String id,
    required String title,
    required String type,
    int? targetSets,
    String? targetReps,
    String? timerTarget,
  }) {
    return (_db.update(
      _db.routineExercises,
    )..where((row) => row.id.equals(id) & row.isDeleted.equals(false))).write(
      drift.RoutineExercisesCompanion(
        title: Value(title),
        type: Value(type),
        targetSets: Value(targetSets),
        targetReps: Value(targetReps),
        timerTarget: Value(timerTarget),
      ),
    );
  }

  Future<void> deleteRoutineExerciseById(String id) {
    return SoftDeleteWriter.routineExercise(_db, id);
  }

  Future<void> deleteRoutineExerciseWithLogs(String routineExerciseId) {
    return _db.transaction(
      () => SoftDeleteWriter.routineExerciseWithLogs(_db, routineExerciseId),
    );
  }
}
