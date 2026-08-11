import 'package:schemantic/schemantic.dart';
import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

class CustomerValidator {
  const CustomerValidator._();

  static Future<String?> register(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerRegister.$schema,
      json: json,
      mapError: _mapRegisterError,
    );
  }

  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerLogin.$schema,
      json: json,
      mapError: _mapLoginError,
    );
  }

  static String? _mapRegisterError(
    ValidationError error,
    List<String> path,
    ValidationErrorType type,
  ) {
    if (type == ValidationErrorType.requiredPropertyMissing) {
      final details = error.details ?? '';
      if (details.contains('"name"')) {
        return 'Full Name is required.';
      }
      if (details.contains('"mobileNumber"')) {
        return 'Mobile Number is required.';
      }
      if (details.contains('"pin"')) {
        return '6-Digit Security PIN is required.';
      }
    }

    if (path.contains('name') &&
        (type == ValidationErrorType.typeMismatch ||
            type == ValidationErrorType.minLengthNotMet)) {
      return 'Full Name is required.';
    }
    if (path.contains('mobileNumber')) {
      if (type == ValidationErrorType.typeMismatch) {
        return 'Mobile Number is required.';
      }
      if (type == ValidationErrorType.patternMismatch) {
        return 'Mobile Number must be 10 digits.';
      }
    }
    if (path.contains('pin')) {
      if (type == ValidationErrorType.typeMismatch) {
        return '6-Digit Security PIN is required.';
      }
      if (type == ValidationErrorType.patternMismatch ||
          type == ValidationErrorType.minLengthNotMet ||
          type == ValidationErrorType.maxLengthExceeded) {
        return 'Must be a 6-digit numeric PIN.';
      }
    }

    return null;
  }

  static String? _mapLoginError(
    ValidationError error,
    List<String> path,
    ValidationErrorType type,
  ) {
    if (type == ValidationErrorType.requiredPropertyMissing) {
      final details = error.details ?? '';
      if (details.contains('"mobileNumber"')) {
        return 'Mobile Number is required.';
      }
      if (details.contains('"pin"')) {
        return '6-Digit Security PIN is required.';
      }
    }

    if (path.contains('mobileNumber')) {
      if (type == ValidationErrorType.typeMismatch) {
        return 'Mobile Number is required.';
      }
      if (type == ValidationErrorType.patternMismatch) {
        return 'Mobile Number must be 10 digits.';
      }
    }
    if (path.contains('pin')) {
      if (type == ValidationErrorType.typeMismatch) {
        return '6-Digit Security PIN is required.';
      }
      if (type == ValidationErrorType.patternMismatch ||
          type == ValidationErrorType.minLengthNotMet ||
          type == ValidationErrorType.maxLengthExceeded) {
        return 'Must be a 6-digit numeric PIN.';
      }
    }

    return null;
  }
}
