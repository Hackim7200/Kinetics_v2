/// Minimal workout session reference for routine-level metrics.
class ExerciseSessionLog {
  final String routineExerciseId;
  final DateTime date;

  const ExerciseSessionLog({
    required this.routineExerciseId,
    required this.date,
  });
}
