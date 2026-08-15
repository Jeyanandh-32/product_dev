import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Calculates product sales, collected revenue, and stock wastage losses.
class ProfitLossCalculator {
  const ProfitLossCalculator._();

  /// Aggregates sold quantities and collected price after order-level discounts.
  static ({
    Map<String, int> soldQuantityMap,
    Map<String, double> collectedPriceMap,
  }) computeSalesAndCollectedRevenue({
    required List<OrderItemRow> items,
    required Map<String, OrderRow> orderMap,
  }) {
    final soldQuantityMap = <String, int>{};
    final collectedPriceMap = <String, double>{};

    for (final item in items) {
      final order = orderMap[item.orderId];
      if (order == null) continue;

      soldQuantityMap[item.productId] =
          (soldQuantityMap[item.productId] ?? 0) + item.quantity;

      final isComplimentary =
          order.paymentMethod.toLowerCase() == PaymentMethod.complimentary.name;
      final itemGrossPaise = (item.unitPrice * item.quantity) - item.discount;

      double itemCollected;
      if (isComplimentary || order.grandTotal <= 0) {
        itemCollected = 0.0;
      } else {
        final orderSubtotal = order.subtotal > 0 ? order.subtotal : 1;
        final discountRatio = (order.discountTotal / orderSubtotal).clamp(
          0.0,
          1.0,
        );
        final effectiveItemPaise = itemGrossPaise * (1.0 - discountRatio);
        itemCollected = effectiveItemPaise / 100.0;
      }

      collectedPriceMap[item.productId] =
          (collectedPriceMap[item.productId] ?? 0.0) + itemCollected;
    }

    return (
      soldQuantityMap: soldQuantityMap,
      collectedPriceMap: collectedPriceMap,
    );
  }

  /// Calculates financial loss incurred through recorded stock wastage.
  static Map<String, double> computeWastageLosses({
    required List<StockTransactionRow> stockAdjustments,
    required Map<String, int> productBasePriceMap,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final wastageLossMap = <String, double>{};

    for (final a in stockAdjustments) {
      if (fromDate != null && a.createdAt.isBefore(fromDate)) continue;
      if (toDate != null && a.createdAt.isAfter(toDate)) continue;
      final basePricePaise = productBasePriceMap[a.productId] ?? 0;
      final loss = (basePricePaise * a.quantity) / 100.0;
      wastageLossMap[a.productId] = (wastageLossMap[a.productId] ?? 0.0) + loss;
    }

    return wastageLossMap;
  }
}
