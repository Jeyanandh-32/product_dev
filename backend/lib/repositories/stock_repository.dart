import 'package:backend/database/schema.dart';
import 'package:backend/repositories/stock_summary_report_query.dart';
import 'package:backend/repositories/stock_transaction_logger.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling product inventory records, updates, and stock movement reports.
class StockRepository {
  StockRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  /// Creates initial inventory tracking row for a newly created product.
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

  /// Updates inventory quantity and logs an audit stock transaction if adjustment data is provided.
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

    await StockTransactionLogger.logAdjustment(
      db: _db,
      stockRow: stockRow,
      targetQuantity: quantity,
      transactionType: transactionType,
      amount: amount,
      reason: reason,
      customReason: customReason,
    );

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

  /// Retrieves inventory record for a specific product within a store.
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

  /// Decrements stock inventory upon order checkout.
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

  /// Computes comprehensive stock movement summary report using [StockSummaryReportQuery].
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
  }) {
    return StockSummaryReportQuery(db: _db).execute(
      merchantId: merchantId,
      storeId: storeId,
      fromDate: fromDate,
      toDate: toDate,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
}
