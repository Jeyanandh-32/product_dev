import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for category endpoints.
class CategoryValidator {
  const CategoryValidator._();

  /// Validates category creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CategoryCreate.$schema,
      json: json,
      rules: [
        Rule.required('name', 'Name is required.'),
        Rule.max('description', 'Description must be 255 characters or fewer.'),
        Rule.max('imageUrl', 'Image URL must be 255 characters or fewer.'),
      ],
    );
  }

  /// Validates category update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: CategoryUpdate.$schema,
      json: json,
      rules: [
        Rule.min('name', 'Name cannot be empty.'),
        Rule.type('name', 'Name cannot be empty.'),
        Rule.max('description', 'Description must be 255 characters or fewer.'),
        Rule.max('imageUrl', 'Image URL must be 255 characters or fewer.'),
      ],
    );
  }
}
