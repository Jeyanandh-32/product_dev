import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_patterns.dart';

class MerchantValidator {
  const MerchantValidator._();

  static final _registerSchema = S.object(
    properties: {
      'name': S.string(minLength: 1, description: 'Merchant name'),
      'businessName': S.string(minLength: 1, description: 'Business name'),
      'whatsappNumber': S.string(
        pattern: ValidationPatterns.whatsapp,
        description: 'Whatsapp number',
      ),
      'email': S.string(
        pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
        description: 'Email address',
      ),
      'password': S.string(
        pattern: ValidationPatterns.password,
        description: 'Password',
      ),
    },
    required: ['name', 'businessName', 'whatsappNumber', 'email', 'password'],
  );

  static final _loginSchema = S.object(
    properties: {
      'email': S.string(
        pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
        description: 'Email address',
      ),
      'password': S.string(
        pattern: ValidationPatterns.password,
        description: 'Password',
      ),
    },
    required: ['email', 'password'],
  );

  static Future<String?> register(Map<String, dynamic> json) async {
    final errors = await _registerSchema.validate(json.cast<String, Object?>());
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final path = firstError.path;
      final type = firstError.error;

      if (type == ValidationErrorType.requiredPropertyMissing) {
        final details = firstError.details ?? '';
        if (details.contains('"name"')) {
          return 'Name is required.';
        }
        if (details.contains('"businessName"')) {
          return 'Business Name is required.';
        }
        if (details.contains('"whatsappNumber"')) {
          return 'Whatsapp Number is required.';
        }
        if (details.contains('"email"')) {
          return 'Email is required.';
        }
        if (details.contains('"password"')) {
          return 'Password is required.';
        }
      }

      if (path.contains('name') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Name is required.';
      }
      if (path.contains('businessName') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Business Name is required.';
      }
      if (path.contains('whatsappNumber')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Whatsapp Number is required.';
        }
        if (type == ValidationErrorType.patternMismatch) {
          return 'Whatsapp Number must be 10 digits.';
        }
      }
      if (path.contains('email')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Email is required.';
        }
        if (type == ValidationErrorType.patternMismatch) {
          return 'Invalid Email format.';
        }
      }
      if (path.contains('password')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Password is required.';
        }
        if (type == ValidationErrorType.patternMismatch ||
            type == ValidationErrorType.minLengthNotMet) {
          return 'Must be 6+ characters with a number, lowercase, and uppercase.';
        }
      }
      return firstError.details;
    }
    return null;
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    final errors = await _loginSchema.validate(json.cast<String, Object?>());
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final path = firstError.path;
      final type = firstError.error;

      if (type == ValidationErrorType.requiredPropertyMissing) {
        final details = firstError.details ?? '';
        if (details.contains('"email"')) return 'Email is required.';
        if (details.contains('"password"')) return 'Password is required.';
      }

      if (path.contains('email')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Email is required.';
        }
        if (type == ValidationErrorType.patternMismatch) {
          return 'Invalid Email format.';
        }
      }
      if (path.contains('password')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Password is required.';
        }
        if (type == ValidationErrorType.patternMismatch ||
            type == ValidationErrorType.minLengthNotMet) {
          return 'Must be 6+ characters with a number, lowercase, and uppercase.';
        }
      }
      return firstError.details;
    }
    return null;
  }
}
