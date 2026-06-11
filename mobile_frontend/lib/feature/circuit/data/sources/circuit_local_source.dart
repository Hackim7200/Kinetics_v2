import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/soft_delete_writer.dart';

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
    return _db
        .into(_db.circuits)
        .insertOnConflictUpdate(
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
          ..where((circuit) => circuit.isDeleted.equals(false))
          ..orderBy([(circuit) => OrderingTerm.asc(circuit.title)]))
        .watch();
  }

  Future<void> deleteCircuitById(String circuitId) {
    return SoftDeleteWriter.circuit(_db, circuitId);
  }

  Future<void> deleteExercisesForCircuit(String circuitId) {
    return SoftDeleteWriter.circuitExercisesForCircuit(_db, circuitId);
  }

  Future<void> deleteCircuitWithExercises(String circuitId) {
    return _db.transaction(
      () => SoftDeleteWriter.circuitWithExercises(_db, circuitId),
    );
  }
}
