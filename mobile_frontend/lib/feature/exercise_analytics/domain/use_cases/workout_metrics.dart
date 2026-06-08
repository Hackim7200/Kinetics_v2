import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/training_load.dart';

/// Derived metrics from domain [Workout] and [Set] data.
abstract final class WorkoutMetrics {
  static double workoutTotal(Workout workout) =>
      workout.totalTrainingLoad ?? totalTrainingLoadForSets(workout.sets);

  /// True when at least one set has logged strength load or timer duration.
  static bool hasLoggedData(Workout workout) => workoutTotal(workout) > 0;

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

  /// Change for the newest session with logged volume vs the prior session with data.
  static double? latestSessionPercentChange(List<Workout> workouts) {
    if (workouts.isEmpty) return null;

    final newestFirst = workouts.reversed.toList();
    for (var index = 0; index < newestFirst.length; index++) {
      final currentTotal = workoutTotal(newestFirst[index]);
      if (currentTotal <= 0) continue;

      for (
        var previousIndex = index + 1;
        previousIndex < newestFirst.length;
        previousIndex++
      ) {
        final previousTotal = workoutTotal(newestFirst[previousIndex]);
        if (previousTotal > 0) {
          return trainingLoadChangePercentVsPrevious(
            currentTotal,
            previousTotal,
          );
        }
      }
      return null;
    }
    return null;
  }

  /// e.g. `+12.5`, `-3`, `Stable`, or `—` when unknown.
  static String formatPercentChange(double? percent) {
    if (percent == null) return '—';
    if (percent == 0) return 'Stable';

    final magnitude = percent.abs();
    final magnitudeLabel = magnitude == magnitude.roundToDouble()
        ? magnitude.round().toString()
        : magnitude.toStringAsFixed(1);

    return percent > 0 ? '+$magnitudeLabel' : '-$magnitudeLabel';
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
