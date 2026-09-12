import 'package:client_repositories/client_repositories.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Senior-friendly print receipt and complete order action button.
class OrderDetailsActions extends StatelessWidget {
  final Order order;

  const OrderDetailsActions({super.key, required this.order});

  void _handlePrintAction(BuildContext context) {
    final isAlreadyCompleted = order.status == OrderStatus.completed;

    if (!isAlreadyCompleted) {
      final updated = order.copyWith(status: OrderStatus.completed);
      selectedOrderSignal.value = updated;
      final all = ordersSignal.value.value ?? [];
      ordersSignal.value = AsyncData(
        all.map((o) => o.id == order.id ? updated : o).toList(),
      );
      OrderRepository.updateStatus(
        storeId: order.storeId,
        id: order.id,
        status: OrderStatus.completed,
      ).catchError((_) => updated);
    }

    TerminalToast.showSuccess(
      context: context,
      title: isAlreadyCompleted
          ? 'Receipt Sent to Printer'
          : 'Order Completed & Printed',
      description: 'Bill #${order.billNo} • ${order.orderReference}',
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status == OrderStatus.completed;
    final label = isCompleted ? 'Reprint Receipt' : 'Print & Complete Order';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: () => _handlePrintAction(context),
        style: BoxStyler()
            .alignment(Alignment.center)
            .height(48)
            .borderRadiusAll(const Radius.circular(14))
            .color(TerminalColors.primary)
            .onHovered(BoxStyler().color(TerminalColors.primaryHover)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FLucideIcons.printer,
              size: 16,
              color: Color(0xFFFFFFFF),
            ),
            const Gap(8),
            StyledText(
              label,
              style: TextStyler()
                  .fontSize(14.5)
                  .fontWeight(.w800)
                  .color(const Color(0xFFFFFFFF)),
            ),
          ],
        ),
      ),
    );
  }
}
