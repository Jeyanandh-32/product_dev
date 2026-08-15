import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Aggregates sales by product and by category for dashboard graphs and top-sellers lists.
class DashboardSalesAggregator {
  const DashboardSalesAggregator._();

  /// Extracts top selling products and sales distribution per category.
  static ({
    Map<String, double> categorySales,
    List<Map<String, dynamic>> topProducts,
  }) aggregateItemSales(
    List<(OrderItemRow, OrderRow?, ProductRow?, CategoryRow?)> orderItemTuples, {
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final categoryMap = <String, double>{};
    final productSalesMap = <
      String,
      ({
        String name,
        String category,
        int totalQuantitySold,
        int totalRevenuePaise,
      })
    >{};

    for (final tuple in orderItemTuples) {
      final item = tuple.$1;
      final o = tuple.$2;
      final p = tuple.$3;
      final c = tuple.$4;

      if (o != null) {
        final pStatus = o.paymentStatus.toLowerCase();
        final status = o.status.toLowerCase();
        final isPaidOrCompleted =
            pStatus == PaymentStatus.completed.name ||
            o.paymentMethod.toLowerCase() == PaymentMethod.complimentary.name;
        final isCancelled = status == OrderStatus.cancelled.name;
        if (!isPaidOrCompleted || isCancelled) continue;

        if (fromDate != null && o.createdAt.isBefore(fromDate)) continue;
        if (toDate != null && o.createdAt.isAfter(toDate)) continue;
      } else {
        continue;
      }

      final catName = c?.name ?? 'General';
      final itemTotal = (item.quantity * item.unitPrice) / 100.0;
      categoryMap[catName] = (categoryMap[catName] ?? 0.0) + itemTotal;

      final pId = item.productId;
      final name = p?.name ?? 'Unknown Product';
      final current = productSalesMap[pId];

      final qty = item.quantity;
      final rev = item.quantity * item.unitPrice;

      if (current == null) {
        productSalesMap[pId] = (
          name: name,
          category: catName,
          totalQuantitySold: qty,
          totalRevenuePaise: rev,
        );
      } else {
        productSalesMap[pId] = (
          name: name,
          category: catName,
          totalQuantitySold: current.totalQuantitySold + qty,
          totalRevenuePaise: current.totalRevenuePaise + rev,
        );
      }
    }

    final sortedTopSales = productSalesMap.values.toList()
      ..sort((a, b) => b.totalQuantitySold.compareTo(a.totalQuantitySold));

    final topProducts = sortedTopSales.take(5).map((p) {
      return {
        'name': p.name,
        'category': p.category,
        'quantitySold': p.totalQuantitySold,
        'totalRevenue': p.totalRevenuePaise,
      };
    }).toList();

    return (
      categorySales: categoryMap,
      topProducts: topProducts,
    );
  }
}
