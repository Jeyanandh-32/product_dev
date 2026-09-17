import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:merchant/utils/phonepe_interop.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Active merchant platform fee summary signal.
final platformFeeSummarySignal =
    asyncSignal<MerchantPlatformFeeSummary?>(const AsyncData(null));

/// Loading state for platform fee payment submission.
final isPayingPlatformFeeSignal = signal<bool>(false);

/// Resets platform fee signals on logout.
void resetPlatformFeeSignals() {
  platformFeeSummarySignal.value = const AsyncData(null);
  isPayingPlatformFeeSignal.value = false;
}

/// Actions for platform fee viewing, payment, and verification.
abstract final class PlatformFeeActions {
  /// Fetches platform fee summary for the logged-in merchant.
  static Future<void> fetchSummary({bool silent = false}) async {
    try {
      final summary = await PlatformFeeClientRepository.getSummary();
      platformFeeSummarySignal.value = AsyncData(summary);
    } on ApiException catch (e) {
      if (!silent) showToast(e.message);
    } catch (_) {
      if (!silent) showToast('Failed to load platform fee summary.');
    }
  }

  /// Verifies pending platform fee settlements with PhonePe.
  static Future<void> verifyPayment({bool silent = false}) async {
    try {
      final summary = await PlatformFeeClientRepository.verifyPayment();
      platformFeeSummarySignal.value = AsyncData(summary);
      if (!silent) {
        showToast(
          'Platform fees payment verified and settled!',
          type: ToastType.success,
        );
      }
    } on ApiException catch (e) {
      if (!silent) showToast(e.message);
    } catch (_) {
      if (!silent) showToast('Payment verification still pending.');
    }
  }

  /// Initiates PhonePe checkout to pay unsettled platform fees.
  static Future<void> payPlatformFees() async {
    if (isPayingPlatformFeeSignal.value) return;
    isPayingPlatformFeeSignal.value = true;

    try {
      final tokenUrl = await PlatformFeeClientRepository.initiatePayment();
      openPhonePeCheckoutModal(
        tokenUrl: tokenUrl,
        onComplete: (status) async {
          isPayingPlatformFeeSignal.value = false;
          if (PhonePeGatewayState.fromJson(status)?.isConcluded ?? false) {
            await verifyPayment();
          } else {
            showToast(
              'Payment cancelled or incomplete.',
              type: ToastType.warning,
            );
          }
        },
      );
    } on ApiException catch (e) {
      isPayingPlatformFeeSignal.value = false;
      showToast(e.message);
    } catch (_) {
      isPayingPlatformFeeSignal.value = false;
      showToast('Failed to initiate platform fee payment.');
    }
  }
}
