import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/workout_metrics.dart';

/// Chart payload for the progress graph widget — built from history, not persisted.
class ProgressGraphData {
  const ProgressGraphData({
    required this.series,
    required this.xLabels,
    required this.percentChange,
  });

  /// Y-axis values: one session total per workout (oldest → newest).
  final List<double> series;

  /// X-axis labels, e.g. `"6/7"` from each workout date.
  final List<String> xLabels;

  /// Change vs the prior session with data; `null` when unknown.
  final double? percentChange;

  /// Builds chart data from a list of workouts (oldest → newest).
  factory ProgressGraphData.fromWorkouts(List<Workout> workouts) {
    final series = workouts.map(WorkoutMetrics.workoutTotal).toList();
    final xLabels = workouts
        .map((workout) => '${workout.date.month}/${workout.date.day}')
        .toList();
    final percentChange = WorkoutMetrics.latestSessionPercentChange(workouts);

    return ProgressGraphData(
      series: series,
      xLabels: xLabels,
      percentChange: percentChange,
    );
  }
}
