import 'package:json_schema_builder/json_schema_builder.dart';

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
    final errors = await _createSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (details.contains('Required property "name" is missing') ||
          details.contains('minLength')) {
        return 'Name is required.';
      }
      return firstError.details;
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
      if (details.contains('minLength')) {
        return 'Name cannot be empty.';
      }
      return firstError.details;
    }
    return null;
  }
}
