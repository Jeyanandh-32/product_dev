import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_utils.dart';

class CategoryValidator {
  const CategoryValidator._();

  static final _createSchema = S.object(
    properties: {
      'name': S.string(
        minLength: 1,
        maxLength: 255,
        description: 'Category name',
      ),
      'description': S.string(
        maxLength: 255,
        description: 'Category description',
      ),
      'imageUrl': S.string(maxLength: 255, description: 'Category image URL'),
    },
    required: ['name'],
  );

  static final _updateSchema = S.object(
    properties: {
      'name': S.string(
        minLength: 1,
        maxLength: 255,
        description: 'Category name',
      ),
      'isActive': S.boolean(description: 'Is active status'),
      'description': S.string(
        maxLength: 255,
        description: 'Category description',
      ),
      'imageUrl': S.string(maxLength: 255, description: 'Category image URL'),
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
