import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_details_sidebar.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Opens the order details bottom sheet modal on mobile and tablet.
class OrderDetailsModal {
  const OrderDetailsModal._();

  /// Displays the modal sheet and resets selected order on dismiss.
  static Future<void> show(BuildContext context, Order order) async {
    selectedOrderSignal.value = order;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      backgroundColor: TerminalColors.pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const FractionallySizedBox(
        heightFactor: 0.88,
        child: OrderDetailsSidebar(isDrawerMode: true),
      ),
    );
    selectedOrderSignal.value = null;
  }
}
