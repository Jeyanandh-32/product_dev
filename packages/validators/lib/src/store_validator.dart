import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class StoreValidator {
  const StoreValidator._();

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: StoreCreate.$schema,
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
        return null;
      },
    );
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: StoreUpdate.$schema,
      json: json,
      mapError: (error, path, type) {
        if (path.contains('name') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Name cannot be empty.';
        }
        return null;
      },
    );
  }
}
