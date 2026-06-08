import 'package:validators/src/validation_patterns.dart';

class TerminalValidator {
  const TerminalValidator._();

  static String? create({String? name, String? password}) {
    if (name == null || name.trim().isEmpty) {
      return 'Terminal Name is required.';
    }

    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }

    if (!RegExp(ValidationPatterns.password).hasMatch(password)) {
      return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
    }

    return null;
  }

  static String? update({String? name, String? password, bool? isActive}) {
    if (name != null && name.trim().isEmpty) {
      return 'Terminal Name cannot be empty.';
    }

    if (password != null && password.isEmpty) {
      return 'Password cannot be empty.';
    }

    if (password != null && !RegExp(ValidationPatterns.password).hasMatch(password)) {
      return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
    }

    if (name == null && password == null && isActive == null) {
      return 'At least one field (name, password, or isActive) is required to update.';
    }

    return null;
  }
}
