import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/order_details_summary_section.dart';
import 'package:merchant/components/modals/order_items_table_view.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Modal dialog presenting itemized receipt and order breakdown.
class OrderDetailsModal extends StatelessComponent {
  final AsyncState<Order?> state;

  const OrderDetailsModal({super.key, required this.state});

  String _formatAmount(double amount) {
    if (amount % 1 == 0) {
      return '${amount.toInt()}';
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Orders Details',
      maxWidthClass: 'max-w-xl',
      child: () {
        if (state.isLoading) {
          return const Loading(
            text: 'Loading order details...',
            fullScreen: false,
          );
        }
        if (state.hasError) {
          return const CenteredMessage(
            message: 'Failed to load order details.',
          );
        }
        final order = state.value;
        if (order == null) {
          return const CenteredMessage(message: 'Order details not found.');
        }

        return div(classes: 'flex flex-col gap-6 pt-2 pb-1', [
          OrderItemsTableView(
            items: order.items,
            formatAmount: _formatAmount,
          ),
          div(classes: 'border-t border-gray-200/60 w-full', []),
          OrderDetailsSummarySection(
            order: order,
            formatAmount: _formatAmount,
          ),
        ]);
      }(),
    );
  }
}
