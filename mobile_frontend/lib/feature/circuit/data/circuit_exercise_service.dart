import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Circuit station rows (Drift).
class CircuitExerciseService {
  CircuitExerciseService(this._db);

  final AppDatabase _db;

  Stream<List<CircuitExercise>> watchAllCircuitExerciseLinks() {
    return (_db.select(_db.circuitExercises)
          ..orderBy([
            (t) => OrderingTerm.asc(t.circuitId),
            (t) => OrderingTerm.asc(t.orderIndex),
          ]))
        .watch();
  }

  static Map<String, int> exerciseCountsByCircuitId(
    List<CircuitExercise> links,
  ) {
    final map = <String, int>{};
    for (final link in links) {
      map.update(link.circuitId, (c) => c + 1, ifAbsent: () => 1);
    }
    return map;
  }

  Stream<List<CircuitExercise>> watchForCircuit(String circuitId) {
    return (_db.select(_db.circuitExercises)
          ..where((t) => t.circuitId.equals(circuitId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .watch();
  }

  Future<List<CircuitExercise>> linksForCircuit(String circuitId) {
    return (_db.select(_db.circuitExercises)
          ..where((t) => t.circuitId.equals(circuitId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  Future<void> addExerciseToCircuit({
    required String circuitId,
    required String title,
  }) async {
    final links = await linksForCircuit(circuitId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;

    await _db.into(_db.circuitExercises).insert(
          CircuitExercisesCompanion.insert(
            id: _uuid.v4(),
            circuitId: circuitId,
            title: title.trim(),
            orderIndex: nextOrder,
          ),
        );
  }

  Future<void> removeLink(CircuitExercise link) async {
    await (_db.delete(_db.circuitExercises)..where((t) => t.id.equals(link.id)))
        .go();
  }

  Future<void> updateExerciseInCircuit({
    required CircuitExercise link,
    required String title,
  }) async {
    await (_db.update(_db.circuitExercises)..where((t) => t.id.equals(link.id)))
        .write(
      CircuitExercisesCompanion(title: Value(title.trim())),
    );
  }

  Future<void> deleteExerciseEntry(CircuitExercise link) async {
    await (_db.delete(_db.circuitExercises)..where((t) => t.id.equals(link.id)))
        .go();
  }
}
