import 'package:backend/database/schema.dart';
import 'package:backend/repositories/profit_loss_calculator.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database query and calculator helper for merchant profit & loss analytics.
class ProfitLossReportQuery {
  const ProfitLossReportQuery({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Executes profit and loss aggregation across orders, order items, and stock wastage.
  Future<
    ({
      int total,
      List<ProfitLossItem> items,
      double totalCostPrice,
      double totalCollectedPrice,
      double totalProfit,
      double totalMarginPercentage,
    })
  >
  execute({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) async {
    var orderQuery = db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.storeId.equals(ts.toExpr(storeId)));

    if (fromDate != null) {
      orderQuery = orderQuery.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      orderQuery = orderQuery.where((o) => o.createdAt.isBeforeValue(toDate));
    }

    final rawOrders = await orderQuery.fetch();
    final orders = rawOrders.where((o) {
      final pStatus = o.paymentStatus.toLowerCase();
      final status = o.status.toLowerCase();
      final isPaidOrCompleted =
          pStatus == PaymentStatus.completed.name ||
          o.paymentMethod.toLowerCase() == PaymentMethod.complimentary.name;
      final isCancelled = status == OrderStatus.cancelled.name;
      return isPaidOrCompleted && !isCancelled;
    }).toList();

    final orderIds = orders.map((o) => o.id).toSet();

    final products = await db.products
        .where((p) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final categories = await db.categories
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final counters = await db.counters
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final categoryMap = {for (final c in categories) c.id: c.name};
    final counterMap = {for (final c in counters) c.id: c.name};
    final orderMap = {for (final o in orders) o.id: o};

    var soldQuantityMap = <String, int>{};
    var collectedPriceMap = <String, double>{};

    if (orderIds.isNotEmpty) {
      final items = await db.orderItems
          .where((i) => i.storeId.equals(ts.toExpr(storeId)))
          .fetch();

      final salesData = ProfitLossCalculator.computeSalesAndCollectedRevenue(
        items: items,
        orderMap: orderMap,
      );
      soldQuantityMap = salesData.soldQuantityMap;
      collectedPriceMap = salesData.collectedPriceMap;
    }

    final stockAdjustments = await db.stockTransactions
        .where((a) => a.storeId.equals(ts.toExpr(storeId)))
        .where(
          (a) => a.reason.equals(ts.toExpr(StockTransactionReason.wastage.name)),
        )
        .fetch();

    final wastageLossMap = ProfitLossCalculator.computeWastageLosses(
      stockAdjustments: stockAdjustments,
      productBasePriceMap: {for (final p in products) p.id: p.basePrice},
      fromDate: fromDate,
      toDate: toDate,
    );

    var reportItems = <ProfitLossItem>[];

    for (final p in products) {
      final soldQty = soldQuantityMap[p.id] ?? 0;
      final wastageLoss = wastageLossMap[p.id] ?? 0.0;
      if (soldQty <= 0 && wastageLoss <= 0) continue;

      final collectedPrice = collectedPriceMap[p.id] ?? 0.0;
      final costPrice = (p.basePrice / 100.0) * soldQty;
      final profit = collectedPrice - costPrice - wastageLoss;
      final totalBase = costPrice + wastageLoss;
      final percentage = totalBase > 0 ? (profit / totalBase) * 100.0 : 0.0;

      final categoryName = p.categoryId != null
          ? (categoryMap[p.categoryId!] ?? 'Unassigned')
          : 'Unassigned';
      final counterName = p.counterId != null
          ? (counterMap[p.counterId!] ?? 'Unassigned')
          : 'Unassigned';

      reportItems.add(
        ProfitLossItem(
          productId: p.id,
          productName: p.name,
          categoryName: categoryName,
          counterName: counterName,
          soldQuantity: soldQty,
          costPrice: costPrice,
          collectedPrice: collectedPrice,
          profit: profit,
          profitLossPercentage: percentage,
        ),
      );
    }

    var totalCostPrice = 0.0;
    var totalCollectedPrice = 0.0;
    for (final item in reportItems) {
      totalCostPrice += item.costPrice;
      totalCollectedPrice += item.collectedPrice;
    }

    final totalProfit = totalCollectedPrice - totalCostPrice;
    final totalMarginPercentage = totalCostPrice > 0
        ? (totalProfit / totalCostPrice) * 100.0
        : 0.0;

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      reportItems = reportItems.where((item) {
        return item.productName.toLowerCase().contains(query) ||
            item.categoryName.toLowerCase().contains(query) ||
            item.counterName.toLowerCase().contains(query);
      }).toList();
    }

    final total = reportItems.length;
    final paginatedItems = reportItems.skip(offset).take(limit).toList();

    return (
      total: total,
      items: paginatedItems,
      totalCostPrice: totalCostPrice,
      totalCollectedPrice: totalCollectedPrice,
      totalProfit: totalProfit,
      totalMarginPercentage: totalMarginPercentage,
    );
  }
}
