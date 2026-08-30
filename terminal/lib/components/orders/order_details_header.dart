import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Senior-friendly header for the Order Details sidebar with full metadata, timestamps, and badges.
class OrderDetailsHeader extends StatelessWidget {
  final Order order;
  final VoidCallback? onClose;

  const OrderDetailsHeader({super.key, required this.order, this.onClose});

  @override
  Widget build(BuildContext context) {
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

    final isOnline =
        order.source == OrderSource.web ||
        order.source == OrderSource.mobileApp;
    final dt = order.createdAt;
    final hr = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final dateTimeStr = '$day/$month/${dt.year}, $hr:$min $period';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  StyledText(
                    'Bill #${order.billNo}',
                    style: TextStyler()
                        .fontSize(20)
                        .fontWeight(.w900)
                        .color(const Color(0xFF000000)),
                  ),
                  const Gap(10),
                  Flexible(
                    child: Box(
                      style: BoxStyler()
                          .color(const Color(0xFFF8FAFC))
                          .borderAll(color: const Color(0xFFE2E8F0))
                          .paddingX(9)
                          .paddingY(4)
                          .borderRadiusAll(const Radius.circular(6)),
                      child: StyledText(
                        order.orderReference,
                        style: TextStyler()
                            .fontSize(12)
                            .fontWeight(.w800)
                            .color(const Color(0xFF334155)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: onClose ?? () => selectedOrderSignal.value = null,
                style: BoxStyler()
                    .width(34)
                    .height(34)
                    .color(const Color(0xFFF1F5F9))
                    .borderRadiusAll(const Radius.circular(999))
                    .alignment(Alignment.center)
                    .onHovered(BoxStyler().color(const Color(0xFF000000))),
                child: StyledIcon(
                  icon: FLucideIcons.x,
                  style: IconStyler()
                      .size(16)
                      .color(const Color(0xFF0F172A))
                      .onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            const Icon(
              FLucideIcons.calendar,
              size: 14,
              color: Color(0xFF64748B),
            ),
            const Gap(6),
            StyledText(
              dateTimeStr,
              style: TextStyler()
                  .fontSize(12.5)
                  .fontWeight(.w700)
                  .color(const Color(0xFF64748B)),
            ),
          ],
        ),
        if (order.customer != null) ...[
          const Gap(8),
          Row(
            children: [
              const Icon(FLucideIcons.user, size: 14, color: Color(0xFF64748B)),
              const Gap(6),
              StyledText(
                order.customer?.name ?? '',
                style: TextStyler()
                    .fontSize(13.5)
                    .fontWeight(.w800)
                    .color(const Color(0xFF0F172A)),
              ),
              const Gap(8),
              StyledText(
                '•',
                style: TextStyler().fontSize(12).color(const Color(0xFF94A3B8)),
              ),
              const Gap(8),
              StyledText(
                order.customer?.mobileNumber ?? '',
                style: TextStyler()
                    .fontSize(13)
                    .fontWeight(.w600)
                    .color(const Color(0xFF64748B)),
              ),
            ],
          ),
        ],
        const Gap(12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (isOnline)
              Box(
                style: BoxStyler()
                    .color(payBg)
                    .paddingX(10)
                    .paddingY(5)
                    .borderRadiusAll(const Radius.circular(999)),
                child: StyledText(
                  payLabel,
                  style: TextStyler()
                      .fontSize(11.5)
                      .fontWeight(.w900)
                      .color(payFg),
                ),
              ),
            Box(
              style: BoxStyler()
                  .color(orderBg)
                  .paddingX(10)
                  .paddingY(5)
                  .borderRadiusAll(const Radius.circular(999)),
              child: StyledText(
                order.status.name.toUpperCase(),
                style: TextStyler()
                    .fontSize(11.5)
                    .fontWeight(.w800)
                    .color(orderFg),
              ),
            ),
            Box(
              style: BoxStyler()
                  .color(const Color(0xFFF1F5F9))
                  .paddingX(10)
                  .paddingY(5)
                  .borderRadiusAll(const Radius.circular(999)),
              child: StyledText(
                order.type.name.toUpperCase(),
                style: TextStyler()
                    .fontSize(11.5)
                    .fontWeight(.w800)
                    .color(const Color(0xFF0F172A)),
              ),
            ),
            Box(
              style: BoxStyler()
                  .color(const Color(0xFFF1F5F9))
                  .paddingX(10)
                  .paddingY(5)
                  .borderRadiusAll(const Radius.circular(999)),
              child: StyledText(
                order.paymentMethod.name.toUpperCase(),
                style: TextStyler()
                    .fontSize(11.5)
                    .fontWeight(.w800)
                    .color(const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
