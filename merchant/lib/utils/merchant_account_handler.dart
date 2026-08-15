import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:signals/signals.dart';
import 'package:validators/validators.dart';

/// Helper class handling profile, password, and notification updates for merchant settings.
class MerchantAccountHandler {
  const MerchantAccountHandler._();

  /// Updates merchant profile information and syncs auth state.
  static Future<bool> saveProfile({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
  }) async {
    try {
      final updatedMerchant = await MerchantRepository.updateMerchant(
        name: name,
        businessName: businessName,
        whatsappNumber: whatsappNumber,
        email: email,
      );
      authSignal.value = AsyncData(updatedMerchant);
      showToast('Profile updated successfully.', type: ToastType.success);
      return true;
    } catch (err) {
      showToast(err is ApiException ? err.message : 'Failed to update profile.');
      return false;
    }
  }

  /// Validates and updates merchant account password.
  static Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty) {
      showToast('Please enter your current password.');
      return false;
    }
    if (newPassword.isEmpty) {
      showToast('Please enter a new password.');
      return false;
    }
    if (!RegExp(ValidationPatterns.password).hasMatch(newPassword)) {
      showToast('Password must be 6+ chars with uppercase, lowercase, and digit.');
      return false;
    }
    if (newPassword != confirmPassword) {
      showToast('New passwords do not match.');
      return false;
    }

    try {
      await MerchantRepository.updateMerchant(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      showToast('Password updated successfully.', type: ToastType.success);
      return true;
    } catch (err) {
      showToast(err is ApiException ? err.message : 'Failed to update password.');
      return false;
    }
  }
}
