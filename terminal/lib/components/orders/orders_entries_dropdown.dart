import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders_entries_menu.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Premium entries per page dropdown selector and range indicator.
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
    final isMobile = context.isMobile;

    return SignalBuilder(
      builder: (context) {
        final entries = orderPageSizeSignal.value;
        final currentPage = orderCurrentPageSignal.value;
        final totalCount = orderTotalItemsSignal.value;

        final start = totalCount == 0 ? 0 : ((currentPage - 1) * entries) + 1;
        final end = (currentPage * entries).clamp(0, totalCount);

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FTheme(
              data: TerminalTheme.light(false),
              child: FPopover(
                control: .managed(controller: _controller),
                popoverAnchor: Alignment.topLeft,
                childAnchor: Alignment.bottomLeft,
                popoverBuilder: (context, controller) => OrdersEntriesMenu(
                  currentEntries: entries,
                  controller: controller,
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: _controller.toggle,
                    style: BoxStyler()
                        .height(32)
                        .color(const Color(0xFFF8FAFC))
                        .paddingX(isMobile ? 8 : 10)
                        .borderRadiusAll(const Radius.circular(8))
                        .borderAll(color: const Color(0xFFE2E8F0))
                        .alignment(Alignment.center)
                        .onHovered(
                          BoxStyler().color(const Color(0xFFF1F5F9)).borderAll(color: const Color(0xFFCBD5E1)),
                        ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledText(
                          isMobile ? '$entries' : '$entries / page',
                          style: TextStyler().fontSize(12.5).fontWeight(.w800).color(const Color(0xFF0F172A)),
                        ),
                        const Gap(4),
                        const Icon(FLucideIcons.chevronDown, size: 13, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (totalCount > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(width: 1, height: 16, color: const Color(0xFFE2E8F0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$start–$end',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Text(
                    ' of ',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    isMobile ? '$totalCount' : '$totalCount orders',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
