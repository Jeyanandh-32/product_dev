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
    final errors = await _createSchema.validate(json);
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final details = firstError.details ?? '';
      if (firstError.path.contains('productId') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Product ID is required.';
      }
      if (firstError.path.contains('storeId') &&
          (details.contains('Required') || details.contains('minLength'))) {
        return 'Store ID is required.';
      }
      if (firstError.path.contains('quantity') && details.contains('minimum')) {
        return 'Quantity cannot be negative.';
      }
      if (firstError.path.contains('lowStockThreshold') &&
          details.contains('minimum')) {
        return 'Low stock threshold cannot be negative.';
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
      if (firstError.path.contains('quantity') && details.contains('minimum')) {
        return 'Quantity cannot be negative.';
      }
      if (firstError.path.contains('lowStockThreshold') &&
          details.contains('minimum')) {
        return 'Low stock threshold cannot be negative.';
      }
      return details;
    }
    return null;
  }
}
