import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/training_load.dart';

/// Derived metrics from domain [Workout] and [Set] data.
abstract final class WorkoutMetrics {
  static double workoutTotal(Workout workout) =>
      workout.totalTrainingLoad ?? totalTrainingLoadForSets(workout.sets);

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) {
    if (previousTotal == null || previousTotal <= 0) return null;
    return ((currentTotal - previousTotal) / previousTotal) * 100.0;
  }

  static double? percentChangeBetween(Workout earlier, Workout later) {
    return trainingLoadChangePercentVsPrevious(
      workoutTotal(later),
      workoutTotal(earlier),
    );
  }

  /// Heaviest logged strength set (kg) within the last [days] calendar days.
  static double? maxStrengthWeightKgLastDays(
    List<Workout> workouts, {
    int days = 30,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final cutoff = reference.subtract(Duration(days: days));
    double? best;
    for (final workout in workouts) {
      if (workout.date.isBefore(cutoff)) continue;
      for (final set in workout.sets) {
        if (trainingLoadForStrengthSet(set.weight, set.reps) == null) continue;
        final weight = set.weight!;
        if (best == null || weight > best) best = weight;
      }
    }
    return best;
  }

  /// Longest single hold (seconds) within the last [days] calendar days.
  static int? maxTimerHoldSecondsLastDays(
    List<Workout> workouts, {
    int days = 30,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final cutoff = reference.subtract(Duration(days: days));
    int? best;
    for (final workout in workouts) {
      if (workout.date.isBefore(cutoff)) continue;
      for (final set in workout.sets) {
        final duration = set.timeElapsed;
        if (duration == null || duration < 1) continue;
        if (best == null || duration > best) best = duration;
      }
    }
    return best;
  }

  /// Session training load for today (local calendar day), or `0` if none logged.
  static double todaysTrainingLoad(List<Workout> workouts, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    Workout? todaysWorkout;
    for (final workout in workouts) {
      if (!_isSameLocalCalendarDay(workout.date, reference)) continue;
      if (todaysWorkout == null || workout.date.isAfter(todaysWorkout.date)) {
        todaysWorkout = workout;
      }
    }
    return todaysWorkout == null ? 0 : workoutTotal(todaysWorkout);
  }

  static String formatWeightKg(double? weightKg) {
    if (weightKg == null) return '—';
    return weightKg == weightKg.roundToDouble()
        ? weightKg.toInt().toString()
        : weightKg.toStringAsFixed(1);
  }

  static String formatTrainingLoad(double load) {
    if (load <= 0) return '—';
    return load == load.roundToDouble()
        ? load.toInt().toString()
        : load.toStringAsFixed(1);
  }

  /// `mm:ss` for timer durations; `—` when empty.
  static String formatDurationSeconds(int? seconds) {
    if (seconds == null || seconds < 1) return '—';
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }

  static bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
