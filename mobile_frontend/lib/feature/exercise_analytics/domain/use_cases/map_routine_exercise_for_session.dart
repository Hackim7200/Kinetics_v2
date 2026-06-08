import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/exercise.dart';

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

int? _parseRepsFromTarget(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final direct = int.tryParse(trimmed);
  if (direct != null) return direct;
  final match = RegExp(r'\d+').firstMatch(trimmed);
  if (match == null) return null;
  return int.tryParse(match.group(0)!);
}

/// Maps a [RoutineExercise] into analytics [Exercise] session context.
Exercise mapRoutineExerciseForSession(
  RoutineExercise routineExercise,
  int listIndex,
) {
  final sets =
      routineExercise.targetSets ?? _defaultSetsForIndex(listIndex);
  var reps = 0;
  if (!routineExercise.isTimer) {
    final parsed = routineExercise.targetReps != null
        ? _parseRepsFromTarget(routineExercise.targetReps!)
        : null;
    reps = parsed ?? _defaultRepsForIndex(listIndex);
  }

  return Exercise(
    routineExerciseId: routineExercise.id,
    name: routineExercise.title,
    type: routineExercise.isTimer ? ExerciseType.timer : ExerciseType.strength,
    sets: sets,
    reps: reps,
    timerTarget: routineExercise.isTimer ? routineExercise.timerTarget : null,
  );
}
