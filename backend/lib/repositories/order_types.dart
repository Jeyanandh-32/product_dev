import 'package:models/models.dart';

/// Aggregated order financial summary result.
class OrderSummaryResult {
  const OrderSummaryResult({
    required this.totalOrders,
    required this.grossSubtotal,
    required this.totalDiscount,
    required this.platformFeeTotal,
    required this.gatewayChargesTotal,
    required this.netRevenue,
    required this.cashCollected,
    required this.upiCollected,
    required this.walletCollected,
    required this.freeTotal,
  });

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

  Map<String, dynamic> toJson() => {
    'totalOrders': totalOrders,
    'grossSubtotal': grossSubtotal,
    'totalDiscount': totalDiscount,
    'platformFeeTotal': platformFeeTotal,
    'gatewayChargesTotal': gatewayChargesTotal,
    'netRevenue': netRevenue,
    'cashCollected': cashCollected,
    'upiCollected': upiCollected,
    'walletCollected': walletCollected,
    'freeTotal': freeTotal,
  };
}

/// Payment channel breakdown summary record.
typedef PaymentSummaryResult = ({
  double cashCollected,
  double upiCollected,
  double freeTotal,
  double totalCollected,
});

/// Profit and loss report detailed record.
typedef ProfitLossReportResult = ({
  int total,
  List<ProfitLossItem> items,
  double totalCostPrice,
  double totalCollectedPrice,
  double totalProfit,
  double totalMarginPercentage,
});
