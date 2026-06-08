import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;

/// Raw Drift queries for routine rows and cascade deletes.
class RoutineLocalSource {
  RoutineLocalSource(this._db);

  final drift.AppDatabase _db;

  Future<void> upsertRoutine({
    required String id,
    required String title,
    String? description,
  }) {
    return _db.into(_db.routines).insertOnConflictUpdate(
          drift.RoutinesCompanion(
            id: Value(id),
            title: Value(title),
            description: description != null
                ? Value(description)
                : const Value(null),
          ),
        );
  }

  Stream<List<drift.Routine>> watchRoutines() {
    return (_db.select(_db.routines)
          ..orderBy([(routine) => OrderingTerm.asc(routine.title)]))
        .watch();
  }

  Future<void> deleteRoutineById(String routineId) {
    return (_db.delete(_db.routines)..where((routine) => routine.id.equals(routineId)))
        .go();
  }

  Future<void> deleteRoutineWithExercisesAndLogs(String routineId) {
    return _db.transaction(() async {
      final routineExercises = await (_db.select(_db.routineExercises)
            ..where((row) => row.routineId.equals(routineId)))
          .get();

      for (final routineExercise in routineExercises) {
        await _deleteLogsForRoutineExercise(routineExercise.id);
        await (_db.delete(_db.routineExercises)
              ..where((row) => row.id.equals(routineExercise.id)))
            .go();
      }

      await deleteRoutineById(routineId);
    });
  }

  Future<void> _deleteLogsForRoutineExercise(String routineExerciseId) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((log) => log.exerciseId.equals(routineExerciseId)))
        .get();

    for (final log in logs) {
      await (_db.delete(_db.setEntries)
            ..where((setEntry) => setEntry.workoutLogId.equals(log.id)))
          .go();
      await (_db.delete(_db.workoutLogs)..where((row) => row.id.equals(log.id)))
          .go();
    }
  }
}
