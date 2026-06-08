import 'package:mobile_frontend/common/utils/training_target_input.dart';

/// Pure validation for add/edit exercise forms.
abstract final class ValidateExerciseForm {
  static String? nameError(String? raw) {
    if ((raw ?? '').trim().isEmpty) return 'Exercise name is required.';
    return null;
  }

  static String? strengthTargetsError({
    required String setsRaw,
    required String repsRaw,
  }) {
    return TrainingTargetInput.validateStrengthTargets(
      setsRaw: setsRaw,
      repsRaw: repsRaw,
    );
  }

  static String? timerSetsError({required String setsRaw}) {
    return TrainingTargetInput.validateTargetSetsOnly(setsRaw: setsRaw);
  }
}
