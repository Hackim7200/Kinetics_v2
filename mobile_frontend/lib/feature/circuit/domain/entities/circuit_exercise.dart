/// A single exercise station linked to a circuit. Drift-free.
class CircuitExercise {
  final String id;
  final String circuitId;
  final String title;
  final int orderIndex;

  const CircuitExercise({
    required this.id,
    required this.circuitId,
    required this.title,
    required this.orderIndex,
  });
}
