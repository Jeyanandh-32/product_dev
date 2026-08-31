import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for store and subscription endpoints.
class StoreValidator {
  const StoreValidator._();

  static const _slugPatternMessage =
      'Slug must contain only lowercase letters, numbers, and hyphens.';

  /// Validates store creation payload.
  static Future<String?> create(Map<String, dynamic> json) async {
    final error = await validateSchema(
      schema: StoreCreate.$schema,
      json: json,
      rules: [
        Rule.required('name', 'Name is required.'),
        Rule.pattern('slug', _slugPatternMessage),
      ],
    );
    if (error != null) return error;

    final isOnlineEnabled = json['isOnlineEnabled'] == true;
    final slug = json['slug'] as String?;
    if (isOnlineEnabled && (slug == null || slug.trim().isEmpty)) {
      return 'Store URL slug is required when online ordering is enabled.';
    }
    return null;
  }

  /// Validates store update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return 'At least one field is required to update.';
    }
    final error = await validateSchema(
      schema: StoreUpdate.$schema,
      json: json,
      rules: [
        Rule.min('name', 'Name cannot be empty.'),
        Rule.type('name', 'Name cannot be empty.'),
        Rule.pattern('slug', _slugPatternMessage),
      ],
    );
    if (error != null) return error;

    final isOnlineEnabled = json['isOnlineEnabled'] == true;
    final slug = json['slug'] as String?;
    if (isOnlineEnabled && (slug == null || slug.trim().isEmpty)) {
      return 'Store URL slug is required when online ordering is enabled.';
    }
    return null;
  }

  /// Validates store PhonePe gateway configuration payload.
  static Future<String?> updatePhonePeConfig(Map<String, dynamic> json) async {
    return validateSchema(
      schema: StorePhonePeConfigUpdate.$schema,
      json: json,
      rules: [
        Rule.required('clientId', 'clientId is required.'),
        Rule.required('clientSecret', 'clientSecret is required.'),
      ],
    );
  }

  /// Validates store subscription initiation payload.
  static Future<String?> initiateSubscription(Map<String, dynamic> json) async {
    final normalized = {
      ...json,
      if (json.containsKey('plan_code') && !json.containsKey('planCode'))
        'planCode': json['plan_code'],
    };
    return validateSchema(
      schema: StoreSubscriptionInitiate.$schema,
      json: normalized,
      rules: [
        Rule.required('planCode', 'planCode is required'),
      ],
    );
  }

  /// Validates store subscription verification payload.
  static Future<String?> verifySubscription(Map<String, dynamic> json) async {
    final normalized = {
      ...json,
      if (json.containsKey('merchant_transaction_id') &&
          !json.containsKey('merchantTransactionId'))
        'merchantTransactionId': json['merchant_transaction_id'],
      if (json.containsKey('reference') &&
          !json.containsKey('merchantTransactionId'))
        'merchantTransactionId': json['reference'],
    };
    return validateSchema(
      schema: StoreSubscriptionVerify.$schema,
      json: normalized,
      rules: [
        Rule.required('merchantTransactionId', 'merchantTransactionId is required'),
      ],
    );
  }

  /// Validates store subscription renewal payload.
  static Future<String?> renewSubscription(Map<String, dynamic> json) async {
    final normalized = {
      ...json,
      if (json.containsKey('plan_code') && !json.containsKey('planCode'))
        'planCode': json['plan_code'],
      if (json.containsKey('payment_method') &&
          !json.containsKey('paymentMethod'))
        'paymentMethod': json['payment_method'],
    };
    return validateSchema(
      schema: StoreSubscriptionRenew.$schema,
      json: normalized,
      rules: [
        Rule.required('planCode', 'planCode is required'),
      ],
    );
  }
}
