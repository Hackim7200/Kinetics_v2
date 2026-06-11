import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;

/// Marks rows as deleted without removing them from SQLite (for future sync).
abstract final class SoftDeleteWriter {
  static const syncStatusPending = 'pending';

  static DateTime _touchTimestamp() => DateTime.now().toUtc();

  static Future<void> routine(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.routines)..where(
              (routine) =>
                  routine.id.equals(id) & routine.isDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(
      db.routines,
    )..where((routine) => routine.id.equals(id))).write(
      drift.RoutinesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> routineExercise(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.routineExercises)..where(
              (exercise) =>
                  exercise.id.equals(id) & exercise.isDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(
      db.routineExercises,
    )..where((exercise) => exercise.id.equals(id))).write(
      drift.RoutineExercisesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> circuit(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.circuits)..where(
              (circuit) =>
                  circuit.id.equals(id) & circuit.isDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(
      db.circuits,
    )..where((circuit) => circuit.id.equals(id))).write(
      drift.CircuitsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> circuitExercise(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.circuitExercises)..where(
              (circuitExercise) =>
                  circuitExercise.id.equals(id) &
                  circuitExercise.isDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(
      db.circuitExercises,
    )..where((circuitExercise) => circuitExercise.id.equals(id))).write(
      drift.CircuitExercisesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> workoutLog(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.workoutLogs)
              ..where((log) => log.id.equals(id) & log.isDeleted.equals(false)))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(db.workoutLogs)..where((log) => log.id.equals(id))).write(
      drift.WorkoutLogsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> setEntry(drift.AppDatabase db, String id) async {
    final row =
        await (db.select(db.setEntries)..where(
              (setEntry) =>
                  setEntry.id.equals(id) & setEntry.isDeleted.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) return;

    await (db.update(
      db.setEntries,
    )..where((setEntry) => setEntry.id.equals(id))).write(
      drift.SetEntriesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(_touchTimestamp()),
        syncStatus: const Value(syncStatusPending),
        version: Value(row.version + 1),
      ),
    );
  }

  static Future<void> setEntriesForWorkout(
    drift.AppDatabase db,
    String workoutId,
  ) async {
    final rows =
        await (db.select(db.setEntries)..where(
              (setEntry) =>
                  setEntry.workoutLogId.equals(workoutId) &
                  setEntry.isDeleted.equals(false),
            ))
            .get();
    for (final row in rows) {
      await setEntry(db, row.id);
    }
  }

  static Future<void> workoutLogWithSets(
    drift.AppDatabase db,
    String workoutId,
  ) async {
    await setEntriesForWorkout(db, workoutId);
    await workoutLog(db, workoutId);
  }

  static Future<void> logsForRoutineExercise(
    drift.AppDatabase db,
    String routineExerciseId,
  ) async {
    final logs =
        await (db.select(db.workoutLogs)..where(
              (log) =>
                  log.exerciseId.equals(routineExerciseId) &
                  log.isDeleted.equals(false),
            ))
            .get();
    for (final log in logs) {
      await workoutLogWithSets(db, log.id);
    }
  }

  static Future<void> routineExerciseWithLogs(
    drift.AppDatabase db,
    String routineExerciseId,
  ) async {
    await logsForRoutineExercise(db, routineExerciseId);
    await routineExercise(db, routineExerciseId);
  }

  static Future<void> circuitExercisesForCircuit(
    drift.AppDatabase db,
    String circuitId,
  ) async {
    final circuitExercises =
        await (db.select(db.circuitExercises)..where(
              (circuitExercise) =>
                  circuitExercise.circuitId.equals(circuitId) &
                  circuitExercise.isDeleted.equals(false),
            ))
            .get();
    for (final circuitExercise in circuitExercises) {
      await SoftDeleteWriter.circuitExercise(db, circuitExercise.id);
    }
  }

  static Future<void> circuitWithExercises(
    drift.AppDatabase db,
    String circuitId,
  ) async {
    await circuitExercisesForCircuit(db, circuitId);
    await circuit(db, circuitId);
  }

  static Future<void> routineWithExercisesAndLogs(
    drift.AppDatabase db,
    String routineId,
  ) async {
    final exercises =
        await (db.select(db.routineExercises)..where(
              (exercise) =>
                  exercise.routineId.equals(routineId) &
                  exercise.isDeleted.equals(false),
            ))
            .get();
    for (final exercise in exercises) {
      await logsForRoutineExercise(db, exercise.id);
      await routineExercise(db, exercise.id);
    }
    await routine(db, routineId);
  }
}
