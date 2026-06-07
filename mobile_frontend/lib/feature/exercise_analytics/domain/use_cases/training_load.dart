import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';

/// `weight * reps` when both are in the same valid ranges as the session grid; otherwise null.
double? trainingLoadForStrengthSet(double? weight, int? reps) {
  if (weight == null || weight <= 0 || weight > 999.5) return null;
  if (reps == null ||
      reps < TrainingTargetInput.minReps ||
      reps > TrainingTargetInput.maxReps) {
    return null;
  }
  return weight * reps;
}

/// Per-set metric persisted in [Set.trainingLoad]: strength load or timer seconds.
double? trainingLoadForSet({
  double? weight,
  int? reps,
  int? timeElapsed,
}) {
  final strengthLoad = trainingLoadForStrengthSet(weight, reps);
  if (strengthLoad != null) return strengthLoad;
  if (timeElapsed != null && timeElapsed > 0) return timeElapsed.toDouble();
  return null;
}

/// Sum of per-set training load (stored or derived from set values).
double totalTrainingLoadForSets(Iterable<Set> sets) {
  var total = 0.0;
  for (final setEntry in sets) {
    final load =
        setEntry.trainingLoad ??
        trainingLoadForSet(
          weight: setEntry.weight,
          reps: setEntry.reps,
          timeElapsed: setEntry.timeElapsed,
        );
    if (load != null) {
      total += load;
    }
  }
  return total;
}

/// Longest single hold in a session (timer sets only); null if none logged.
int? maxTimeElapsedInSession(Iterable<Set> sets) {
  int? best;
  for (final setEntry in sets) {
    final seconds = setEntry.timeElapsed;
    if (seconds != null && seconds > 0 && (best == null || seconds > best)) {
      best = seconds;
    }
  }
  return best;
}

/// Sum of logged hold durations for timer sets (seconds).
int totalTimeElapsedForSets(Iterable<Set> sets) {
  var totalSeconds = 0;
  for (final setEntry in sets) {
    final seconds = setEntry.timeElapsed;
    if (seconds != null && seconds > 0) totalSeconds += seconds;
  }
  return totalSeconds;
}

/// Strength Σ load, else timer Σ seconds.
double aggregateMetricForWorkoutSets(List<Set> sets) {
  final hasTimerData = sets.any(
    (setEntry) => setEntry.timeElapsed != null && setEntry.timeElapsed! > 0,
  );
  if (hasTimerData) {
    return totalTimeElapsedForSets(sets).toDouble();
  }
  return totalTrainingLoadForSets(sets);
}
