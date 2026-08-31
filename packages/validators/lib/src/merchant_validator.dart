import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for merchant endpoints.
class MerchantValidator {
  const MerchantValidator._();

  static const _passwordComplexityMessage =
      'Must be 6+ characters with a number, lowercase, and uppercase.';

  /// Validates merchant registration payload.
  static Future<String?> register(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantRegister.$schema,
      json: json,
      rules: [
        Rule.required('name', 'Name is required.'),
        Rule.required('businessName', 'Business Name is required.'),
        Rule.required('whatsappNumber', 'Whatsapp Number is required.'),
        Rule.pattern('whatsappNumber', 'Whatsapp Number must be 10 digits.'),
        Rule.required('email', 'Email is required.'),
        Rule.pattern('email', 'Invalid Email format.'),
        Rule.required('password', 'Password is required.'),
        Rule.min('password', _passwordComplexityMessage),
        Rule.pattern('password', _passwordComplexityMessage),
      ],
    );
  }

  /// Validates merchant login payload.
  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantLogin.$schema,
      json: json,
      rules: [
        Rule.required('email', 'Email is required.'),
        Rule.pattern('email', 'Invalid Email format.'),
        Rule.required('password', 'Password is required.'),
        Rule.min('password', _passwordComplexityMessage),
        Rule.pattern('password', _passwordComplexityMessage),
      ],
    );
  }

  /// Validates merchant profile update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantUpdate.$schema,
      json: json,
    );
  }

  /// Validates merchant settings update payload.
  static Future<String?> updateSettings(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantSettingsUpdate.$schema,
      json: json,
    );
  }
}
