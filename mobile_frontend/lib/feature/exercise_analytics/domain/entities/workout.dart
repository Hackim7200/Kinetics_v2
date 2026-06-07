import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';

/// Domain model for a workout session with its sets (strength or timer). Drift-free.
class Workout {
  final String id;
  final String exerciseId;
  final DateTime date;
  final List<Set> sets;

  /// Persisted session total (strength Σ load or timer Σ seconds).
  final double? totalTrainingLoad;

  const Workout({
    required this.id,
    required this.exerciseId,
    required this.date,
    this.sets = const [],
    this.totalTrainingLoad,
  });
}
