import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_patterns.dart';

class TerminalValidator {
  const TerminalValidator._();

  static final _createSchema = S.object(
    properties: {
      'name': S.string(minLength: 1, description: 'Terminal name'),
      'password': S.string(
        minLength: 6,
        pattern: ValidationPatterns.password,
        description: 'Terminal password',
      ),
    },
    required: ['name', 'password'],
  );

  static final _loginSchema = S.object(
    properties: {
      'code': S.string(
        minLength: 12,
        maxLength: 12,
        description: 'Terminal code',
      ),
      'password': S.string(
        minLength: 6,
        pattern: ValidationPatterns.password,
        description: 'Terminal password',
      ),
    },
    required: ['code', 'password'],
  );

  static final _updateSchema = S.object(
    properties: {
      'name': S.string(minLength: 1, description: 'Terminal name'),
      'password': S.string(
        minLength: 6,
        pattern: ValidationPatterns.password,
        description: 'Terminal password',
      ),
      'isActive': S.boolean(description: 'Is active status'),
    },
    minProperties: 1,
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    final errors = await _createSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('name') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Terminal Name is required.';
      }
      if (firstError.path.contains('password')) {
        if (details.contains('Required')) return 'Password is required.';
        if (details.contains('minLength') || details.contains('pattern')) {
          return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
        }
      }
      return details;
    }
    return null;
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    // Normalise fields like code to upper case if passed in json,
    // but the handler trims/uppercases it. We will validate whatever is passed.
    final errors = await _loginSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('code')) {
        if (details.contains('Required')) return 'Terminal Code is required.';
        if (details.contains('minLength') || details.contains('maxLength')) {
          return 'Terminal Code must be exactly 12 characters.';
        }
      }
      if (firstError.path.contains('password')) {
        if (details.contains('Required')) return 'Password is required.';
        if (details.contains('minLength') || details.contains('pattern')) {
          return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
        }
      }
      return details;
    }
    return null;
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    final errors = await _updateSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (details.contains('minProperties')) {
        return 'At least one field (name, password, or isActive) is required to update.';
      }
      if (firstError.path.contains('name') && details.contains('minLength')) {
        return 'Terminal Name cannot be empty.';
      }
      if (firstError.path.contains('password')) {
        if (details.contains('minLength') || details.contains('pattern')) {
          return 'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';
        }
      }
      return details;
    }
    return null;
  }
}
