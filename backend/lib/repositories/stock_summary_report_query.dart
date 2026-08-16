import 'package:backend/database/schema.dart';
import 'package:backend/repositories/stock_movement_calculator.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Database query and aggregator for stock movement and summary reports.
class StockSummaryReportQuery {
  const StockSummaryReportQuery({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Executes stock report aggregation including opening stock, in, out, wastage, adjustments, and closing stock.
  Future<
    ({
      int total,
      List<StockSummaryItem> items,
      int totalOpeningStock,
      int totalIn,
      int totalOut,
      int totalWastage,
      int totalAdjustment,
      int totalClosingStock,
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
    final products = await db.products
        .where((p) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final stocks = await db.stocks
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final stockMap = {for (final s in stocks) s.productId: s.quantity};

    final categories = await db.categories
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final counters = await db.counters
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final categoryMap = {for (final c in categories) c.id: c.name};
    final counterMap = {for (final c in counters) c.id: c.name};

    final allTx = await db.stockTransactions
        .where((t) => t.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final txByProduct = <String, List<StockTransactionRow>>{};
    for (final tx in allTx) {
      txByProduct.putIfAbsent(tx.productId, () => []).add(tx);
    }

    var reportItems = <StockSummaryItem>[];

    for (final p in products) {
      final productTx = txByProduct[p.id] ?? [];
      final currentStock = stockMap[p.id] ?? 0;
      final categoryName = p.categoryId != null
          ? (categoryMap[p.categoryId!] ?? 'Unassigned')
          : 'Unassigned';
      final counterName = p.counterId != null
          ? (counterMap[p.counterId!] ?? 'Unassigned')
          : 'Unassigned';

      final item = StockMovementCalculator.computeItemMetrics(
        product: p,
        productTx: productTx,
        currentStock: currentStock,
        categoryName: categoryName,
        counterName: counterName,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (item != null) {
        reportItems.add(item);
      }
    }

    var totalOpeningStock = 0;
    var totalIn = 0;
    var totalOut = 0;
    var totalWastage = 0;
    var totalAdjustment = 0;
    var totalClosingStock = 0;

    for (final item in reportItems) {
      totalOpeningStock += item.openingStock;
      totalIn += item.inQuantity;
      totalOut += item.outQuantity;
      totalWastage += item.wastageQuantity;
      totalAdjustment += item.adjustmentQuantity;
      totalClosingStock += item.closingStock;
    }

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
      totalOpeningStock: totalOpeningStock,
      totalIn: totalIn,
      totalOut: totalOut,
      totalWastage: totalWastage,
      totalAdjustment: totalAdjustment,
      totalClosingStock: totalClosingStock,
    );
  }
}
