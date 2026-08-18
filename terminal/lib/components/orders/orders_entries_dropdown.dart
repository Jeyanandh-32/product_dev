import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';

/// Entries per page dropdown selector and range indicator with high-contrast black typography.
class OrdersEntriesDropdown extends StatefulWidget {
  const OrdersEntriesDropdown({super.key});

  @override
  State<OrdersEntriesDropdown> createState() => _OrdersEntriesDropdownState();
}

class _OrdersEntriesDropdownState extends State<OrdersEntriesDropdown>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final entries = orderPageSizeSignal.value;
        final currentPage = orderCurrentPageSignal.value;
        final totalCount = filteredOrdersSignal.value.length;

        final start = totalCount == 0 ? 0 : ((currentPage - 1) * entries) + 1;
        final end = (currentPage * entries).clamp(0, totalCount);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledText(
              'Show',
              style: TextStyler().fontSize(13.5).fontWeight(.w700).color(const Color(0xFF000000)),
            ),
            const Gap(6),
            FTheme(
              data: TerminalTheme.light(false),
              child: FPopover(
                control: .managed(controller: _controller),
                popoverAnchor: Alignment.topLeft,
                childAnchor: Alignment.bottomLeft,
                popoverBuilder: (context, controller) => _buildMenu(entries, controller),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: _controller.toggle,
                    style: BoxStyler()
                        .height(34)
                        .color(const Color(0xFFFFFFFF))
                        .paddingX(12)
                        .borderRadiusAll(const Radius.circular(999))
                        .borderAll(color: const Color(0xFFE2E8F0))
                        .alignment(Alignment.center)
                        .shadowOnly(color: const Color(0x06000000), offset: const Offset(0, 1), blurRadius: 2)
                        .onHovered(BoxStyler().color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledText(
                          '$entries',
                          style: TextStyler().fontSize(13).fontWeight(.w800).color(const Color(0xFF000000)),
                        ),
                        const Gap(4),
                        const Icon(FLucideIcons.chevronDown, size: 14, color: Color(0xFF000000)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (totalCount > 0) ...[
              const Gap(10),
              StyledText(
                'Showing $start–$end of $totalCount',
                style: TextStyler().fontSize(13).fontWeight(.w700).color(const Color(0xFF475569)),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMenu(int currentEntries, FPopoverController controller) {
    return Box(
      style: BoxStyler()
          .width(100)
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
                        .fontSize(13)
                        .fontWeight(isSelected ? .w900 : .w600)
                        .color(const Color(0xFF000000)),
                  ),
                  if (isSelected) const Icon(FLucideIcons.check, size: 14, color: Color(0xFF000000)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
