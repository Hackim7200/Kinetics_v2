/// Pure validation for create/edit routine forms.
abstract final class ValidateRoutineForm {
  static String? titleError(String? raw) {
    if ((raw ?? '').trim().isEmpty) return 'Routine name is required.';
    return null;
  }
}
