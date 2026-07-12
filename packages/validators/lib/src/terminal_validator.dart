import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class TerminalValidator {
  const TerminalValidator._();

  static final _createSchema = TerminalCreate.$schema;
  static final _loginSchema = TerminalLogin.$schema;
  static final _updateSchema = TerminalUpdate.$schema;

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
          if (details.contains('"name"')) return 'Terminal Name is required.';
          if (details.contains('"password"')) return 'Password is required.';
        }

        if (path.contains('name') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Terminal Name is required.';
        }
        if (path.contains('password')) {
          if (type == ValidationErrorType.typeMismatch ||
              (type == ValidationErrorType.minLengthNotMet &&
                  (json['password'] == null || json['password'] == ''))) {
            return 'Password is required.';
          }
          if (type == ValidationErrorType.minLengthNotMet ||
              type == ValidationErrorType.patternMismatch) {
            return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
          }
        }
        return null;
      },
    );
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _loginSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
          if (details.contains('"code"')) return 'Terminal Code is required.';
          if (details.contains('"password"')) return 'Password is required.';
        }

        if (path.contains('code')) {
          if (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet) {
            return 'Terminal Code is required.';
          }
          if (type == ValidationErrorType.maxLengthExceeded) {
            return 'Terminal Code must be exactly 12 characters.';
          }
        }
        if (path.contains('password')) {
          if (type == ValidationErrorType.typeMismatch) {
            return 'Password is required.';
          }
          if (type == ValidationErrorType.minLengthNotMet ||
              type == ValidationErrorType.patternMismatch) {
            return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
          }
        }
        return null;
      },
    );
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field (name, password, or isActive) is required to update.';
    }
    return validateSchema(
      schema: _updateSchema,
      json: json,
      mapError: (error, path, type) {
        if (path.contains('name') &&
            (type == ValidationErrorType.minLengthNotMet ||
                type == ValidationErrorType.typeMismatch)) {
          return 'Terminal Name cannot be empty.';
        }
        if (path.contains('password')) {
          if (type == ValidationErrorType.minLengthNotMet ||
              type == ValidationErrorType.patternMismatch) {
            return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
          }
        }
        return null;
      },
    );
  }
}
