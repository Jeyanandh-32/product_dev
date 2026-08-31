import 'package:schemantic/schemantic.dart';
import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for order endpoints.
class OrderValidator {
  const OrderValidator._();

  static final _createSchema = OrderCreate.$schema;

  /// Validates order creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    final products = json['products'];
    if (products == null) {
      return 'Products list is required.';
    }
    if (products is! List || products.isEmpty) {
      return 'Products list must contain at least one item.';
    }

    return validateSchema(
      schema: _createSchema,
      json: json,
      rules: [
        Rule.type('source', 'Invalid order source.'),
        Rule.type('type', 'Invalid order type.'),
        Rule.type('paymentMethod', 'Invalid payment method.'),
        Rule.custom(
          (error, path, type) =>
              type == ValidationErrorType.requiredPropertyMissing &&
              error.details?.contains('"productId"') == true,
          'Product ID is required.',
        ),
        Rule.min('productId', 'Invalid Product ID.'),
        Rule.type('productId', 'Invalid Product ID.'),
        Rule.custom(
          (error, path, type) =>
              type == ValidationErrorType.requiredPropertyMissing &&
              error.details?.contains('"quantity"') == true,
          'Quantity is required.',
        ),
        Rule.min('quantity', 'Quantity must be a positive integer.'),
        Rule.type('quantity', 'Quantity must be a positive integer.'),
      ],
    );
  }

  /// Validates order update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    return validateSchema(
      schema: OrderUpdate.$schema,
      json: json,
    );
  }
}
