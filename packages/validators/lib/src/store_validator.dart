import 'package:schemantic/schemantic.dart';
import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

class StoreValidator {
  const StoreValidator._();

  static Future<String?> create(Map<String, dynamic> json) async {
    final error = await validateSchema(
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
        if (path.contains('slug') &&
            type == ValidationErrorType.patternMismatch) {
          return 'Slug must contain only lowercase letters, numbers, and hyphens.';
        }
        return null;
      },
    );
    if (error != null) return error;

    final isOnlineEnabled = json['isOnlineEnabled'] == true;
    final slug = json['slug'] as String?;
    if (isOnlineEnabled && (slug == null || slug.trim().isEmpty)) {
      return 'Store URL slug is required when online ordering is enabled.';
    }

    return null;
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    final error = await validateSchema(
      schema: StoreUpdate.$schema,
      json: json,
      mapError: (error, path, type) {
        if (path.contains('name') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Name cannot be empty.';
        }
        if (path.contains('slug') &&
            type == ValidationErrorType.patternMismatch) {
          return 'Slug must contain only lowercase letters, numbers, and hyphens.';
        }
        return null;
      },
    );
    if (error != null) return error;

    final isOnlineEnabled = json['isOnlineEnabled'] == true;
    final slug = json['slug'] as String?;
    if (isOnlineEnabled && (slug == null || slug.trim().isEmpty)) {
      return 'Store URL slug is required when online ordering is enabled.';
    }

    return null;
  }
}
