import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';

int _defaultSetsForIndex(int listIndex) {
  switch (listIndex % 3) {
    case 0:
      return 4;
    case 1:
      return 3;
    default:
      return 3;
  }
}

int _defaultRepsForIndex(int listIndex) {
  switch (listIndex % 3) {
    case 0:
      return 8;
    case 1:
      return 12;
    default:
      return 6;
  }
}

/// Parses reps from stored text (e.g. "10", "8-12") so detail views get a number.
int? _parseRepsFromTarget(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  final direct = int.tryParse(t);
  if (direct != null) return direct;
  final m = RegExp(r'\d+').firstMatch(t);
  if (m == null) return null;
  return int.tryParse(m.group(0)!);
}

/// Maps Drift exercise + [RoutineExercise] into the feature [Exercise] for workout UI.
Exercise exerciseForWorkoutDetail(
  drift.Exercise? storedExercise,
  drift.RoutineExercise routineExercise,
  int listIndex,
) {
  final isTimer = storedExercise?.type == 'timer';
  final name = storedExercise?.name ?? 'Unknown exercise';

  final sets = routineExercise.targetSets ?? _defaultSetsForIndex(listIndex);
  int reps = 0;
  if (!isTimer) {
    final parsed = routineExercise.targetReps != null
        ? _parseRepsFromTarget(routineExercise.targetReps!)
        : null;
    reps = parsed ?? _defaultRepsForIndex(listIndex);
  }

  final restTime = routineExercise.restSeconds != null
      ? Duration(seconds: routineExercise.restSeconds!)
      : null;

  return Exercise(
    id: storedExercise?.id ?? routineExercise.exerciseId,
    name: name,
    type: isTimer ? ExerciseType.timer : ExerciseType.strength,
    sets: sets,
    reps: reps,
    restTime: restTime,
    routineExerciseId: routineExercise.id,
    timerTarget: isTimer ? routineExercise.timerTarget : null,
  );
}
