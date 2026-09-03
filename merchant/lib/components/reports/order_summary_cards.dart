import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Renders aggregate sales and payment collection summary metric cards for the Orders report.
class OrderSummaryCards extends StatelessComponent {
  final int totalOrders;
  final double grossSubtotal;
  final double totalDiscount;
  final double platformFeeTotal;
  final double gatewayChargesTotal;
  final double netRevenue;
  final double cashCollected;
  final double upiCollected;
  final double walletCollected;
  final double freeTotal;

  const OrderSummaryCards({
    super.key,
    required this.totalOrders,
    required this.grossSubtotal,
    required this.totalDiscount,
    this.platformFeeTotal = 0.0,
    this.gatewayChargesTotal = 0.0,
    required this.netRevenue,
    this.cashCollected = 0.0,
    this.upiCollected = 0.0,
    this.walletCollected = 0.0,
    this.freeTotal = 0.0,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col gap-3 p-4 border-b border-border-medium bg-neutral/20',
      [
        div(classes: 'grid grid-cols-2 lg:grid-cols-4 gap-3', [
          _summaryCard(
            title: 'Total Orders',
            value: '$totalOrders',
            textColor: 'text-gray-900',
          ),
          _summaryCard(
            title: 'Gross Subtotal',
            value: '₹${grossSubtotal.toStringAsFixed(2)}',
            textColor: 'text-gray-900',
          ),
          _summaryCard(
            title: 'Total Discounts',
            value: '₹${totalDiscount.toStringAsFixed(2)}',
            textColor: 'text-rose-600',
          ),
          _summaryCard(
            title: 'Net Sales (Revenue)',
            value: '₹${netRevenue.toStringAsFixed(2)}',
            textColor: 'text-emerald-600',
          ),
        ]),
        div(classes: 'grid grid-cols-2 lg:grid-cols-4 gap-3', [
          _summaryCard(
            title: 'Cash Collected',
            value: '₹${cashCollected.toStringAsFixed(2)}',
            textColor: 'text-blue-600',
          ),
          _summaryCard(
            title: 'UPI / Online',
            value: '₹${upiCollected.toStringAsFixed(2)}',
            textColor: 'text-purple-600',
          ),
          _summaryCard(
            title: 'Platform Fee (Customer Paid)',
            value: '₹${platformFeeTotal.toStringAsFixed(2)}',
            textColor: 'text-gray-700',
          ),
          _summaryCard(
            title: 'Wallet Paid',
            value: '₹${walletCollected.toStringAsFixed(2)}',
            textColor: 'text-amber-600',
          ),
        ]),
      ],
    );
  }

  Component _summaryCard({
    required String title,
    required String value,
    required String textColor,
  }) {
    return div(
      classes: 'flex flex-col gap-1 p-3 bg-white rounded-xl border border-border-medium shadow-2xs',
      [
        span(classes: 'text-xs text-gray-500 font-medium', [.text(title)]),
        span(classes: 'text-base font-bold $textColor', [.text(value)]),
      ],
    );
  }
}
