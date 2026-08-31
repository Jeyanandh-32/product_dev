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
      if (reason == StockTransactionReason.restock.name ||
          type == StockTransactionType.add.name) {
        change = tx.quantity;
      } else if (reason == StockTransactionReason.sale.name ||
          reason == StockTransactionReason.wastage.name ||
          type == StockTransactionType.reduce.name) {
        change = -tx.quantity;
      }

      if (isAfter) {
        netAfterToDate += change;
      }

      if (isInRange) {
        if (reason == StockTransactionReason.restock.name) {
          inQty += tx.quantity;
        } else if (reason == StockTransactionReason.sale.name) {
          outQty += tx.quantity;
        } else if (reason == StockTransactionReason.wastage.name) {
          wastageQty += tx.quantity;
        } else if (reason == StockTransactionReason.adjustment.name) {
          if (type == StockTransactionType.add.name) {
            adjQty += tx.quantity;
          } else if (type == StockTransactionType.reduce.name) {
            adjQty -= tx.quantity;
          } else {
            adjQty += tx.quantity;
          }
        } else {
          if (type == StockTransactionType.add.name) {
            inQty += tx.quantity;
          } else if (type == StockTransactionType.reduce.name) {
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
