import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Refresh button with hover micro-animations for POS orders screen.
class OrdersRefreshButton extends StatelessWidget {
  final double size;

  const OrdersRefreshButton({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: refreshOrdersSignal,
        style: BoxStyler()
            .width(size)
            .height(size)
            .color(const Color(0xFFFFFFFF))
            .borderRadiusAll(const Radius.circular(999))
            .borderAll(color: const Color(0xFFE2E8F0))
            .shadowOnly(color: const Color(0x08000000), offset: const Offset(0, 1), blurRadius: 3)
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(const Color(0xFF000000))),
        child: StyledIcon(
          icon: FLucideIcons.rotateCw,
          style: IconStyler().size(16.5).color(const Color(0xFF0F172A)).onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
        ),
      ),
    );
  }
}
