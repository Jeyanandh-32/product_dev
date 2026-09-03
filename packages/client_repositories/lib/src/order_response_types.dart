import 'package:models/models.dart';

/// Summary metrics for an orders report query.
typedef OrderSummary = ({
  int totalOrders,
  double grossSubtotal,
  double totalDiscount,
  double platformFeeTotal,
  double gatewayChargesTotal,
  double netRevenue,
  double cashCollected,
  double upiCollected,
  double walletCollected,
  double freeTotal,
});

/// Paginated API response structure for orders report.
typedef OrderPaginatedResponse = ({
  List<Order> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
  OrderSummary summary,
});

/// Result returned after initiating an online payment session.
typedef OnlinePaymentInitiationResult = ({
  Order order,
  String? tokenUrl,
  String merchantOrderId,
  bool isFullyPaidByWallet,
});
