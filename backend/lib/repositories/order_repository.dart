import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class OrderRepository {
  OrderRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;
  Future<OrderRow> create({
    required String merchantId,
    required String storeId,
    required String orderReference,
    required int billNo,
    required OrderSource source,
    required OrderType type,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    required int subtotal,
    required int discountTotal,
    required int taxTotal,
    required int grandTotal,
    String? terminalCode,
  }) async {
    final row = await _db.orders
        .insertValue(
          merchantId: merchantId,
          storeId: storeId,
          orderReference: orderReference,
          billNo: billNo,
          source: source.name,
          type: type.name,
          status: status.name,
          paymentStatus: paymentStatus.name,
          paymentMethod: paymentMethod.name,
          subtotal: subtotal,
          discountTotal: discountTotal,
          taxTotal: taxTotal,
          grandTotal: grandTotal,
          terminalCode: terminalCode,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<int> getNextBillNo(String storeId) async {
    final today = DateTime.now().toUtc();
    final startOfToday = DateTime.utc(today.year, today.month, today.day);

    final lastOrder = await _db.orders
        .where((o) => o.storeId.equals(ts.toExpr(storeId)))
        .where((o) => o.createdAt.isAfterValue(startOfToday))
        .orderBy((o) => [(o.billNo, ts.Order.descending)])
        .first
        .fetch();

    return (lastOrder?.billNo ?? 0) + 1;
  }

  Future<OrderRow?> update({
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? terminalCode,
  }) async {
    final row = _db.orders
        .byKey(id)
        .update(
          (o, set) => set(
            status: status != null ? ts.toExpr(status.name) : o.status,
            paymentStatus: paymentStatus != null
                ? ts.toExpr(paymentStatus.name)
                : o.paymentStatus,
            paymentMethod: paymentMethod != null
                ? ts.toExpr(paymentMethod.name)
                : o.paymentMethod,
            terminalCode: terminalCode != null
                ? ts.toExpr(terminalCode)
                : o.terminalCode,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }

  Future<List<OrderRow>> getAll({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
    int? limit,
    int? offset,
  }) async {
    var query = _db.orders.where(
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

    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where(
        (o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)),
      );
    }

    if (status != null && status.isNotEmpty) {
      query = query.where((o) => o.status.equals(ts.toExpr(status)));
    }

    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where(
        (o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)),
      );
    }

    if (offset != null) {
      query = query.offset(offset);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = query
        .orderBy((o) => [(o.createdAt, ts.Order.descending)])
        .fetch();

    return rows;
  }

  Future<int> count({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) async {
    var query = _db.orders.where(
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

    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      query = query.where(
        (o) => o.paymentMethod.equals(ts.toExpr(paymentMethod)),
      );
    }

    if (status != null && status.isNotEmpty) {
      query = query.where((o) => o.status.equals(ts.toExpr(status)));
    }

    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      query = query.where(
        (o) => o.paymentStatus.equals(ts.toExpr(paymentStatus)),
      );
    }

    final total = await query.count().fetch();
    return total ?? 0;
  }

  Future<OrderRow?> getById(String id) async {
    final row = _db.orders
        .where((o) => o.id.equals(ts.toExpr(id)))
        .first
        .fetch();

    return row;
  }

  Future<OrderRow?> getByIdOrBillNo(String idOrBillNo, String storeId) async {
    final billNo = int.tryParse(idOrBillNo);
    if (billNo != null) {
      final row = await _db.orders
          .where((o) => o.storeId.equals(ts.toExpr(storeId)))
          .where((o) => o.billNo.equals(ts.toExpr(billNo)))
          .first
          .fetch();
      if (row != null) return row;
    }

    final byId = await _db.orders
        .where((o) => o.id.equals(ts.toExpr(idOrBillNo)))
        .first
        .fetch();
    if (byId != null) return byId;

    return _db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(idOrBillNo)))
        .first
        .fetch();
  }

  Future<OrderRow?> getByReference(String reference) async {
    final row = _db.orders
        .where((o) => o.orderReference.equals(ts.toExpr(reference)))
        .first
        .fetch();

    return row;
  }

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
  getProfitLossReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) async {
    var orderQuery = _db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.storeId.equals(ts.toExpr(storeId)));

    if (fromDate != null) {
      orderQuery = orderQuery.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      orderQuery = orderQuery.where((o) => o.createdAt.isBeforeValue(toDate));
    }

    final orders = await orderQuery.fetch();
    final orderIds = orders.map((o) => o.id).toSet();

    final products = await _db.products
        .where((p) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final categories = await _db.categories
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final counters = await _db.counters
        .where((c) => c.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final categoryMap = {for (final c in categories) c.id: c.name};
    final counterMap = {for (final c in counters) c.id: c.name};

    final orderMap = {for (final o in orders) o.id: o};

    final soldQuantityMap = <String, int>{};
    final collectedPriceMap = <String, double>{};

    if (orderIds.isNotEmpty) {
      final items = await _db.orderItems
          .where((i) => i.storeId.equals(ts.toExpr(storeId)))
          .fetch();

      for (final item in items) {
        final order = orderMap[item.orderId];
        if (order == null) continue;

        soldQuantityMap[item.productId] =
            (soldQuantityMap[item.productId] ?? 0) + item.quantity;

        final isComplimentary =
            order.paymentMethod.toLowerCase() ==
            PaymentMethod.complimentary.name;
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
    }

    final stockAdjustments = await _db.stockTransactions
        .where((a) => a.storeId.equals(ts.toExpr(storeId)))
        .where(
          (a) => a.reason.equals(
            ts.toExpr(StockTransactionReason.wastage.name),
          ),
        )
        .fetch();

    final wastageLossMap = <String, double>{};
    final productBasePriceMap = {for (final p in products) p.id: p.basePrice};

    for (final a in stockAdjustments) {
      if (fromDate != null && a.createdAt.isBefore(fromDate)) continue;
      if (toDate != null && a.createdAt.isAfter(toDate)) continue;
      final basePricePaise = productBasePriceMap[a.productId] ?? 0;
      final loss = (basePricePaise * a.quantity) / 100.0;
      wastageLossMap[a.productId] = (wastageLossMap[a.productId] ?? 0.0) + loss;
    }

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
