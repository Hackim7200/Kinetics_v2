import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/soft_delete_writer.dart';

/// Raw Drift queries for routine rows and cascade soft deletes.
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
          ..where((routine) => routine.isDeleted.equals(false))
          ..orderBy([(routine) => OrderingTerm.asc(routine.title)]))
        .watch();
  }

  Future<void> deleteRoutineById(String routineId) {
    return SoftDeleteWriter.routine(_db, routineId);
  }

  Future<void> deleteRoutineWithExercisesAndLogs(String routineId) {
    return _db.transaction(
      () => SoftDeleteWriter.routineWithExercisesAndLogs(_db, routineId),
    );
  }
}
