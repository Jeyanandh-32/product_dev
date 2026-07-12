import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:validators/src/validation_utils.dart';

class OrderValidator {
  const OrderValidator._();

  static final _createSchema = S.object(
    properties: {
      'source': S.string(description: 'Order source'),
      'type': S.string(description: 'Order type'),
      'paymentMethod': S.string(description: 'Payment method'),
      'products': S.list(
        items: S.object(
          properties: {
            'productId': S.string(minLength: 1, description: 'Product ID'),
            'quantity': S.integer(minimum: 1, description: 'Quantity'),
          },
          required: ['productId', 'quantity'],
        ),
        minItems: 1,
        description: 'Products list',
      ),
    },
    required: ['products'],
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    return validateSchema(
      schema: _createSchema,
      json: json,
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
          if (details.contains('"products"')) {
            return 'Products list is required.';
          }
          if (details.contains('"productId"')) {
            return 'Product ID is required.';
          }
          if (details.contains('"quantity"')) {
            return 'Quantity is required.';
          }
        }

        if (path.contains('source') &&
            type == ValidationErrorType.typeMismatch) {
          return 'Invalid order source.';
        }
        if (path.contains('type') && type == ValidationErrorType.typeMismatch) {
          return 'Invalid order type.';
        }
        if (path.contains('paymentMethod') &&
            type == ValidationErrorType.typeMismatch) {
          return 'Invalid payment method.';
        }

        if (path.contains('products')) {
          if (type == ValidationErrorType.minItemsNotMet ||
              type == ValidationErrorType.typeMismatch) {
            return 'Products list must contain at least one item.';
          }
          if (path.contains('productId') &&
              (type == ValidationErrorType.typeMismatch ||
                  type == ValidationErrorType.minLengthNotMet)) {
            return 'Invalid Product ID.';
          }
          if (path.contains('quantity') &&
              (type == ValidationErrorType.typeMismatch ||
                  type == ValidationErrorType.minimumNotMet)) {
            return 'Quantity must be a positive integer.';
          }
        }
        return null;
      },
    );
  }
}
