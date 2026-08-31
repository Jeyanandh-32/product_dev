import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for product endpoints.
class ProductValidator {
  const ProductValidator._();

  /// Validates product creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: ProductCreate.$schema,
      json: json,
      rules: [
        Rule.required('name', 'Name is required.'),
        Rule.max('name', 'Name must be 255 characters or fewer.'),
        Rule.required('categoryId', 'Category ID is required.'),
        Rule.type('categoryId', 'Category ID is required.'),
        Rule.required('counterId', 'Counter ID is required.'),
        Rule.type('counterId', 'Counter ID is required.'),
        Rule.required('basePrice', 'Base price is required.'),
        Rule.min('basePrice', 'Base price cannot be negative.'),
        Rule.required('sellingPrice', 'Selling price is required.'),
        Rule.min('sellingPrice', 'Selling price cannot be negative.'),
        Rule.max('sku', 'SKU must be 100 characters or fewer.'),
        Rule.max('barcode', 'Barcode must be 100 characters or fewer.'),
        Rule.max('description', 'Description must be 255 characters or fewer.'),
        Rule.max('imageUrl', 'Image URL must be 255 characters or fewer.'),
        Rule.min('taxRate', 'Tax rate cannot be negative.'),
      ],
    );
  }

  /// Validates product update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: ProductUpdate.$schema,
      json: json,
      rules: [
        Rule.min('name', 'Name cannot be empty.'),
        Rule.type('name', 'Name cannot be empty.'),
        Rule.max('name', 'Name must be 255 characters or fewer.'),
        Rule.max('sku', 'SKU must be 100 characters or fewer.'),
        Rule.max('barcode', 'Barcode must be 100 characters or fewer.'),
        Rule.max('description', 'Description must be 255 characters or fewer.'),
        Rule.max('imageUrl', 'Image URL must be 255 characters or fewer.'),
        Rule.min('taxRate', 'Tax rate cannot be negative.'),
        Rule.min('basePrice', 'Base price cannot be negative.'),
        Rule.min('sellingPrice', 'Selling price cannot be negative.'),
      ],
    );
  }
}
