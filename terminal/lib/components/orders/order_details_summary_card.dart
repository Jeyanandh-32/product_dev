import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_details_actions.dart';
import 'package:terminal/components/orders/order_details_totals.dart';

/// Bottom summary card for Order Details sidebar styled identically to [CartSummary] (rounded-24 card).
class OrderDetailsSummaryCard extends StatelessWidget {
  final Order order;

  const OrderDetailsSummaryCard({super.key, required this.order});

  bool get _canReprint =>
      order.status != OrderStatus.cancelled && order.paymentStatus == PaymentStatus.completed;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .marginTop(8)
          .paddingAll(20)
          .color(const Color(0xFFFFFFFF))
          .borderRadiusAll(const Radius.circular(24))
          .borderAll(color: const Color(0xFFE5E7EB))
          .shadowOnly(
            color: const Color(0x08000000),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderDetailsTotals(order: order),
          if (_canReprint) ...[
            const Gap(16),
            OrderDetailsActions(order: order),
          ],
        ],
      ),
    );
  }
}
