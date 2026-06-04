import 'dart:math';

import 'set.dart';

/// Domain model for a workout session with its sets (strength or timer).
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

  /// Maps persisted workout fields and [Set] rows to [Workout].
  factory Workout.fromDrift({
    required String id,
    required String exerciseId,
    required DateTime date,
    required List<Set> sets,
    double? totalTrainingLoad,
  }) {
    return Workout(
      id: id,
      exerciseId: exerciseId,
      date: date.toLocal(),
      sets: sets,
      totalTrainingLoad: totalTrainingLoad,
    );
  }

  /// Stored total, or derived from sets (strength load or timer seconds).
  double trainingLoad() {
    double trainingLoad = 0;
    for (final set in sets) {
      if (set.trainingLoad != null) {
        trainingLoad += set.trainingLoad!;
      }
    }
    return trainingLoad;
  }

  double maxWeightSinceLastXWorkouts(int workouts) {
    //max weight in the last e.g 30 workout
    //not complete yet
    double maxWeight = 0;
    for (final set in sets) {
      if (set.weight != null) {
        maxWeight = max(maxWeight, set.weight!);
      }
    }
    return maxWeight;
  }
}
