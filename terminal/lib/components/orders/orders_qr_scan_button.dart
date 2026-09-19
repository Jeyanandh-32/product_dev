import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/scanner/order_qr_scanner_modal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean circular 44px QR scanner action button for the POS Orders toolbar.
class OrdersQrScanButton extends StatelessWidget {
  final double size;

  const OrdersQrScanButton({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: () => OrderQrScannerModal.open(context),
        style: BoxStyler()
            .width(size)
            .height(size)
            .color(TerminalColors.brandBlueBg)
            .borderRadiusAll(const Radius.circular(999))
            .borderAll(color: TerminalColors.brandBlueBorder)
            .shadowOnly(
              color: const Color(0x08000000),
              offset: const Offset(0, 1),
              blurRadius: 3,
            )
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(TerminalColors.brandBlue)),
        child: StyledIcon(
          icon: FLucideIcons.scanQrCode,
          style: IconStyler()
              .size(17)
              .color(TerminalColors.brandBlue)
              .onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
        ),
      ),
    );
  }
}
