import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_card_customer_info.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// High-contrast, spacious order card item for the POS orders grid with GPU repaint isolation.
class OrderCardItem extends SignalWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCardItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isSelected = selectedOrderSignal.value?.id == order.id;

    final (payBg, payFg, payLabel) = switch (order.paymentStatus) {
      PaymentStatus.completed => (
        const Color(0xFFDCFCE7),
        const Color(0xFF15803D),
        'PAID',
      ),
      PaymentStatus.pending => (
        const Color(0xFFFEF3C7),
        const Color(0xFFB45309),
        'PAY PENDING',
      ),
      PaymentStatus.failed => (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
        'PAY FAILED',
      ),
    };

    final (orderBg, orderFg) = switch (order.status) {
      OrderStatus.completed => (
        const Color(0xFFDCFCE7),
        const Color(0xFF15803D),
      ),
      OrderStatus.preparing => (
        const Color(0xFFDBEAFE),
        const Color(0xFF1E40AF),
      ),
      OrderStatus.pending => (const Color(0xFFFEF3C7), const Color(0xFFB45309)),
      OrderStatus.cancelled => (
        const Color(0xFFFEE2E2),
        const Color(0xFFB91C1C),
      ),
    };

    final cardStyle = BoxStyler()
        .color(const Color(0xFFFFFFFF))
        .paddingAll(isDesktop ? 18 : 14)
        .borderRadiusAll(const Radius.circular(16))
        .borderAll(
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
          width: 2.0,
        )
        .shadowOnly(
          color: isSelected ? const Color(0x14000000) : const Color(0x06000000),
          offset: const Offset(0, 2),
          blurRadius: isSelected ? 8 : 4,
        );

    final rawHour = order.createdAt.hour;
    final period = rawHour >= 12 ? 'PM' : 'AM';
    final hour12 = rawHour % 12 == 0 ? 12 : rawHour % 12;
    final min = order.createdAt.minute.toString().padLeft(2, '0');
    final dateTimeStr =
        '${order.createdAt.day} ${_months[order.createdAt.month - 1]}, $hour12:$min $period';
    final isOnline =
        order.source == OrderSource.web ||
        order.source == OrderSource.mobileApp;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: PressableBox(
          onPress: onTap,
          style: cardStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledText(
                          '#${order.billNo}',
                          style: TextStyler()
                              .fontSize(20)
                              .fontWeight(.w900)
                              .color(const Color(0xFF000000)),
                        ),
                        const Gap(6),
                        Box(
                          style: BoxStyler()
                              .color(const Color(0xFFF8FAFC))
                              .borderAll(color: const Color(0xFFE2E8F0))
                              .paddingX(6)
                              .paddingY(2)
                              .borderRadiusAll(const Radius.circular(5)),
                          child: Text(
                            order.orderReference,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isOnline) ...[
                        Box(
                          style: BoxStyler()
                              .color(payBg)
                              .paddingX(7)
                              .paddingY(3)
                              .borderRadiusAll(const Radius.circular(999)),
                          child: StyledText(
                            payLabel,
                            style: TextStyler()
                                .fontSize(10.5)
                                .fontWeight(.w900)
                                .color(payFg),
                          ),
                        ),
                        const Gap(4.5),
                      ],
                      Box(
                        style: BoxStyler()
                            .color(orderBg)
                            .paddingX(8)
                            .paddingY(3)
                            .borderRadiusAll(const Radius.circular(999)),
                        child: StyledText(
                          order.status.name.toUpperCase(),
                          style: TextStyler()
                              .fontSize(10.5)
                              .fontWeight(.w800)
                              .color(orderFg),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (order.customer != null) ...[
                const Gap(14),
                OrderCardCustomerInfo(customer: order.customer!),
              ],
              Gap(order.customer != null ? 14 : 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          FLucideIcons.calendar,
                          size: 13.5,
                          color: Color(0xFF64748B),
                        ),
                        const Gap(5),
                        Expanded(
                          child: Text(
                            '$dateTimeStr • ${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  StyledText(
                    '₹${order.grandTotal.toStringAsFixed(2)}',
                    style: TextStyler()
                        .fontSize(18)
                        .fontWeight(.w900)
                        .color(const Color(0xFF000000)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
