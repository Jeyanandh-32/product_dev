import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Aggregates order summaries and payment method breakdowns from the database.
class OrderSummaryCalculator {
  const OrderSummaryCalculator._();

  /// Computes order summary totals including gross, discounts, net revenue, and payment method channels.
  static Future<
    ({
      int totalOrders,
      double grossSubtotal,
      double totalDiscount,
      double platformFeeTotal,
      double netRevenue,
      double cashCollected,
      double upiCollected,
      double walletCollected,
      double freeTotal,
    })
  >
  calculateOrderSummary({
    required ts.Database<DatabaseSchema> db,
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    var query = db.orders.where(
      (o) => o.merchantId.equals(ts.toExpr(merchantId)),
    );

    if (storeId != null) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }
    if (fromDate != null) {
      query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    }

    final rows = await query.fetch();

    var validOrderCount = 0;
    var grossSubtotalPaise = 0;
    var totalDiscountPaise = 0;
    var platformFeePaise = 0;
    var netRevenuePaise = 0;
    var cashPaise = 0;
    var upiPaise = 0;
    var walletPaise = 0;
    var freePaise = 0;

    for (final row in rows) {
      final pStatus = row.paymentStatus.toLowerCase();
      final status = row.status.toLowerCase();
      final method = row.paymentMethod.toLowerCase();

      final isPaidOrCompleted =
          pStatus == PaymentStatus.completed.name ||
          pStatus == 'paid' ||
          method == PaymentMethod.complimentary.name;

      final isCancelled = status == OrderStatus.cancelled.name;

      if (isPaidOrCompleted && !isCancelled) {
        validOrderCount++;
        grossSubtotalPaise += row.subtotal;
        totalDiscountPaise += row.discountTotal;
        platformFeePaise += row.platformFee;
        netRevenuePaise += row.grandTotal - row.platformFee;

        if (row.walletDeduction > 0) {
          walletPaise += row.walletDeduction;
        }

        if (method == PaymentMethod.cash.name) {
          cashPaise += row.grandTotal - row.platformFee;
        } else if (method == PaymentMethod.upi.name) {
          upiPaise += row.grandTotal - row.platformFee;
        } else if (method == PaymentMethod.complimentary.name) {
          freePaise += row.subtotal + row.taxTotal;
        }
      }
    }

    return (
      totalOrders: validOrderCount,
      grossSubtotal: grossSubtotalPaise / 100.0,
      totalDiscount: totalDiscountPaise / 100.0,
      platformFeeTotal: platformFeePaise / 100.0,
      netRevenue: netRevenuePaise / 100.0,
      cashCollected: cashPaise / 100.0,
      upiCollected: upiPaise / 100.0,
      walletCollected: walletPaise / 100.0,
      freeTotal: freePaise / 100.0,
    );
  }

  /// Computes collected payments summary categorized by Cash, UPI, and Free.
  static Future<
    ({
      double cashCollected,
      double upiCollected,
      double freeTotal,
      double totalCollected,
    })
  >
  calculatePaymentSummary({
    required ts.Database<DatabaseSchema> db,
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final summary = await calculateOrderSummary(
      db: db,
      merchantId: merchantId,
      storeId: storeId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return (
      cashCollected: summary.cashCollected,
      upiCollected: summary.upiCollected,
      freeTotal: summary.freeTotal,
      totalCollected: summary.netRevenue,
    );
  }
}
