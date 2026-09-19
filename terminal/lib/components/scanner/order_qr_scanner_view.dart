import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:terminal/components/scanner/order_qr_scanner_handler.dart';
import 'package:terminal/components/scanner/order_qr_scanner_overlay.dart';

/// Fullscreen camera scanner view for scanning order verification QR codes.
class OrderQrScannerView extends StatefulWidget {
  const OrderQrScannerView({super.key});

  @override
  State<OrderQrScannerView> createState() => _OrderQrScannerViewState();
}

class _OrderQrScannerViewState extends State<OrderQrScannerView> {
  late final MobileScannerController _controller;
  final ValueNotifier<bool> _isProcessingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isProcessingNotifier.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessingNotifier.value) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;
    if (rawValue == null || rawValue.trim().isEmpty) return;

    OrderQrScannerHandler.processBarcode(
      context: context,
      rawBarcode: rawValue,
      isProcessingNotifier: _isProcessingNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white70,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Camera unavailable: ${error.errorCode.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isProcessingNotifier,
            builder: (context, isProcessing, _) {
              return OrderQrScannerOverlay(
                controller: _controller,
                isProcessing: isProcessing,
                onClose: () => Navigator.of(context).pop(),
              );
            },
          ),
        ],
      ),
    );
  }
}
