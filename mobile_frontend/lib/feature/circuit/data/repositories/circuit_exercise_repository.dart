import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/data/sources/circuit_exercise_local_source.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit_exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'circuit_exercise_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes circuit exercise links. Maps Drift rows to domain entities.
class CircuitExerciseRepository {
  CircuitExerciseRepository(this._local);

  final CircuitExerciseLocalSource _local;

  CircuitExercise _fromRow(drift.CircuitExercise row) {
    return CircuitExercise(
      id: row.id,
      circuitId: row.circuitId,
      title: row.title,
      orderIndex: row.orderIndex,
    );
  }

  Stream<List<CircuitExercise>> watchAllLinks() {
    return _local.watchAllLinks().map(
          (rows) => rows.map(_fromRow).toList(),
        );
  }

  Stream<List<CircuitExercise>> watchForCircuit(String circuitId) {
    return _local.watchForCircuit(circuitId).map(
          (rows) => rows.map(_fromRow).toList(),
        );
  }

  Future<List<CircuitExercise>> linksForCircuit(String circuitId) {
    return _local.linksForCircuit(circuitId).then(
          (rows) => rows.map(_fromRow).toList(),
        );
  }

  Future<void> addExerciseToCircuit({
    required String circuitId,
    required String title,
  }) async {
    final links = await linksForCircuit(circuitId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;

    await _local.insertLink(
      id: _uuid.v4(),
      circuitId: circuitId,
      title: title.trim(),
      orderIndex: nextOrder,
    );
  }

  Future<void> updateExerciseInCircuit({
    required CircuitExercise link,
    required String title,
  }) {
    return _local.updateLinkTitle(id: link.id, title: title.trim());
  }

  Future<void> deleteExerciseEntry(CircuitExercise link) {
    return _local.deleteLinkById(link.id);
  }
}

@Riverpod(keepAlive: true)
CircuitExerciseRepository circuitExerciseRepository(Ref ref) {
  return CircuitExerciseRepository(
    CircuitExerciseLocalSource(ref.watch(appDatabaseProvider)),
  );
}
