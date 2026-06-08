/// A single exercise slot within a routine (`timer` or `weight` in storage). Drift-free.
class RoutineExercise {
  final String id;
  final String routineId;
  final String title;
  final int? targetSets;
  final String? targetReps;
  final String? techniqueNote;
  final String? timerTarget;
  final int orderIndex;
  final String type;

  const RoutineExercise({
    required this.id,
    required this.routineId,
    required this.title,
    required this.orderIndex,
    required this.type,
    this.targetSets,
    this.targetReps,
    this.techniqueNote,
    this.timerTarget,
  });

  bool get isTimer => type == 'timer';
  bool get isStrength => type == 'weight';
}
