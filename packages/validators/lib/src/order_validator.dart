import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';
import 'package:schemantic/schemantic.dart';

class OrderValidator {
  const OrderValidator._();

  static final _createSchema = OrderCreate.$schema;

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
      mapError: (error, path, type) {
        if (type == ValidationErrorType.requiredPropertyMissing) {
          final details = error.details ?? '';
          if (details.contains('"productId"')) {
            return 'Product ID is required.';
          }
          if (details.contains('"quantity"')) {
            return 'Quantity is required.';
          }
        }

        if (path.contains('source') && type == ValidationErrorType.typeMismatch) {
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
