import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;

/// Raw Drift queries for workout logs and their set entries.
///
/// Returns Drift rows only; mapping to domain entities lives in the repository.
class WorkoutLocalSource {
  WorkoutLocalSource(this._db);

  final drift.AppDatabase _db;

  Future<List<drift.WorkoutLog>> workoutLogsForExercise(
    String routineExerciseId,
  ) {
    return (_db.select(
      _db.workoutLogs,
    )..where((log) => log.exerciseId.equals(routineExerciseId))).get();
  }

  Future<List<drift.WorkoutLog>> workoutLogsForExerciseNewestFirst(
    String routineExerciseId,
  ) {
    return (_db.select(_db.workoutLogs)
          ..where((log) => log.exerciseId.equals(routineExerciseId))
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
          ..where((setEntry) => setEntry.workoutLogId.equals(workoutId))
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
          ..where((log) => log.id.equals(workoutId)))
        .write(drift.WorkoutLogsCompanion(totalTrainingLoad: Value(total)));
  }
}
