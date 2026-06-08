import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;

/// Raw Drift queries for circuit exercise link rows.
class CircuitExerciseLocalSource {
  CircuitExerciseLocalSource(this._db);

  final drift.AppDatabase _db;

  Stream<List<drift.CircuitExercise>> watchAllLinks() {
    return (_db.select(_db.circuitExercises)
          ..orderBy([
            (link) => OrderingTerm.asc(link.circuitId),
            (link) => OrderingTerm.asc(link.orderIndex),
          ]))
        .watch();
  }

  Stream<List<drift.CircuitExercise>> watchForCircuit(String circuitId) {
    return (_db.select(_db.circuitExercises)
          ..where((link) => link.circuitId.equals(circuitId))
          ..orderBy([(link) => OrderingTerm.asc(link.orderIndex)]))
        .watch();
  }

  Future<List<drift.CircuitExercise>> linksForCircuit(String circuitId) {
    return (_db.select(_db.circuitExercises)
          ..where((link) => link.circuitId.equals(circuitId))
          ..orderBy([(link) => OrderingTerm.asc(link.orderIndex)]))
        .get();
  }

  Future<void> insertLink({
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

  Future<void> updateLinkTitle({required String id, required String title}) {
    return (_db.update(_db.circuitExercises)..where((link) => link.id.equals(id)))
        .write(drift.CircuitExercisesCompanion(title: Value(title)));
  }

  Future<void> deleteLinkById(String id) {
    return (_db.delete(_db.circuitExercises)..where((link) => link.id.equals(id)))
        .go();
  }
}
