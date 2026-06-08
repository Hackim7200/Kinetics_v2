/// Pure validation for the optional sign-in form (dummy auth for now).
abstract final class ValidateSignIn {
  static String? emailError(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Enter an email (any text is fine)';
    return null;
  }

  static String? passwordError(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Enter a password (any text is fine)';
    }
    return null;
  }

  static bool isValid({required String email, required String password}) {
    return emailError(email) == null && passwordError(password) == null;
  }
}
