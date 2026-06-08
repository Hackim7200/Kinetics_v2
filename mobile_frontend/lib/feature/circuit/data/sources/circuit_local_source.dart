import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;

/// Raw Drift queries for circuit rows.
class CircuitLocalSource {
  CircuitLocalSource(this._db);

  final drift.AppDatabase _db;

  Future<void> upsertCircuit({
    required String id,
    required String title,
    required String order,
    int? rest,
    int? rounds,
    int? countdown,
    int? stationDuration,
  }) {
    return _db.into(_db.circuits).insertOnConflictUpdate(
          drift.CircuitsCompanion(
            id: Value(id),
            title: Value(title),
            order: Value(order),
            rest: rest != null ? Value(rest) : const Value(null),
            rounds: rounds != null ? Value(rounds) : const Value(null),
            countdown: countdown != null ? Value(countdown) : const Value(null),
            stationDuration: stationDuration != null
                ? Value(stationDuration)
                : const Value(null),
          ),
        );
  }

  Stream<List<drift.Circuit>> watchCircuits() {
    return (_db.select(_db.circuits)
          ..orderBy([(circuit) => OrderingTerm.asc(circuit.title)]))
        .watch();
  }

  Future<void> deleteCircuitById(String circuitId) {
    return (_db.delete(_db.circuits)..where((c) => c.id.equals(circuitId))).go();
  }

  Future<void> deleteExercisesForCircuit(String circuitId) {
    return (_db.delete(_db.circuitExercises)
          ..where((t) => t.circuitId.equals(circuitId)))
        .go();
  }

  Future<void> deleteCircuitWithExercises(String circuitId) {
    return _db.transaction(() async {
      await deleteExercisesForCircuit(circuitId);
      await deleteCircuitById(circuitId);
    });
  }
}
