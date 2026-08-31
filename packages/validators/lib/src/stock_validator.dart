import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for stock endpoints.
class StockValidator {
  const StockValidator._();

  static final _createSchema = StockCreate.$schema;
  static final _updateSchema = StockUpdate.$schema;

  /// Validates stock creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
      json: json,
      rules: [
        Rule.required('productId', 'Product ID is required.'),
        Rule.type('productId', 'Product ID is required.'),
        Rule.required('storeId', 'Store ID is required.'),
        Rule.type('storeId', 'Store ID is required.'),
        Rule.min('quantity', 'Quantity cannot be negative.'),
        Rule.min('lowStockThreshold', 'Low stock threshold cannot be negative.'),
      ],
    );
  }

  /// Validates stock update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    return validateSchema(
      schema: _updateSchema,
      json: json,
      rules: [
        Rule.min('quantity', 'Quantity cannot be negative.'),
        Rule.min('lowStockThreshold', 'Low stock threshold cannot be negative.'),
      ],
    );
  }
}
