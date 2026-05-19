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
            name: Value(circuit.name),
            description: circuit.description != null
                ? Value(circuit.description)
                : const Value(null),
            rounds: circuit.rounds != null
                ? Value(circuit.rounds)
                : const Value(null),
            stationDurationSeconds: circuit.stationDurationSeconds != null
                ? Value(circuit.stationDurationSeconds)
                : const Value(null),
            preStartCountdownSeconds: circuit.preStartCountdownSeconds != null
                ? Value(circuit.preStartCountdownSeconds)
                : const Value(null),
            restBetweenRoundsSeconds: circuit.restBetweenRoundsSeconds != null
                ? Value(circuit.restBetweenRoundsSeconds)
                : const Value(null),
            randomizeStationOrder: circuit.randomizeStationOrder != null
                ? Value(circuit.randomizeStationOrder)
                : const Value(null),
          ),
        );
  }

  Stream<List<Circuit>> watchCircuits() {
    return (_db.select(_db.circuits)
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  /// Deletes a circuit and all linked circuit-exercise rows and exercises.
  Future<void> deleteCircuit(Circuit circuit) async {
    await _db.transaction(() async {
      final links = await (_db.select(_db.circuitExercises)
            ..where((t) => t.circuitId.equals(circuit.id)))
          .get();

      for (final link in links) {
        await (_db.delete(_db.circuitExercises)
              ..where((t) => t.id.equals(link.id)))
            .go();
        await (_db.delete(_db.exercises)..where((e) => e.id.equals(link.exerciseId)))
            .go();
      }

      await (_db.delete(_db.circuits)..where((c) => c.id.equals(circuit.id))).go();
    });
  }
}
