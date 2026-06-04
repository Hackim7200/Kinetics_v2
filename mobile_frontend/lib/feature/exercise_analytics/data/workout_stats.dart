import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';

/// Derived metrics from persisted workouts and [Set] rows.
abstract final class WorkoutStats {
  static Future<double> _sessionTotal(
    drift.WorkoutLog workout,
    Future<List<Set>> Function(String workoutId) loadSets,
  ) async {
    final stored = workout.totalTrainingLoad;
    if (stored != null) return stored;
    final sets = await loadSets(workout.id);
    return aggregateMetricForWorkoutSets(sets);
  }

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) {
    if (previousTotal == null || previousTotal <= 0) return null;
    return ((currentTotal - previousTotal) / previousTotal) * 100.0;
  }

  /// Strength volume change for the most recent session with data vs the prior one.
  static Future<double?> trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<drift.WorkoutLog> allWorkouts,
    Future<List<Set>> Function(String workoutId) loadSets,
  ) async {
    final ordered =
        allWorkouts.where((w) => w.exerciseId == routineExerciseId).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    for (var index = 0; index < ordered.length; index++) {
      final workout = ordered[index];
      final currentTotal = await _sessionTotal(workout, loadSets);
      if (currentTotal <= 0) continue;

      if (index + 1 < ordered.length) {
        final previousTotal = await _sessionTotal(ordered[index + 1], loadSets);
        if (previousTotal > 0) {
          return trainingLoadChangePercentVsPrevious(
            currentTotal,
            previousTotal,
          );
        }
      }
    }
    return null;
  }
}
