import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';

/// Row of status, payment, and channel badge chips for the order details header.
class OrderDetailsHeaderBadges extends StatelessWidget {
  final Order order;

  const OrderDetailsHeaderBadges({super.key, required this.order});

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

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (isOnline) _chip(payLabel, payBg, payFg, isBold: true),
        _chip(order.status.name.toUpperCase(), orderBg, orderFg),
        _chip(
          order.type.name.toUpperCase(),
          const Color(0xFFF1F5F9),
          const Color(0xFF0F172A),
        ),
        _chip(
          order.paymentMethod.name.toUpperCase(),
          const Color(0xFFF1F5F9),
          const Color(0xFF0F172A),
        ),
      ],
    );
  }

  Widget _chip(String label, Color bg, Color fg, {bool isBold = false}) {
    return Box(
      style: BoxStyler()
          .color(bg)
          .paddingX(10)
          .paddingY(5)
          .borderRadiusAll(const Radius.circular(999)),
      child: StyledText(
        label,
        style: TextStyler()
            .fontSize(11.5)
            .fontWeight(isBold ? .w900 : .w800)
            .color(fg),
      ),
    );
  }
}
