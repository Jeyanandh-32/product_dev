import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Stock delta calculation for opening and closing stock periods.
class StockMovementCalculator {
  const StockMovementCalculator._();

  /// Computes opening, in, out, wastage, and closing stock metrics for a single product.
  static StockSummaryItem? computeItemMetrics({
    required ProductRow product,
    required List<StockTransactionRow> productTx,
    required int currentStock,
    required String categoryName,
    required String counterName,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    var inQty = 0;
    var outQty = 0;
    var wastageQty = 0;
    var adjQty = 0;
    var netAfterToDate = 0;

    for (final tx in productTx) {
      final txDate = tx.createdAt;
      final reason = tx.reason.toLowerCase();
      final type = tx.adjustmentType.toLowerCase();

      final isAfter = toDate != null && txDate.isAfter(toDate);
      final isInRange =
          (fromDate == null || !txDate.isBefore(fromDate)) &&
          (toDate == null || !txDate.isAfter(toDate));

      var change = 0;
      if (reason == 'restock' || type == 'add') {
        change = tx.quantity;
      } else if (reason == 'sale' ||
          reason == 'wastage' ||
          type == 'reduce') {
        change = -tx.quantity;
      }

      if (isAfter) {
        netAfterToDate += change;
      }

      if (isInRange) {
        if (reason == 'restock') {
          inQty += tx.quantity;
        } else if (reason == 'sale') {
          outQty += tx.quantity;
        } else if (reason == 'wastage') {
          wastageQty += tx.quantity;
        } else if (reason == 'adjustment') {
          if (type == 'add') {
            adjQty += tx.quantity;
          } else if (type == 'reduce') {
            adjQty -= tx.quantity;
          } else {
            adjQty += tx.quantity;
          }
        } else {
          if (type == 'add') {
            inQty += tx.quantity;
          } else if (type == 'reduce') {
            outQty += tx.quantity;
          }
        }
      }
    }

    final closingStock = currentStock - netAfterToDate;
    final openingStock = closingStock - inQty + outQty + wastageQty - adjQty;

    final hasActivity =
        inQty != 0 || outQty != 0 || wastageQty != 0 || adjQty != 0;
    if (fromDate != null && !hasActivity) {
      return null;
    }

    return StockSummaryItem(
      productId: product.id,
      productName: product.name,
      categoryName: categoryName,
      counterName: counterName,
      openingStock: openingStock,
      inQuantity: inQty,
      outQuantity: outQty,
      wastageQuantity: wastageQty,
      adjustmentQuantity: adjQty,
      closingStock: closingStock,
    );
  }
}
