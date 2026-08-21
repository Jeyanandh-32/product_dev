import 'package:models/models.dart';

/// Aggregated order financial summary record.
typedef OrderSummaryResult = ({
  int totalOrders,
  double grossSubtotal,
  double totalDiscount,
  double netRevenue,
  double cashCollected,
  double upiCollected,
  double walletCollected,
  double freeTotal,
});

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
