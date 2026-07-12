import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class MerchantValidator {
  const MerchantValidator._();

  static Future<String?> register(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantRegister.$schema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
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
        return null;
      },
    );
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: MerchantLogin.$schema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
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
        return null;
      },
    );
  }
}
