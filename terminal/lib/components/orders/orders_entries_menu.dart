import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Popover menu overlay for selecting entries per page.
class OrdersEntriesMenu extends StatelessWidget {
  const OrdersEntriesMenu({
    required this.currentEntries,
    required this.controller,
    super.key,
  });

  final int currentEntries;
  final FPopoverController controller;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .width(110)
          .color(const Color(0xFFFFFFFF))
          .borderRadiusAll(const Radius.circular(10))
          .borderAll(color: const Color(0xFFE2E8F0))
          .paddingAll(4)
          .shadowOnly(color: const Color(0x14000000), offset: const Offset(0, 4), blurRadius: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: orderEntriesOptions.map((count) {
          final isSelected = currentEntries == count;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: () {
                orderPageSizeSignal.value = count;
                orderCurrentPageSignal.value = 1;
                controller.toggle();
                refreshOrdersSignal();
              },
              style: BoxStyler()
                  .color(isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF))
                  .paddingY(6)
                  .paddingX(8)
                  .borderRadiusAll(const Radius.circular(6))
                  .alignment(Alignment.centerLeft)
                  .onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    '$count',
                    style: TextStyler()
                        .fontSize(12.5)
                        .fontWeight(isSelected ? .w900 : .w600)
                        .color(const Color(0xFF0F172A)),
                  ),
                  if (isSelected) const Icon(FLucideIcons.check, size: 13, color: Color(0xFF0F172A)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
