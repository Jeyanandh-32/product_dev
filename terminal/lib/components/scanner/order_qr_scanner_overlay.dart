import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Semi-transparent dark overlay with a transparent viewfinder cutout and scanner controls.
class OrderQrScannerOverlay extends StatelessWidget {
  final MobileScannerController controller;
  final bool isProcessing;
  final VoidCallback onClose;

  const OrderQrScannerOverlay({
    super.key,
    required this.controller,
    required this.isProcessing,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scanBoxSize = (size.width * 0.72).clamp(220.0, 300.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.65),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.15),
                child: Container(
                  width: scanBoxSize,
                  height: scanBoxSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.15),
          child: Container(
            width: scanBoxSize,
            height: scanBoxSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF10B981), width: 2.5),
            ),
            child: isProcessing
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xFF10B981),
                        ),
                        Gap(12),
                        Text(
                          'Locating order...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: MediaQuery.paddingOf(context).top + 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _overlayCircleButton(
                icon: FLucideIcons.x,
                onTap: onClose,
              ),
              ValueListenableBuilder<MobileScannerState>(
                valueListenable: controller,
                builder: (context, state, _) {
                  final isTorchOn = state.torchState == TorchState.on;
                  return _overlayCircleButton(
                    icon: isTorchOn ? FLucideIcons.flashlight : FLucideIcons.flashlightOff,
                    color: isTorchOn ? const Color(0xFFFBBF24) : Colors.white,
                    onTap: () => controller.toggleTorch(),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: MediaQuery.paddingOf(context).bottom + 48,
          child: const Center(
            child: Text(
              'Align order QR code within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black87,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _overlayCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
