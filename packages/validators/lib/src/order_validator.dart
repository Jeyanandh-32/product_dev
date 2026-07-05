import 'package:json_schema_builder/json_schema_builder.dart';

class OrderValidator {
  const OrderValidator._();

  static final _createSchema = S.object(
    properties: {
      'merchantId': S.string(minLength: 1, description: 'Merchant ID'),
      'storeId': S.string(minLength: 1, description: 'Store ID'),
      'orderReference': S.string(
        minLength: 1,
        description: 'Order reference code',
      ),
      'source': S.string(
        minLength: 1,
        description: 'Order source (e.g. terminal)',
      ),
      'type': S.string(
        minLength: 1,
        description: 'Order type (e.g. dine_in, takeaway)',
      ),
      'status': S.string(minLength: 1, description: 'Order status'),
      'paymentStatus': S.string(minLength: 1, description: 'Payment status'),
      'paymentMethod': S.string(minLength: 1, description: 'Payment method'),
      'subtotal': S.integer(minimum: 0, description: 'Order subtotal'),
      'taxTotal': S.integer(minimum: 0, description: 'Order tax total'),
      'grandTotal': S.integer(minimum: 0, description: 'Order grand total'),
      'terminalCode': S.string(minLength: 1, description: 'Terminal code'),
      'items': S.list(
        items: S.object(
          properties: {
            'productId': S.string(minLength: 1, description: 'Product ID'),
            'quantity': S.integer(minimum: 1, description: 'Product quantity'),
            'unitPrice': S.integer(minimum: 0, description: 'Unit price'),
            'taxRate': S.number(minimum: 0, description: 'Tax rate'),
          },
          required: ['productId', 'quantity', 'unitPrice', 'taxRate'],
        ),
        minItems: 1,
        description: 'Order items list',
      ),
    },
    required: [
      'merchantId',
      'storeId',
      'orderReference',
      'source',
      'type',
      'paymentMethod',
      'subtotal',
      'taxTotal',
      'grandTotal',
      'items',
    ],
  );

  static Future<String?> create(Map<String, dynamic> json) async {
    final errors = await _createSchema.validate(json.cast<String, Object?>());
    if (errors.isNotEmpty) {
      final firstError = errors.first;
      final path = firstError.path;
      final type = firstError.error;
      final details = firstError.details ?? '';

      if (type == ValidationErrorType.requiredPropertyMissing) {
        if (details.contains('"merchantId"')) {
          return 'Merchant ID is required.';
        }
        if (details.contains('"storeId"')) {
          return 'Store ID is required.';
        }
        if (details.contains('"orderReference"')) {
          return 'Order reference is required.';
        }
        if (details.contains('"source"')) {
          return 'Source is required.';
        }
        if (details.contains('"type"')) {
          return 'Type is required.';
        }
        if (details.contains('"paymentMethod"')) {
          return 'Payment method is required.';
        }
        if (details.contains('"subtotal"')) {
          return 'Subtotal is required.';
        }
        if (details.contains('"taxTotal"')) {
          return 'Tax total is required.';
        }
        if (details.contains('"grandTotal"')) {
          return 'Grand total is required.';
        }
        if (details.contains('"items"')) {
          return 'At least one order item is required.';
        }
      }

      if (path.contains('merchantId') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Merchant ID is required.';
      }
      if (path.contains('storeId') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Store ID is required.';
      }
      if (path.contains('orderReference') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Order reference is required.';
      }
      if (path.contains('source') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Source is required.';
      }
      if (path.contains('type') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Type is required.';
      }
      if (path.contains('paymentMethod') &&
          (type == ValidationErrorType.typeMismatch ||
              type == ValidationErrorType.minLengthNotMet)) {
        return 'Payment method is required.';
      }
      if (path.contains('subtotal')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Subtotal is required.';
        }
        if (type == ValidationErrorType.minimumNotMet) {
          return 'Subtotal cannot be negative.';
        }
      }
      if (path.contains('taxTotal')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Tax total is required.';
        }
        if (type == ValidationErrorType.minimumNotMet) {
          return 'Tax total cannot be negative.';
        }
      }
      if (path.contains('grandTotal')) {
        if (type == ValidationErrorType.typeMismatch) {
          return 'Grand total is required.';
        }
        if (type == ValidationErrorType.minimumNotMet) {
          return 'Grand total cannot be negative.';
        }
      }

      if (path.contains('items')) {
        if (type == ValidationErrorType.minItemsNotMet) {
          return 'At least one order item is required.';
        }

        if (path.contains('productId')) {
          return 'Product ID is required for each item.';
        }
        if (path.contains('quantity')) {
          if (type == ValidationErrorType.minimumNotMet) {
            return 'Quantity must be greater than 0.';
          }
          return 'Quantity is required for each item.';
        }
        if (path.contains('unitPrice')) {
          if (type == ValidationErrorType.minimumNotMet) {
            return 'Unit price cannot be negative.';
          }
          return 'Unit price is required for each item.';
        }
        if (path.contains('taxRate')) {
          if (type == ValidationErrorType.minimumNotMet) {
            return 'Tax rate cannot be negative.';
          }
          return 'Tax rate is required for each item.';
        }
      }
      return details;
    }
    return null;
  }
}
