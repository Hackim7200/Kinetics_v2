import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Local persistence for [Circuit] rows (Drift).
class CircuitService {
  CircuitService(this._db);

  final AppDatabase _db;

  Future<void> saveCircuit(Circuit circuit) async {
    final id = circuit.id.isEmpty ? _uuid.v4() : circuit.id;

    await _db.into(_db.circuits).insertOnConflictUpdate(
          CircuitsCompanion(
            id: Value(id),
            title: Value(circuit.title),
            order: Value(circuit.order),
            rest: circuit.rest != null ? Value(circuit.rest) : const Value(null),
            rounds:
                circuit.rounds != null ? Value(circuit.rounds) : const Value(null),
            countdown: circuit.countdown != null
                ? Value(circuit.countdown)
                : const Value(null),
            stationDuration: circuit.stationDuration != null
                ? Value(circuit.stationDuration)
                : const Value(null),
          ),
        );
  }

  Stream<List<Circuit>> watchCircuits() {
    return (_db.select(_db.circuits)
          ..orderBy([(c) => OrderingTerm.asc(c.title)]))
        .watch();
  }

  /// Deletes a circuit and all linked circuit-exercise rows.
  Future<void> deleteCircuit(Circuit circuit) async {
    await _db.transaction(() async {
      await (_db.delete(_db.circuitExercises)
            ..where((t) => t.circuitId.equals(circuit.id)))
          .go();
      await (_db.delete(_db.circuits)..where((c) => c.id.equals(circuit.id))).go();
    });
  }
}
