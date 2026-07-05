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
    final errors = await _registerSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('name') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Name is required.';
      }
      if (firstError.path.contains('businessName') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Business Name is required.';
      }
      if (firstError.path.contains('whatsappNumber')) {
        if (details.contains('Required')) {
          return 'Whatsapp Number is required.';
        }
        if (details.contains('pattern')) {
          return 'Whatsapp Number must be 10 digits.';
        }
      }
      if (firstError.path.contains('email')) {
        if (details.contains('Required')) return 'Email is required.';
        if (details.contains('pattern')) return 'Invalid Email format.';
      }
      if (firstError.path.contains('password')) {
        if (details.contains('Required')) return 'Password is required.';
        if (details.contains('pattern') || details.contains('minLength')) {
          return 'Must be 6+ characters with a number, lowercase, and uppercase.';
        }
      }
      return details;
    }
    return null;
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    final errors = await _loginSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('email')) {
        if (details.contains('Required')) return 'Email is required.';
        if (details.contains('pattern')) return 'Invalid Email format.';
      }
      if (firstError.path.contains('password')) {
        if (details.contains('Required')) return 'Password is required.';
        if (details.contains('pattern') || details.contains('minLength')) {
          return 'Must be 6+ characters with a number, lowercase, and uppercase.';
        }
      }
      return details;
    }
    return null;
  }
}
