import 'package:models/models.dart';

/// Helper to build PhonePe PG V2 paymentModeConfig payload.
class PhonePePaymentModeBuilder {
  const PhonePePaymentModeBuilder._();

  /// Constructs the V2 enabled and disabled payment modes list.
  static Map<String, dynamic>? build(StorePhonePeConfig config) {
    final enabledModes = <Map<String, dynamic>>[];
    final disabledModes = <Map<String, dynamic>>[];

    // UPI
    if (config.enableUpi) {
      final upiObj = <String, dynamic>{'type': 'UPI'};
      if (config.allowedUpiApps != null &&
          config.allowedUpiApps!.trim().isNotEmpty) {
        final apps = config.allowedUpiApps!
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();
        if (apps.isNotEmpty) {
          upiObj['apps'] = apps;
        }
      }
      enabledModes.add(upiObj);
    } else {
      disabledModes.add({'type': 'UPI'});
    }

    // Cards
    if (config.enableCards) {
      enabledModes.add({'type': 'CARD'});
    } else {
      disabledModes.add({'type': 'CARD'});
    }

    // Net Banking
    if (config.enableNetBanking) {
      enabledModes.add({'type': 'NET_BANKING'});
    } else {
      disabledModes.add({'type': 'NET_BANKING'});
    }

    // EMI
    if (config.enableEmi) {
      enabledModes.add({'type': 'EMI'});
    } else {
      disabledModes.add({'type': 'EMI'});
    }

    // Wallet
    if (config.enableWallets) {
      enabledModes.add({'type': 'WALLET'});
    } else {
      disabledModes.add({'type': 'WALLET'});
    }

    if (enabledModes.isEmpty && disabledModes.isEmpty) return null;

    final result = <String, dynamic>{'version': 'V2'};
    if (enabledModes.isNotEmpty) {
      result['enabledPaymentModes'] = enabledModes;
    } else if (disabledModes.isNotEmpty) {
      result['disabledPaymentModes'] = disabledModes;
    }
    return result;
  }
}
