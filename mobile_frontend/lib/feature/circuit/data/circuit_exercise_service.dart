import 'package:drift/drift.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Circuit ↔ exercise links and circuit-specific exercises (Drift).
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

  Future<Map<String, Exercise>> exerciseMapForIds(Set<String> ids) async {
    if (ids.isEmpty) return {};
    final rows = await (_db.select(_db.exercises)
          ..where((e) => e.id.isIn(ids)))
        .get();
    return {for (final e in rows) e.id: e};
  }

  Future<void> addExerciseToCircuit({
    required String circuitId,
    required String name,
  }) async {
    final links = await linksForCircuit(circuitId);
    final nextOrder = links.isEmpty ? 0 : links.last.orderIndex + 1;
    final exerciseId = _uuid.v4();

    await _db.into(_db.exercises).insert(
          ExercisesCompanion.insert(
            id: exerciseId,
            name: name.trim(),
            type: 'timer',
          ),
        );

    await _db.into(_db.circuitExercises).insert(
          CircuitExercisesCompanion.insert(
            id: _uuid.v4(),
            circuitId: circuitId,
            exerciseId: exerciseId,
            orderIndex: nextOrder,
          ),
        );
  }

  Future<void> removeLink(CircuitExercise link) async {
    await (_db.delete(_db.circuitExercises)..where((t) => t.id.equals(link.id)))
        .go();
  }

  Future<void> updateExerciseInCircuit({
    required Exercise exercise,
    required String name,
  }) async {
    await (_db.update(_db.exercises)..where((e) => e.id.equals(exercise.id))).write(
      ExercisesCompanion(name: Value(name.trim())),
    );
  }

  Future<void> deleteExerciseEntry({
    required CircuitExercise link,
    required Exercise exercise,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.circuitExercises)
            ..where((t) => t.id.equals(link.id)))
          .go();
      await (_db.delete(_db.exercises)..where((e) => e.id.equals(exercise.id)))
          .go();
    });
  }
}
