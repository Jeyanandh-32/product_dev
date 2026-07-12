import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class StockValidator {
  const StockValidator._();

  static final _createSchema = StockCreate.$schema;
  static final _updateSchema = StockUpdate.$schema;

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          if (error.details?.contains('"productId"') == true) {
            return 'Product ID is required.';
          }
          if (error.details?.contains('"storeId"') == true) {
            return 'Store ID is required.';
          }
        }
        if (path.contains('productId') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Product ID is required.';
        }
        if (path.contains('storeId') &&
            (type == ValidationErrorType.typeMismatch ||
                type == ValidationErrorType.minLengthNotMet)) {
          return 'Store ID is required.';
        }
        if (path.contains('quantity') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Quantity cannot be negative.';
        }
        if (path.contains('lowStockThreshold') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Low stock threshold cannot be negative.';
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
      schema: _updateSchema,
      json: json,
      mapError: (error, path, type) {
        if (path.contains('quantity') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Quantity cannot be negative.';
        }
        if (path.contains('lowStockThreshold') &&
            type == ValidationErrorType.minimumNotMet) {
          return 'Low stock threshold cannot be negative.';
        }
        return null;
      },
    );
  }
}
