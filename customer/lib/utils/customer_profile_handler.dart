import 'package:customer/signals/customer_auth_signal.dart';

/// Helper to validate and execute customer profile updates (name, mobile, security PIN).
class CustomerProfileHandler {
  const CustomerProfileHandler._();

  /// Validates and updates customer name.
  static Future<bool> saveName({
    required String name,
    required void Function(String? error) onError,
  }) async {
    final nameTrimmed = name.trim();
    if (nameTrimmed.isEmpty) {
      onError('Name cannot be empty.');
      return false;
    }

    onError(null);
    return updateCustomerProfile(name: nameTrimmed);
  }

  /// Validates and updates customer mobile number with security PIN confirmation.
  static Future<bool> saveMobile({
    required String mobileNumber,
    required String mobilePin,
    required void Function(String? error) onError,
  }) async {
    final mobileTrimmed = mobileNumber.trim();
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(mobileTrimmed)) {
      onError('Please enter a valid 10-digit mobile number.');
      return false;
    }

    if (mobilePin.isEmpty) {
      onError('Security PIN is required to change mobile number.');
      return false;
    }

    onError(null);
    return updateCustomerProfile(
      mobileNumber: mobileTrimmed,
      currentPin: mobilePin,
    );
  }

  /// Validates and updates customer 6-digit security PIN.
  static Future<bool> savePin({
    required String currentPin,
    required String newPin,
    required String confirmPin,
    required void Function(String? error) onError,
  }) async {
    if (currentPin.isEmpty) {
      onError('Current PIN is required.');
      return false;
    }

    final pinRegex = RegExp(r'^\d{6}$');
    if (!pinRegex.hasMatch(newPin)) {
      onError('New PIN must be exactly 6 digits.');
      return false;
    }

    if (newPin != confirmPin) {
      onError('New PIN and confirm PIN do not match.');
      return false;
    }

    onError(null);
    return updateCustomerProfile(
      currentPin: currentPin,
      pin: newPin,
    );
  }
}
