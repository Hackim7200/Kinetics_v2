enum ExerciseType { strength, timer }

/// Session context for analytics screens, derived from a routine exercise slot. Drift-free.
class Exercise {
  final String routineExerciseId;
  final String name;
  final ExerciseType type;
  final int sets;
  final int reps;
  final String? timerTarget;

  const Exercise({
    required this.routineExerciseId,
    required this.name,
    required this.type,
    this.sets = 0,
    this.reps = 0,
    this.timerTarget,
  });

  bool get isStrength => type == ExerciseType.strength;
  bool get isTimer => type == ExerciseType.timer;
}
