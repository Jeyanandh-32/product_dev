import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class ProductValidator {
  const ProductValidator._();

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: ProductCreate.$schema,
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
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: ProductUpdate.$schema,
      json: json,
      mapError: (error, path, type) {
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
