import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/data/sources/circuit_exercise_local_source.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit_exercise.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'circuit_exercise_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes circuit exercise rows. Maps Drift rows to domain entities.
class CircuitExerciseRepository {
  CircuitExerciseRepository(this._local);

  final CircuitExerciseLocalSource _local;

  CircuitExercise _circuitExerciseFromDrift(
    drift.CircuitExercise driftCircuitExercise,
  ) {
    return CircuitExercise(
      id: driftCircuitExercise.id,
      circuitId: driftCircuitExercise.circuitId,
      title: driftCircuitExercise.title,
      orderIndex: driftCircuitExercise.orderIndex,
    );
  }

  Stream<List<CircuitExercise>> watchAllCircuitExercises() {
    return _local.watchAllCircuitExercises().map(
      (driftCircuitExercises) =>
          driftCircuitExercises.map(_circuitExerciseFromDrift).toList(),
    );
  }

  Stream<List<CircuitExercise>> watchForCircuit(String circuitId) {
    return _local.watchForCircuit(circuitId).map(
      (driftCircuitExercises) =>
          driftCircuitExercises.map(_circuitExerciseFromDrift).toList(),
    );
  }

  Future<List<CircuitExercise>> circuitExercisesForCircuit(String circuitId) {
    return _local.circuitExercisesForCircuit(circuitId).then(
      (driftCircuitExercises) =>
          driftCircuitExercises.map(_circuitExerciseFromDrift).toList(),
    );
  }

  Future<void> addExerciseToCircuit({
    required String circuitId,
    required String title,
  }) async {
    final circuitExercises = await circuitExercisesForCircuit(circuitId);
    final nextOrder = circuitExercises.isEmpty
        ? 0
        : circuitExercises.last.orderIndex + 1;

    await _local.insertCircuitExercise(
      id: _uuid.v4(),
      circuitId: circuitId,
      title: title.trim(),
      orderIndex: nextOrder,
    );
  }

  Future<void> updateExerciseInCircuit({
    required CircuitExercise circuitExercise,
    required String title,
  }) {
    return _local.updateCircuitExerciseTitle(
      id: circuitExercise.id,
      title: title.trim(),
    );
  }

  Future<void> deleteCircuitExercise(CircuitExercise circuitExercise) {
    return _local.deleteCircuitExerciseById(circuitExercise.id);
  }
}

@Riverpod(keepAlive: true)
CircuitExerciseRepository circuitExerciseRepository(Ref ref) {
  return CircuitExerciseRepository(
    CircuitExerciseLocalSource(ref.watch(appDatabaseProvider)),
  );
}
