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

bool _isTimerType(String type) => type == 'timer';

/// Maps Drift [RoutineExercise] into the feature [Exercise] for workout UI.
Exercise exerciseForWorkoutDetail(
  drift.RoutineExercise routineExercise,
  int listIndex,
) {
  final isTimer = _isTimerType(routineExercise.type);

  final sets =
      routineExercise.targetSets ?? _defaultSetsForIndex(listIndex);
  int reps = 0;
  if (!isTimer) {
    final parsed = routineExercise.targetReps != null
        ? _parseRepsFromTarget(routineExercise.targetReps!)
        : null;
    reps = parsed ?? _defaultRepsForIndex(listIndex);
  }

  return Exercise(
    id: routineExercise.id,
    name: routineExercise.title,
    type: isTimer ? ExerciseType.timer : ExerciseType.strength,
    sets: sets,
    reps: reps,
    routineExerciseId: routineExercise.id,
    timerTarget: isTimer ? routineExercise.timerTarget : null,
  );
}
