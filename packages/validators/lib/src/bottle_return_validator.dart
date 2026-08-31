import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for bottle return endpoints.
class BottleReturnValidator {
  const BottleReturnValidator._();

  static const _missingStoreId = 'Missing storeId parameter.';
  static const _missingCouponFields = 'Missing required fields for coupon validation.';
  static const _missingRedeemFields = 'Missing required fields for coupon redemption.';
  static const _missingTokenFields = 'Missing required fields for token generation.';
  static const _missingScanPayload = 'Missing tokenStrings, storeId, or merchantId in payload.';

  /// Validates bottle return store config updates.
  static Future<String?> updateConfig(Map<String, dynamic> json) async {
    return validateSchema(
      schema: BottleReturnConfigUpdate.$schema,
      json: json,
      rules: [
        Rule.required('storeId', _missingStoreId),
        Rule.min('rewardAmountInRupees', 'Reward amount must be greater than 0.'),
      ],
    );
  }

  /// Validates bottle return product status updates.
  static Future<String?> updateProduct(Map<String, dynamic> json) async {
    final error = await validateSchema(
      schema: BottleReturnProductUpdate.$schema,
      json: json,
      rules: [Rule.required('storeId', 'Missing storeId in payload.')],
    );
    if (error != null) return error;

    final productId = json['productId'] as String?;
    final productIds = json['productIds'] as List<dynamic>?;
    if ((productId == null || productId.trim().isEmpty) &&
        (productIds == null || productIds.isEmpty)) {
      return 'Missing productId or productIds in payload.';
    }
    return null;
  }

  /// Validates bottle return credit deduction during checkout.
  static Future<String?> applyCredit(Map<String, dynamic> json) async {
    return validateSchema(
      schema: BottleReturnCreditApply.$schema,
      json: json,
      rules: [
        Rule.required('merchantId', 'Missing or invalid fields for credit application.'),
        Rule.required('storeId', 'Missing or invalid fields for credit application.'),
        Rule.required('customerPhone', 'Valid customer phone number required.'),
        Rule.min('customerPhone', 'Valid customer phone number required.'),
        Rule.required('amount', 'Amount must be greater than 0.'),
        Rule.min('amount', 'Amount must be greater than 0.'),
      ],
    );
  }

  /// Validates physical voucher validation requests.
  static Future<String?> validateCoupon(Map<String, dynamic> json) async {
    return validateSchema(
      schema: BottleReturnCouponValidate.$schema,
      json: json,
      rules: [
        Rule.required('merchantId', _missingCouponFields),
        Rule.required('storeId', _missingCouponFields),
        Rule.required('code', _missingCouponFields),
      ],
    );
  }

  /// Validates physical voucher redemption requests.
  static Future<String?> redeemCoupon(Map<String, dynamic> json) async {
    return validateSchema(
      schema: BottleReturnCouponRedeem.$schema,
      json: json,
      rules: [
        Rule.required('merchantId', _missingRedeemFields),
        Rule.required('storeId', _missingRedeemFields),
        Rule.required('code', _missingRedeemFields),
        Rule.required('orderId', _missingRedeemFields),
      ],
    );
  }

  /// Validates IoT bottle scan return batch.
  static Future<String?> scanReturn(Map<String, dynamic> json) async {
    final error = await validateSchema(
      schema: BottleReturnIotScan.$schema,
      json: json,
      rules: [
        Rule.required('merchantId', _missingScanPayload),
        Rule.required('storeId', _missingScanPayload),
        Rule.required('tokenStrings', _missingScanPayload),
      ],
    );
    if (error != null) return error;

    final tokenStrings = json['tokenStrings'] as List<dynamic>?;
    if (tokenStrings == null || tokenStrings.isEmpty) {
      return 'No token strings provided.';
    }
    return null;
  }

  /// Validates IoT sticker dispense requests.
  static Future<String?> dispenseStickers(Map<String, dynamic> json) async {
    return validateSchema(
      schema: BottleReturnIotDispense.$schema,
      json: json,
      rules: [
        Rule.required('orderReference', 'Missing orderReference in payload.'),
      ],
    );
  }

  /// Validates order bottle token generation requests.
  static Future<String?> generateTokens(Map<String, dynamic> json) async {
    final error = await validateSchema(
      schema: BottleReturnTokensGenerate.$schema,
      json: json,
      rules: [
        Rule.required('merchantId', _missingTokenFields),
        Rule.required('storeId', _missingTokenFields),
        Rule.required('orderId', _missingTokenFields),
        Rule.required('items', _missingTokenFields),
      ],
    );
    if (error != null) return error;

    final items = json['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) {
      return _missingTokenFields;
    }
    return null;
  }
}
