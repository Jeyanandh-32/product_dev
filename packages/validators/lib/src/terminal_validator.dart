import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for terminal endpoints.
class TerminalValidator {
  const TerminalValidator._();

  static final _createSchema = TerminalCreate.$schema;
  static final _loginSchema = TerminalLogin.$schema;
  static final _updateSchema = TerminalUpdate.$schema;

  static const _passwordComplexityMessage =
      'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.';

  /// Validates terminal creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
      json: json,
      rules: [
        Rule.required('name', 'Terminal Name is required.'),
        Rule.required('password', 'Password is required.'),
        Rule.min('password', _passwordComplexityMessage),
        Rule.pattern('password', _passwordComplexityMessage),
      ],
    );
  }

  /// Validates terminal login payload.
  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _loginSchema,
      json: json,
      rules: [
        Rule.required('code', 'Terminal Code is required.'),
        Rule.max('code', 'Terminal Code must be exactly 12 characters.'),
        Rule.required('password', 'Password is required.'),
        Rule.min('password', _passwordComplexityMessage),
        Rule.pattern('password', _passwordComplexityMessage),
      ],
    );
  }

  /// Validates terminal update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field (name, password, or isActive) is required to update.';
    }
    return validateSchema(
      schema: _updateSchema,
      json: json,
      rules: [
        Rule.min('name', 'Terminal Name cannot be empty.'),
        Rule.type('name', 'Terminal Name cannot be empty.'),
        Rule.min('password', _passwordComplexityMessage),
        Rule.pattern('password', _passwordComplexityMessage),
      ],
    );
  }
}
