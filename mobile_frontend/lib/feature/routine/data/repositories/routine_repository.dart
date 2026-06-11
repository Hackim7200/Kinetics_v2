import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/routine/data/sources/routine_local_source.dart';
import 'package:mobile_frontend/feature/routine/domain/entities/routine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'routine_repository.g.dart';

const _uuid = Uuid();

/// Reads and writes routines. Maps Drift rows to drift-free domain entities.
class RoutineRepository {
  RoutineRepository(this._local);

  final RoutineLocalSource _local;

  Routine _routineFromDrift(drift.Routine driftRoutine) {
    return Routine(
      id: driftRoutine.id,
      title: driftRoutine.title,
      description: driftRoutine.description,
    );
  }

  Future<void> saveRoutine(Routine routine) async {
    final id = routine.id.isEmpty ? _uuid.v4() : routine.id;
    await _local.upsertRoutine(
      id: id,
      title: routine.title,
      description: routine.description,
    );
  }

  Stream<List<Routine>> watchRoutines() {
    return _local.watchRoutines().map(
          (driftRoutines) => driftRoutines.map(_routineFromDrift).toList(),
        );
  }

  Future<void> deleteRoutine(Routine routine) {
    return _local.deleteRoutineWithExercisesAndLogs(routine.id);
  }
}

@Riverpod(keepAlive: true)
RoutineRepository routineRepository(Ref ref) {
  return RoutineRepository(RoutineLocalSource(ref.watch(appDatabaseProvider)));
}
