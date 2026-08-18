import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_dropdown_filter.dart';
import 'package:terminal/components/orders/orders_date_picker_popover.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Horizontal scrollable row of date presets, calendar popover, and context-aware dropdown filters.
class OrdersDateFilterRow extends SignalWidget {
  const OrdersDateFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final activePreset = orderDatePresetSignal.value;
    final customRange = customDateRangeSignal.value;
    final isThisTerminal = orderSourceTabSignal.value == OrderSourceTab.thisTerminal;
    final payMethod = orderPaymentMethodFilterSignal.value;
    final payStatus = orderPaymentStatusFilterSignal.value;
    final orderStatus = orderStatusFilterSignal.value;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...OrderDatePreset.values.map((preset) {
            final isSelected = customRange == null && activePreset == preset;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildPill(
                label: preset.label,
                isSelected: isSelected,
                onTap: () {
                  customDateRangeSignal.value = null;
                  orderDatePresetSignal.value = preset;
                  orderCurrentPageSignal.value = 1;
                  refreshOrdersSignal();
                },
              ),
            );
          }),
          const Gap(2),
          const OrdersDatePickerPopover(),
          if (isThisTerminal) ...[
            const Gap(8),
            OrderDropdownFilter<PaymentMethod>(
              title: 'Payment',
              currentValue: payMethod,
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
            const Gap(8),
            OrderDropdownFilter<OrderStatus>(
              title: 'Status',
              currentValue: orderStatus,
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
          ] else ...[
            const Gap(8),
            OrderDropdownFilter<PaymentStatus>(
              title: 'Pay Status',
              currentValue: payStatus,
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
            const Gap(8),
            OrderDropdownFilter<OrderStatus>(
              title: 'Order Status',
              currentValue: orderStatus,
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
          ],
        ],
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bgColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final fgColor = isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
    final borderColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);

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
            .shadowOnly(color: const Color(0x08000000), offset: const Offset(0, 1), blurRadius: 2)
            .alignment(Alignment.center)
            .onHovered(
              isSelected
                  ? BoxStyler()
                  : BoxStyler().color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1)),
            ),
        child: StyledText(
          label,
          style: TextStyler().fontSize(13.5).fontWeight(isSelected ? .w800 : .w700).color(fgColor),
        ),
      ),
    );
  }
}
