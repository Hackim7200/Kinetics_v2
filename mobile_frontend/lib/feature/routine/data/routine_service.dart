import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Local persistence for [Routine] rows (Drift).
class RoutineService {
  RoutineService(this._db);

  final AppDatabase _db;

  /// Inserts a new routine or updates an existing one (matched by [Routine.id]).
  /// Assigns a UUID when [Routine.id] is empty.
  Future<void> saveRoutine(Routine routine) async {
    final id = routine.id.isEmpty ? _uuid.v4() : routine.id;

    await _db.into(_db.routines).insertOnConflictUpdate(
          RoutinesCompanion(
            id: Value(id),
            title: Value(routine.title),
            description: routine.description != null
                ? Value(routine.description)
                : const Value(null),
          ),
        );
  }

  /// Reactive list of all routines, sorted by title (for dashboard / lists).
  Stream<List<Routine>> watchRoutines() {
    return (_db.select(_db.routines)
          ..orderBy([(r) => OrderingTerm.asc(r.title)]))
        .watch();
  }

  /// Deletes a routine and cascades through its [RoutineExercise] rows,
  /// workout logs, and set entries.
  Future<void> deleteRoutine(Routine routine) async {
    await _db.transaction(() async {
      final routineExercises = await (_db.select(_db.routineExercises)
            ..where((t) => t.routineId.equals(routine.id)))
          .get();

      for (final routineExercise in routineExercises) {
        await _deleteLogsForRoutineExercise(routineExercise.id);
        await (_db.delete(_db.routineExercises)
              ..where((t) => t.id.equals(routineExercise.id)))
            .go();
      }

      await (_db.delete(_db.routines)..where((r) => r.id.equals(routine.id)))
          .go();
    });
  }

  /// Deletes all [WorkoutLog] and [SetEntry] rows for a [RoutineExercise].
  Future<void> _deleteLogsForRoutineExercise(String routineExerciseId) async {
    final logs = await (_db.select(_db.workoutLogs)
          ..where((l) => l.exerciseId.equals(routineExerciseId)))
        .get();

    for (final log in logs) {
      await _deleteSetsForLog(log.id);
      await (_db.delete(_db.workoutLogs)..where((l) => l.id.equals(log.id)))
          .go();
    }
  }

  /// Deletes all [SetEntry] rows for a single workout log.
  Future<void> _deleteSetsForLog(String logId) async {
    await (_db.delete(_db.setEntries)..where((s) => s.workoutLogId.equals(logId)))
        .go();
  }
}
