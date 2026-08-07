import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class StockRepository {
  StockRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

  Future<StockRow> create({
    required String productId,
    required String storeId,
  }) async {
    final row = await _db.stocks
        .insertValue(
          productId: productId,
          storeId: storeId,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<StockRow?> update({
    required String id,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    String? transactionType,
    int? amount,
    String? reason,
    String? customReason,
  }) async {
    final stockRows = await _db.stocks
        .where((ts.Expr<StockRow> s) => s.id.equalsValue(id))
        .fetch();

    if (stockRows.isEmpty) return null;
    final stockRow = stockRows.first;

    if (transactionType != null && amount != null && reason != null) {
      var actualType = transactionType;
      var actualAmount = amount;

      if (transactionType == 'set' && quantity != null) {
        final delta = quantity - stockRow.quantity;
        if (delta > 0) {
          actualType = 'add';
          actualAmount = delta;
        } else if (delta < 0) {
          actualType = 'reduce';
          actualAmount = delta.abs();
        } else {
          actualAmount = 0;
        }
      }

      var actualReason = reason;
      if (actualType == 'add') {
        actualReason = 'restock';
      }

      if (actualAmount > 0) {
        await _db.stockTransactions
            .insertValue(
              productId: stockRow.productId,
              storeId: stockRow.storeId,
              adjustmentType: actualType,
              quantity: actualAmount,
              reason: actualReason,
              customReason: customReason,
            )
            .execute();
      }
    }

    final rows = await _db.stocks
        .where((ts.Expr<StockRow> s) => s.id.equalsValue(id))
        .update(
          (s, set) => set(
            quantity: quantity != null ? ts.toExpr(quantity) : s.quantity,
            lowStockThreshold: lowStockThreshold != null
                ? ts.toExpr(lowStockThreshold)
                : s.lowStockThreshold,
            stockMonitor: stockMonitor != null
                ? ts.toExpr(stockMonitor)
                : s.stockMonitor,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<StockRow?> getByProductAndStore({
    required String productId,
    required String storeId,
  }) async {
    final rows = await _db.stocks
        .where((s) => s.productId.equals(ts.toExpr(productId)))
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<StockRow?> deductStock({
    required String productId,
    required String storeId,
    required int quantityToDeduct,
  }) async {
    final rows = await _db.stocks
        .where((s) => s.productId.equals(ts.toExpr(productId)))
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .update(
          (s, set) => set(
            quantity: s.quantity.subtractValue(quantityToDeduct),
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    if (rows.isEmpty) return null;
    return rows.first;
  }

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
  getStockSummaryReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) async {
    final products = await _db.products
        .where((p) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final stocks = await _db.stocks
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final stockMap = {for (final s in stocks) s.productId: s.quantity};

    final categories = await _db.categories
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final counters = await _db.counters
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final categoryMap = {for (final c in categories) c.id: c.name};
    final counterMap = {for (final c in counters) c.id: c.name};

    final allTx = await _db.stockTransactions
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

      final categoryName = p.categoryId != null
          ? (categoryMap[p.categoryId!] ?? 'Unassigned')
          : 'Unassigned';
      final counterName = p.counterId != null
          ? (counterMap[p.counterId!] ?? 'Unassigned')
          : 'Unassigned';

      reportItems.add(
        StockSummaryItem(
          productId: p.id,
          productName: p.name,
          categoryName: categoryName,
          counterName: counterName,
          openingStock: openingStock,
          inQuantity: inQty,
          outQuantity: outQty,
          wastageQuantity: wastageQty,
          adjustmentQuantity: adjQty,
          closingStock: closingStock,
        ),
      );
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
