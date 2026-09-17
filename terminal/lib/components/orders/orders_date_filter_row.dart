import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_dropdown_filter.dart';
import 'package:terminal/components/orders/orders_date_picker_popover.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Responsive wrapped row of date presets, calendar popover, and context-aware dropdown filters.
class OrdersDateFilterRow extends SignalWidget {
  const OrdersDateFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final activePreset = orderDatePresetSignal.value;
    final customRange = customDateRangeSignal.value;
    final isThisTerminal = orderSourceTabSignal.value == OrderSourceTab.thisTerminal;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...OrderDatePreset.values.map((preset) {
          final isSelected = customRange == null && activePreset == preset;
          return _buildPill(
            label: preset.label,
            isSelected: isSelected,
            onTap: () {
              customDateRangeSignal.value = null;
              orderDatePresetSignal.value = preset;
              orderCurrentPageSignal.value = 1;
              refreshOrdersSignal();
            },
          );
        }),
        const OrdersDatePickerPopover(),
        if (isThisTerminal) ..._buildTerminalFilters() else ..._buildOnlineFilters(),
      ],
    );
  }

  List<Widget> _buildTerminalFilters() => [
        OrderDropdownFilter<PaymentMethod>(
          title: 'Payment',
          currentValue: orderPaymentMethodFilterSignal.value,
          items: const [
            (label: 'All Modes', value: null),
            (label: 'Cash', value: PaymentMethod.cash),
            (label: 'UPI', value: PaymentMethod.upi),
            (label: 'Free', value: PaymentMethod.complimentary),
          ],
          onSelected: (val) {
            orderPaymentMethodFilterSignal.value = val;
            orderCurrentPageSignal.value = 1;
            refreshOrdersSignal();
          },
        ),
        OrderDropdownFilter<OrderStatus>(
          title: 'Status',
          currentValue: orderStatusFilterSignal.value,
          items: const [
            (label: 'All Statuses', value: null),
            (label: 'Completed', value: OrderStatus.completed),
            (label: 'Cancelled', value: OrderStatus.cancelled),
          ],
          onSelected: (val) {
            orderStatusFilterSignal.value = val;
            orderCurrentPageSignal.value = 1;
            refreshOrdersSignal();
          },
        ),
      ];

  List<Widget> _buildOnlineFilters() => [
        OrderDropdownFilter<PaymentStatus>(
          title: 'Pay Status',
          currentValue: orderPaymentStatusFilterSignal.value,
          items: const [
            (label: 'All Statuses', value: null),
            (label: 'Completed', value: PaymentStatus.completed),
            (label: 'Pending', value: PaymentStatus.pending),
            (label: 'Failed', value: PaymentStatus.failed),
          ],
          onSelected: (val) {
            orderPaymentStatusFilterSignal.value = val;
            orderCurrentPageSignal.value = 1;
            refreshOrdersSignal();
          },
        ),
        OrderDropdownFilter<OrderStatus>(
          title: 'Order Status',
          currentValue: orderStatusFilterSignal.value,
          items: const [
            (label: 'All Statuses', value: null),
            (label: 'Completed', value: OrderStatus.completed),
            (label: 'Preparing', value: OrderStatus.preparing),
            (label: 'Pending', value: OrderStatus.pending),
            (label: 'Cancelled', value: OrderStatus.cancelled),
          ],
          onSelected: (val) {
            orderStatusFilterSignal.value = val;
            orderCurrentPageSignal.value = 1;
            refreshOrdersSignal();
          },
        ),
      ];

  Widget _buildPill({required String label, required bool isSelected, required VoidCallback onTap}) {
    final bgColor = isSelected ? TerminalColors.textPrimary : TerminalColors.surface;
    final fgColor = isSelected ? TerminalColors.textWhite : TerminalColors.textPrimary;
    final borderColor = isSelected ? TerminalColors.textPrimary : TerminalColors.border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .height(38)
            .color(bgColor)
            .paddingX(16)
            .borderRadiusAll(const Radius.circular(999))
            .borderAll(color: borderColor)
            .shadowOnly(color: TerminalColors.shadow, offset: const Offset(0, 1), blurRadius: 2)
            .onHovered(isSelected ? BoxStyler() : BoxStyler().color(TerminalColors.pageBackground).borderAll(color: const Color(0xFFCBD5E1))),
        child: Center(
          widthFactor: 1.0,
          child: StyledText(label, style: TextStyler().fontSize(13.5).fontWeight(isSelected ? .w800 : .w700).color(fgColor)),
        ),
      ),
    );
  }
}
