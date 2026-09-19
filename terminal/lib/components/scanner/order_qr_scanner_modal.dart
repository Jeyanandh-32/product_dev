import 'package:flutter/material.dart';
import 'package:terminal/components/scanner/order_qr_scanner_view.dart';

/// Modal controller presenting the fullscreen camera scanner dialog.
abstract final class OrderQrScannerModal {
  /// Launches the fullscreen QR code scanner interface.
  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const OrderQrScannerView(),
        fullscreenDialog: true,
      ),
    );
  }
}
