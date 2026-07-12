import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class CounterValidator {
  const CounterValidator._();

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CounterCreate.$schema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing &&
            (error.details?.contains('"name"') == true)) {
          return 'Name is required.';
        }
        if (path.contains('name') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Name is required.';
        }
        if (path.contains('description') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Description must be 255 characters or fewer.';
        }
        if (path.contains('imageUrl') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Image URL must be 255 characters or fewer.';
        }
        return null;
      },
    );
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: CounterUpdate.$schema,
      json: json,
      mapError: (error, path, type) {
        if (path.contains('name') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Name cannot be empty.';
        }
        if (path.contains('description') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Description must be 255 characters or fewer.';
        }
        if (path.contains('imageUrl') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Image URL must be 255 characters or fewer.';
        }
        return null;
      },
    );
  }
}
