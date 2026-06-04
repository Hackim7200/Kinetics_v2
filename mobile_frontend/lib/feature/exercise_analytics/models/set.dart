import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database.dart' show SetEntry;

class _Unset {
  const _Unset();
}

/// Distinguishes “omit field” from “set to null” in [Set.copyWith].
const _unset = _Unset();

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

/// Sum of per-set training load (stored or derived from weight × reps).
double totalTrainingLoadForSets(Iterable<Set> sets) {
  var total = 0.0;
  for (final setEntry in sets) {
    final load =
        setEntry.trainingLoad ??
        trainingLoadForStrengthSet(setEntry.weight, setEntry.reps);
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

/// Domain model for a logged set; mirrors Drift [SetEntries].
class Set {
  /// Drift row id; null until first persist.
  final String? id;

  /// Parent [Workout] id; null before persist.
  final String? workoutId;

  final int setNumber;
  final int? reps;
  final int? timeElapsed;
  final double? weight;

  /// weight × reps when complete; mirrored in Drift [trainingLoad].
  final double? trainingLoad;

  const Set({
    required this.setNumber,
    this.id,
    this.workoutId,
    this.reps,
    this.timeElapsed,
    this.weight,
    this.trainingLoad,
  });

  /// Maps a persisted Drift [SetEntry] row to the domain [Set] model.
  factory Set.fromDriftRow(SetEntry row) {
    final load =
        row.trainingLoad ?? trainingLoadForStrengthSet(row.weight, row.reps);
    return Set(
      id: row.id,
      workoutId: row.workoutLogId,
      setNumber: row.setNumber,
      reps: row.reps,
      timeElapsed: row.timeElapsed,
      weight: row.weight,
      trainingLoad: load,
    );
  }

  /// True when strength load or a timer duration has been logged.
  bool get isLogged {
    if (timeElapsed != null && timeElapsed! > 0) return true;
    return trainingLoad != null ||
        trainingLoadForStrengthSet(weight, reps) != null;
  }

  Set copyWith({
    int? setNumber,
    Object? id = _unset,
    Object? workoutId = _unset,
    Object? reps = _unset,
    Object? timeElapsed = _unset,
    Object? weight = _unset,
    Object? trainingLoad = _unset,
  }) {
    return Set(
      setNumber: setNumber ?? this.setNumber,
      id: identical(id, _unset) ? this.id : id as String?,
      workoutId: identical(workoutId, _unset)
          ? this.workoutId
          : workoutId as String?,
      reps: identical(reps, _unset) ? this.reps : reps as int?,
      timeElapsed: identical(timeElapsed, _unset)
          ? this.timeElapsed
          : timeElapsed as int?,
      weight: identical(weight, _unset) ? this.weight : weight as double?,
      trainingLoad: identical(trainingLoad, _unset)
          ? this.trainingLoad
          : trainingLoad as double?,
    );
  }

  /// `mm:ss` for logged timer sets; null when no duration.
  String? get formattedTimeElapsed {
    final seconds = timeElapsed;
    if (seconds == null || seconds < 1) return null;
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }
}
