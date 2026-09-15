import 'package:flutter/material.dart' show DateTimeRange;
import 'package:models/models.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/calendar_grid_card.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme.dart';

/// Compact inline calendar popover displaying the active selected date range reactively.
class OrdersDatePickerPopover extends StatefulWidget {
  const OrdersDatePickerPopover({super.key});

  @override
  State<OrdersDatePickerPopover> createState() =>
      _OrdersDatePickerPopoverState();
}

class _OrdersDatePickerPopoverState extends State<OrdersDatePickerPopover>
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
        final customRange = customDateRangeSignal.value;
        final isCustomActive = customRange != null;
        final label = _formatLabel(customRange);

        final bgColor = isCustomActive
            ? const Color(0xFF0F172A)
            : const Color(0xFFFFFFFF);
        final fgColor = isCustomActive
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF0F172A);
        final borderColor = isCustomActive
            ? const Color(0xFF0F172A)
            : const Color(0xFFE2E8F0);

        return FTheme(
          data: TerminalTheme.light(false),
          child: FPopover(
            control: .managed(controller: _controller),
            popoverAnchor: Alignment.topLeft,
            childAnchor: Alignment.bottomLeft,
            popoverBuilder: (context, controller) => CalendarGridCard(
              initialRange: customRange,
              onRangeSelected: (range) {
                customDateRangeSignal.value = range;
                orderDatePresetSignal.value = null;
                orderCurrentPageSignal.value = 1;
                refreshOrdersSignal();
              },
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: _controller.toggle,
                style: BoxStyler()
                    .height(38)
                    .color(bgColor)
                    .paddingX(14)
                    .borderRadiusAll(const Radius.circular(999))
                    .borderAll(color: borderColor)
                    .shadowOnly(
                      color: const Color(0x08000000),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    )
                    .alignment(Alignment.center)
                    .onHovered(
                      isCustomActive
                          ? BoxStyler()
                          : BoxStyler()
                                .color(const Color(0xFFF8FAFC))
                                .borderAll(color: const Color(0xFFCBD5E1)),
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FLucideIcons.calendar, size: 15, color: fgColor),
                    const Gap(6),
                    StyledText(
                      label,
                      style: TextStyler()
                          .fontSize(13.5)
                          .fontWeight(isCustomActive ? .w800 : .w700)
                          .color(fgColor),
                    ),
                    if (isCustomActive) ...[
                      const Gap(6),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            customDateRangeSignal.value = null;
                            orderDatePresetSignal.value = OrderDatePreset.today;
                            orderCurrentPageSignal.value = 1;
                          },
                          child: Icon(
                            FLucideIcons.x,
                            size: 13.5,
                            color: fgColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatLabel(DateTimeRange? range) {
    if (range == null) return 'Pick Date';
    final startStr = AppDateFormatter.formatDate(range.start);
    final endStr = AppDateFormatter.formatDate(range.end);
    return startStr == endStr ? startStr : '$startStr – $endStr';
  }
}
