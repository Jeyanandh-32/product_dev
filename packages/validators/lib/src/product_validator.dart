import 'package:json_schema_builder/json_schema_builder.dart';

class ProductValidator {
  const ProductValidator._();

  static final _createSchema = S.object(
    properties: {
      'name': S.string(
        minLength: 1,
        maxLength: 255,
        description: 'Product name',
      ),
      'categoryId': S.string(minLength: 1, description: 'Category ID'),
      'counterId': S.string(minLength: 1, description: 'Counter ID'),
      'basePrice': S.integer(minimum: 0, description: 'Base price'),
      'sellingPrice': S.integer(minimum: 0, description: 'Selling price'),
      'sku': S.string(maxLength: 100, description: 'SKU'),
      'barcode': S.string(maxLength: 100, description: 'Barcode'),
      'description': S.string(
        maxLength: 255,
        description: 'Product description',
      ),
      'imageUrl': S.string(maxLength: 255, description: 'Product image URL'),
      'taxRate': S.number(minimum: 0, description: 'Tax rate'),
    },
    required: ['name', 'categoryId', 'counterId', 'basePrice', 'sellingPrice'],
  );

  static final _updateSchema = S.object(
    properties: {
      'name': S.string(
        minLength: 1,
        maxLength: 255,
        description: 'Product name',
      ),
      'categoryId': S.string(minLength: 1, description: 'Category ID'),
      'counterId': S.string(minLength: 1, description: 'Counter ID'),
      'basePrice': S.integer(minimum: 0, description: 'Base price'),
      'sellingPrice': S.integer(minimum: 0, description: 'Selling price'),
      'sku': S.string(maxLength: 100, description: 'SKU'),
      'barcode': S.string(maxLength: 100, description: 'Barcode'),
      'description': S.string(
        maxLength: 255,
        description: 'Product description',
      ),
      'imageUrl': S.string(maxLength: 255, description: 'Product image URL'),
      'taxRate': S.number(minimum: 0, description: 'Tax rate'),
      'isActive': S.boolean(description: 'Is active status'),
    },
    minProperties: 1,
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    final errors = await _createSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('name')) {
        if (details.contains('Required') || details.contains('minLength')) {
          return 'Name is required.';
        }
        if (details.contains('maxLength')) {
          return 'Name must be 255 characters or fewer.';
        }
      }
      if (firstError.path.contains('categoryId') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Category ID is required.';
      }
      if (firstError.path.contains('counterId') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Counter ID is required.';
      }
      if (firstError.path.contains('basePrice')) {
        if (details.contains('Required')) {
          return 'Base price is required.';
        }
        if (details.contains('minimum')) {
          return 'Base price cannot be negative.';
        }
      }
      if (firstError.path.contains('sellingPrice')) {
        if (details.contains('Required')) {
          return 'Selling price is required.';
        }
        if (details.contains('minimum')) {
          return 'Selling price cannot be negative.';
        }
      }
      if (firstError.path.contains('sku') && details.contains('maxLength')) {
        return 'SKU must be 100 characters or fewer.';
      }
      if (firstError.path.contains('barcode') &&
          details.contains('maxLength')) {
        return 'Barcode must be 100 characters or fewer.';
      }
      if (firstError.path.contains('description') &&
          details.contains('maxLength')) {
        return 'Description must be 255 characters or fewer.';
      }
      if (firstError.path.contains('imageUrl') &&
          details.contains('maxLength')) {
        return 'Image URL must be 255 characters or fewer.';
      }
      if (firstError.path.contains('taxRate') && details.contains('minimum')) {
        return 'Tax rate cannot be negative.';
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
      if (firstError.path.contains('name')) {
        if (details.contains('minLength')) {
          return 'Name cannot be empty.';
        }
        if (details.contains('maxLength')) {
          return 'Name must be 255 characters or fewer.';
        }
      }
      if (firstError.path.contains('sku') && details.contains('maxLength')) {
        return 'SKU must be 100 characters or fewer.';
      }
      if (firstError.path.contains('barcode') &&
          details.contains('maxLength')) {
        return 'Barcode must be 100 characters or fewer.';
      }
      if (firstError.path.contains('description') &&
          details.contains('maxLength')) {
        return 'Description must be 255 characters or fewer.';
      }
      if (firstError.path.contains('imageUrl') &&
          details.contains('maxLength')) {
        return 'Image URL must be 255 characters or fewer.';
      }
      if (firstError.path.contains('taxRate') && details.contains('minimum')) {
        return 'Tax rate cannot be negative.';
      }
      if (firstError.path.contains('basePrice') &&
          details.contains('minimum')) {
        return 'Base price cannot be negative.';
      }
      if (firstError.path.contains('sellingPrice') &&
          details.contains('minimum')) {
        return 'Selling price cannot be negative.';
      }
      return details;
    }
    return null;
  }
}
