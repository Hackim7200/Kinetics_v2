import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';

/// Weight and reps are within allowed ranges for a logged strength set.
bool strengthSetHasValues(Set setEntry) {
  final weight = setEntry.weight;
  final reps = setEntry.reps;
  if (weight == null || weight <= 0 || weight > 999.5) return false;
  if (reps == null ||
      reps < TrainingTargetInput.minReps ||
      reps > TrainingTargetInput.maxReps) {
    return false;
  }
  return true;
}

/// Every set slot `1..maxSets` has exactly one row with valid weight and reps.
bool strengthSessionLooksComplete(List<Set> sets, int maxSets) {
  for (var setNumber = 1; setNumber <= maxSets; setNumber++) {
    final rowsForSet = sets
        .where((setEntry) => setEntry.setNumber == setNumber)
        .toList();
    if (rowsForSet.length != 1) return false;
    if (!strengthSetHasValues(rowsForSet.single)) return false;
  }
  return true;
}
