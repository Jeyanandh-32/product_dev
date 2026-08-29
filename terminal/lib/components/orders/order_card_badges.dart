import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';

/// Status badge indicator row for order cards in POS.
class OrderCardBadges extends StatelessWidget {
  const OrderCardBadges({super.key, required this.order});

  final Order order;

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

    return Row(
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
              style: TextStyler().fontSize(10.5).fontWeight(.w900).color(payFg),
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
            style: TextStyler().fontSize(10.5).fontWeight(.w800).color(orderFg),
          ),
        ),
      ],
    );
  }
}
