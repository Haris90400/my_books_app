/// Represents PasswordRuleResult.
class PasswordRuleResult {
  const PasswordRuleResult({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  bool get isValid =>
      hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
}

/// Represents PasswordValidator.
class PasswordValidator {
  const PasswordValidator._();

  static final RegExp _uppercase = RegExp(r'[A-Z]');
  static final RegExp _lowercase = RegExp(r'[a-z]');
  static final RegExp _number = RegExp(r'[0-9]');
  static final RegExp _specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]/\\;`~+=]');

  static PasswordRuleResult validate(String password) {
    return PasswordRuleResult(
      hasMinLength: password.length >= 8,
      hasUppercase: _uppercase.hasMatch(password),
      hasLowercase: _lowercase.hasMatch(password),
      hasNumber: _number.hasMatch(password),
      hasSpecialChar: _specialChar.hasMatch(password),
    );
  }
}
