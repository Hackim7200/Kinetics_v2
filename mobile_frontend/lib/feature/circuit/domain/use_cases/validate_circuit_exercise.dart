/// Pure validation for circuit exercise name fields.
abstract final class ValidateCircuitExercise {
  static String? nameError(String? raw) {
    if ((raw ?? '').trim().isEmpty) return 'Exercise name is required.';
    return null;
  }
}
