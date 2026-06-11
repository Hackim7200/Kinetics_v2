import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/soft_delete_writer.dart';

/// Raw Drift queries for circuit exercise rows.
class CircuitExerciseLocalSource {
  CircuitExerciseLocalSource(this._db);

  final drift.AppDatabase _db;

  Stream<List<drift.CircuitExercise>> watchAllCircuitExercises() {
    return (_db.select(_db.circuitExercises)
          ..where((circuitExercise) => circuitExercise.isDeleted.equals(false))
          ..orderBy([
            (circuitExercise) => OrderingTerm.asc(circuitExercise.circuitId),
            (circuitExercise) => OrderingTerm.asc(circuitExercise.orderIndex),
          ]))
        .watch();
  }

  Stream<List<drift.CircuitExercise>> watchForCircuit(String circuitId) {
    return (_db.select(_db.circuitExercises)
          ..where(
            (circuitExercise) =>
                circuitExercise.circuitId.equals(circuitId) &
                circuitExercise.isDeleted.equals(false),
          )
          ..orderBy([(circuitExercise) => OrderingTerm.asc(circuitExercise.orderIndex)]))
        .watch();
  }

  Future<List<drift.CircuitExercise>> circuitExercisesForCircuit(
    String circuitId,
  ) {
    return (_db.select(_db.circuitExercises)
          ..where(
            (circuitExercise) =>
                circuitExercise.circuitId.equals(circuitId) &
                circuitExercise.isDeleted.equals(false),
          )
          ..orderBy([(circuitExercise) => OrderingTerm.asc(circuitExercise.orderIndex)]))
        .get();
  }

  Future<void> insertCircuitExercise({
    required String id,
    required String circuitId,
    required String title,
    required int orderIndex,
  }) {
    return _db.into(_db.circuitExercises).insert(
          drift.CircuitExercisesCompanion.insert(
            id: id,
            circuitId: circuitId,
            title: title,
            orderIndex: orderIndex,
          ),
        );
  }

  Future<void> updateCircuitExerciseTitle({
    required String id,
    required String title,
  }) {
    return (_db.update(_db.circuitExercises)
          ..where(
            (circuitExercise) =>
                circuitExercise.id.equals(id) & circuitExercise.isDeleted.equals(false),
          ))
        .write(drift.CircuitExercisesCompanion(title: Value(title)));
  }

  Future<void> deleteCircuitExerciseById(String id) {
    return SoftDeleteWriter.circuitExercise(_db, id);
  }
}
