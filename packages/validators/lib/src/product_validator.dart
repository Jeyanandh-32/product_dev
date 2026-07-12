import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_utils.dart';

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
    return validateSchema(
      schema: _createSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
          if (details.contains('"name"')) {
            return 'Name is required.';
          }
          if (details.contains('"categoryId"')) {
            return 'Category ID is required.';
          }
          if (details.contains('"counterId"')) {
            return 'Counter ID is required.';
          }
          if (details.contains('"basePrice"')) {
            return 'Base price is required.';
          }
          if (details.contains('"sellingPrice"')) {
            return 'Selling price is required.';
          }
        }

        if (path.contains('name')) {
          if (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet) {
            return 'Name is required.';
          }
          if (type == ValidationErrorType.maxLengthExceeded) {
            return 'Name must be 255 characters or fewer.';
          }
        }
        if (path.contains('categoryId') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Category ID is required.';
        }
        if (path.contains('counterId') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Counter ID is required.';
        }
        if (path.contains('basePrice')) {
          if (type == ValidationErrorType.typeMismatch) {
            return 'Base price is required.';
          }
          if (type == ValidationErrorType.minimumNotMet) {
            return 'Base price cannot be negative.';
          }
        }
        if (path.contains('sellingPrice')) {
          if (type == ValidationErrorType.typeMismatch) {
            return 'Selling price is required.';
          }
          if (type == ValidationErrorType.minimumNotMet) {
            return 'Selling price cannot be negative.';
          }
        }
        if (path.contains('sku') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'SKU must be 100 characters or fewer.';
        }
        if (path.contains('barcode') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Barcode must be 100 characters or fewer.';
        }
        if (path.contains('description') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Description must be 255 characters or fewer.';
        }
        if (path.contains('imageUrl') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Image URL must be 255 characters or fewer.';
        }
        if (path.contains('taxRate') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Tax rate cannot be negative.';
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
        if (path.contains('name')) {
          if (type == ValidationErrorType.minLengthNotMet ||
              type == ValidationErrorType.typeMismatch) {
            return 'Name cannot be empty.';
          }
          if (type == ValidationErrorType.maxLengthExceeded) {
            return 'Name must be 255 characters or fewer.';
          }
        }
        if (path.contains('sku') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'SKU must be 100 characters or fewer.';
        }
        if (path.contains('barcode') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Barcode must be 100 characters or fewer.';
        }
        if (path.contains('description') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Description must be 255 characters or fewer.';
        }
        if (path.contains('imageUrl') &&
            type == ValidationErrorType.maxLengthExceeded) {
          return 'Image URL must be 255 characters or fewer.';
        }
        if (path.contains('taxRate') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Tax rate cannot be negative.';
        }
        if (path.contains('basePrice') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Base price cannot be negative.';
        }
        if (path.contains('sellingPrice') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Selling price cannot be negative.';
        }
        return null;
      },
    );
  }
}
