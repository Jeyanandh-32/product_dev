import 'package:json_schema_builder/json_schema_builder.dart';

class StockValidator {
  const StockValidator._();

  static final _createSchema = S.object(
    properties: {
      'productId': S.string(minLength: 1, description: 'Product ID'),
      'storeId': S.string(minLength: 1, description: 'Store ID'),
      'quantity': S.integer(minimum: 0, description: 'Stock quantity'),
      'lowStockThreshold': S.integer(
        minimum: 0,
        description: 'Low stock threshold',
      ),
    },
    required: ['productId', 'storeId'],
  );

  static final _updateSchema = S.object(
    properties: {
      'quantity': S.integer(minimum: 0, description: 'Stock quantity'),
      'lowStockThreshold': S.integer(
        minimum: 0,
        description: 'Low stock threshold',
      ),
      'stockMonitor': S.boolean(description: 'Is stock monitored'),
    },
    minProperties: 1,
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    final errors = await _createSchema.validate(json.cast<String, Object?>());
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final path = firstError.path;
      final type = firstError.error;

      if (type == ValidationErrorType.requiredPropertyMissing) {
        if (firstError.details?.contains('"productId"') == true) {
          return 'Product ID is required.';
        }
        if (firstError.details?.contains('"storeId"') == true) {
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
      return firstError.details;
    }
    return null;
  }

  static Future<String?> update(Map<String, dynamic> json) async {
    final errors = await _updateSchema.validate(json.cast<String, Object?>());
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final path = firstError.path;
      final type = firstError.error;

      if (type == ValidationErrorType.minPropertiesNotMet) {
        return 'At least one field is required to update.';
      }
      if (path.contains('quantity') &&
          type == ValidationErrorType.minimumNotMet) {
        return 'Quantity cannot be negative.';
      }
      if (path.contains('lowStockThreshold') &&
          type == ValidationErrorType.minimumNotMet) {
        return 'Low stock threshold cannot be negative.';
      }
      return firstError.details;
    }
    return null;
  }
}
