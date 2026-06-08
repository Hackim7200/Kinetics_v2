import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/data/sources/circuit_local_source.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'circuit_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes circuits. Maps Drift rows to drift-free domain entities.
class CircuitRepository {
  CircuitRepository(this._local);

  final CircuitLocalSource _local;

  Circuit _fromRow(drift.Circuit row) {
    return Circuit(
      id: row.id,
      title: row.title,
      order: row.order,
      rest: row.rest,
      rounds: row.rounds,
      countdown: row.countdown,
      stationDuration: row.stationDuration,
    );
  }

  Future<void> saveCircuit(Circuit circuit) async {
    final id = circuit.id.isEmpty ? _uuid.v4() : circuit.id;
    await _local.upsertCircuit(
      id: id,
      title: circuit.title,
      order: circuit.order,
      rest: circuit.rest,
      rounds: circuit.rounds,
      countdown: circuit.countdown,
      stationDuration: circuit.stationDuration,
    );
  }

  Stream<List<Circuit>> watchCircuits() {
    return _local.watchCircuits().map(
          (rows) => rows.map(_fromRow).toList(),
        );
  }

  Future<void> deleteCircuit(Circuit circuit) {
    return _local.deleteCircuitWithExercises(circuit.id);
  }
}

@Riverpod(keepAlive: true)
CircuitRepository circuitRepository(Ref ref) {
  return CircuitRepository(CircuitLocalSource(ref.watch(appDatabaseProvider)));
}
