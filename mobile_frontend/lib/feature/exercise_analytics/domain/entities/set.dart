import 'package:mobile_frontend/common/utils/training_target_input.dart';

class _Unset {
  const _Unset();
}

/// Distinguishes “omit field” from “set to null” in [Set.copyWith].
const _unset = _Unset();

/// Domain model for a logged set (strength or timer). Drift-free.
class Set {
  /// Persisted row id; null until first persist.
  final String? id;

  /// Parent [Workout] id; null before persist.
  final String? workoutId;

  final int setNumber;
  final int? reps;
  final int? timeElapsed;
  final double? weight;

  /// Strength load (weight × reps) or timer hold seconds; mirrored when persisted.
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

  /// True when strength load or a timer duration has been logged.
  bool get isLogged {
    if (timeElapsed != null && timeElapsed! > 0) return true;
    if (trainingLoad != null) return true;
    final currentWeight = weight;
    final currentReps = reps;
    if (currentWeight == null || currentWeight <= 0 || currentWeight > 999.5) {
      return false;
    }
    if (currentReps == null ||
        currentReps < TrainingTargetInput.minReps ||
        currentReps > TrainingTargetInput.maxReps) {
      return false;
    }
    return true;
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
