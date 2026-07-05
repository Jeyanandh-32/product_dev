import 'package:json_schema_builder/json_schema_builder.dart';

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
    final errors = await _createSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (details.contains('Required property "name" is missing') ||
          (firstError.path.contains('name') && details.contains('minLength'))) {
        return 'Name is required.';
      }
      if (firstError.path.contains('description') &&
          details.contains('maxLength')) {
        return 'Description must be 255 characters or fewer.';
      }
      if (firstError.path.contains('imageUrl') &&
          details.contains('maxLength')) {
        return 'Image URL must be 255 characters or fewer.';
      }
      return details;
    }
    return null;
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    final errors = await _updateSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (details.contains('minProperties')) {
        return 'At least one field is required to update.';
      }
      if (firstError.path.contains('name') && details.contains('minLength')) {
        return 'Name cannot be empty.';
      }
      if (firstError.path.contains('description') &&
          details.contains('maxLength')) {
        return 'Description must be 255 characters or fewer.';
      }
      if (firstError.path.contains('imageUrl') &&
          details.contains('maxLength')) {
        return 'Image URL must be 255 characters or fewer.';
      }
      return details;
    }
    return null;
  }
}
