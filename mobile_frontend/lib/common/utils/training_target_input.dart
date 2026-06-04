import 'package:flutter/services.dart';

/// Constraints for routine / exercise target sets & reps entry.
class TrainingTargetInput {
  TrainingTargetInput._();

  static const int minSets = 1;
  static const int maxSets = 12;
  static const int minReps = 1;
  static const int maxReps = 80;

  /// Clamps exercise-configured set count to [minSets]..[maxSets].
  static int clampConfiguredSets(int configuredSets) {
    if (configuredSets < minSets) return minSets;
    if (configuredSets > maxSets) return maxSets;
    return configuredSets;
  }

  /// Digits only; enough digits for max values (12, 80).
  static final List<TextInputFormatter> setsFieldFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxSets.toString().length),
  ];

  static final List<TextInputFormatter> repsFieldFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxReps.toString().length),
  ];

  /// Null when valid; otherwise a short message for [SnackBar].
  static String? validateStrengthTargets({
    required String setsRaw,
    required String repsRaw,
  }) {
    final sets = int.tryParse(setsRaw.trim());
    if (setsRaw.trim().isEmpty || sets == null) {
      return 'Enter target sets (1-$maxSets).';
    }
    if (sets < minSets || sets > maxSets) {
      return 'Target sets must be between $minSets and $maxSets.';
    }
    final reps = int.tryParse(repsRaw.trim());
    if (repsRaw.trim().isEmpty || reps == null) {
      return 'Enter target reps (1-$maxReps).';
    }
    if (reps < minReps || reps > maxReps) {
      return 'Target reps must be between $minReps and $maxReps.';
    }
    return null;
  }

  /// Timer exercises use target sets only (same bounds as strength sets).
  static String? validateTargetSetsOnly({required String setsRaw}) {
    final sets = int.tryParse(setsRaw.trim());
    if (setsRaw.trim().isEmpty || sets == null) {
      return 'Enter target sets (1-$maxSets).';
    }
    if (sets < minSets || sets > maxSets) {
      return 'Target sets must be between $minSets and $maxSets.';
    }
    return null;
  }
}
