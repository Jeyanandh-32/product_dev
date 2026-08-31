import 'package:validators/src/schemas.dart';
import 'package:validators/src/validation_utils.dart';

/// Validator for customer endpoints.
class CustomerValidator {
  const CustomerValidator._();

  static const _pinPatternMessage = 'Must be a 6-digit numeric PIN.';
  static const _phonePatternMessage = 'Mobile Number must be 10 digits.';

  /// Validates customer registration payload.
  static Future<String?> register(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerRegister.$schema,
      json: json,
      rules: [
        Rule.required('name', 'Full Name is required.'),
        Rule.required('mobileNumber', 'Mobile Number is required.'),
        Rule.pattern('mobileNumber', _phonePatternMessage),
        Rule.required('pin', '6-Digit Security PIN is required.'),
        Rule.min('pin', _pinPatternMessage),
        Rule.max('pin', _pinPatternMessage),
        Rule.pattern('pin', _pinPatternMessage),
      ],
    );
  }

  /// Validates customer login payload.
  static Future<String?> login(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerLogin.$schema,
      json: json,
      rules: [
        Rule.required('mobileNumber', 'Mobile Number is required.'),
        Rule.pattern('mobileNumber', _phonePatternMessage),
        Rule.required('pin', '6-Digit Security PIN is required.'),
        Rule.min('pin', _pinPatternMessage),
        Rule.max('pin', _pinPatternMessage),
        Rule.pattern('pin', _pinPatternMessage),
      ],
    );
  }

  /// Validates customer profile update payload.
  static Future<String?> update(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerUpdate.$schema,
      json: json,
    );
  }

  /// Validates recent stores payload.
  static Future<String?> updateRecentStores(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerRecentStoresUpdate.$schema,
      json: json,
      rules: [
        Rule.required('storeId', 'Invalid store id.'),
        Rule.min('storeId', 'Invalid store id.'),
      ],
    );
  }

  /// Validates wallet top-up payload.
  static Future<String?> topUpWallet(Map<String, dynamic> json) async {
    return validateSchema(
      schema: CustomerWalletTopUp.$schema,
      json: json,
      rules: [
        Rule.required('amount', 'Invalid top up amount.'),
        Rule.min('amount', 'Invalid top up amount.'),
        Rule.type('amount', 'Invalid top up amount.'),
        Rule.required('storeId', 'storeId is required for wallet top-up.'),
        Rule.min('storeId', 'storeId is required for wallet top-up.'),
        Rule.type('storeId', 'storeId is required for wallet top-up.'),
      ],
    );
  }
}
