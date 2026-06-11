import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/soft_delete_writer.dart';

/// Raw Drift queries for workout logs and their set entries.
///
/// Returns Drift rows only; mapping to domain entities lives in the repository.
class WorkoutLocalSource {
  WorkoutLocalSource(this._db);

  final drift.AppDatabase _db;

  Future<List<drift.WorkoutLog>> workoutLogsForExercise(
    String routineExerciseId,
  ) {
    return (_db.select(_db.workoutLogs)
          ..where(
            (log) =>
                log.exerciseId.equals(routineExerciseId) & log.isDeleted.equals(false),
          ))
        .get();
  }

  Future<List<drift.WorkoutLog>> workoutLogsForExerciseNewestFirst(
    String routineExerciseId,
  ) {
    return (_db.select(_db.workoutLogs)
          ..where(
            (log) =>
                log.exerciseId.equals(routineExerciseId) & log.isDeleted.equals(false),
          )
          ..orderBy([(log) => OrderingTerm.desc(log.date)]))
        .get();
  }

  Future<void> insertWorkoutLog({
    required String id,
    required String exerciseId,
    required DateTime date,
  }) {
    return _db
        .into(_db.workoutLogs)
        .insert(
          drift.WorkoutLogsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            date: date,
          ),
        );
  }

  Future<List<drift.SetEntry>> setEntriesForWorkout(String workoutId) {
    return (_db.select(_db.setEntries)
          ..where(
            (setEntry) =>
                setEntry.workoutLogId.equals(workoutId) &
                setEntry.isDeleted.equals(false),
          )
          ..orderBy([(setEntry) => OrderingTerm.asc(setEntry.setNumber)]))
        .get();
  }

  Future<void> upsertSetEntry({
    required String id,
    required String workoutLogId,
    required int setNumber,
    double? weight,
    int? reps,
    double? trainingLoad,
    int? timeElapsed,
  }) {
    return _db
        .into(_db.setEntries)
        .insertOnConflictUpdate(
          drift.SetEntriesCompanion.insert(
            id: id,
            workoutLogId: workoutLogId,
            setNumber: setNumber,
            weight: Value(weight),
            reps: Value(reps),
            trainingLoad: Value(trainingLoad),
            timeElapsed: Value(timeElapsed),
          ),
        );
  }

  Future<void> updateWorkoutTotalTrainingLoad(String workoutId, double total) {
    return (_db.update(_db.workoutLogs)
          ..where((log) => log.id.equals(workoutId) & log.isDeleted.equals(false)))
        .write(drift.WorkoutLogsCompanion(totalTrainingLoad: Value(total)));
  }

  Future<void> deleteSetEntriesForWorkout(String workoutId) {
    return SoftDeleteWriter.setEntriesForWorkout(_db, workoutId);
  }

  Future<void> deleteWorkoutLog(String workoutId) {
    return SoftDeleteWriter.workoutLogWithSets(_db, workoutId);
  }
}
