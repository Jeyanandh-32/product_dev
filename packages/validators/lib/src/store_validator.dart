import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_utils.dart';

class StoreValidator {
  const StoreValidator._();

  static final _createSchema = S.object(
    properties: {
      'name': S.string(minLength: 1, description: 'Store name'),
      'storeType': S.string(description: 'Store type'),
    },
    required: ['name'],
  );

  static final _updateSchema = S.object(
    properties: {
      'name': S.string(minLength: 1, description: 'Store name'),
      'storeType': S.string(description: 'Store type'),
      'isActive': S.boolean(description: 'Is active status'),
    },
    minProperties: 1,
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
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
    return validateSchema(
      schema: _updateSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.minPropertiesNotMet) {
          return 'At least one field is required to update.';
        }
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
