import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class OrderRepository {
  OrderRepository({required this._db});

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

  Future<
    ({
      int totalOrders,
      double grossSubtotal,
      double totalDiscount,
      double netRevenue,
    })
  >
  getOrderSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
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

    final rows = await query.fetch();

    var grossSubtotalPaise = 0;
    var totalDiscountPaise = 0;
    var netRevenuePaise = 0;

    for (final row in rows) {
      grossSubtotalPaise += row.subtotal;
      totalDiscountPaise += row.discountTotal;
      netRevenuePaise += row.grandTotal;
    }

    return (
      totalOrders: rows.length,
      grossSubtotal: grossSubtotalPaise / 100.0,
      totalDiscount: totalDiscountPaise / 100.0,
      netRevenue: netRevenuePaise / 100.0,
    );
  }

  Future<
    ({
      double cashCollected,
      double upiCollected,
      double freeTotal,
      double totalCollected,
    })
  >
  getPaymentSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
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

    final rows = await query.fetch();

    var cashPaise = 0;
    var upiPaise = 0;
    var freePaise = 0;
    var totalPaise = 0;

    for (final row in rows) {
      final isPaid = row.paymentStatus.toLowerCase() == 'paid';
      final method = row.paymentMethod.toLowerCase();

      if (method == 'cash') {
        if (isPaid) cashPaise += row.grandTotal;
      } else if (method == 'upi') {
        if (isPaid) upiPaise += row.grandTotal;
      } else if (method == 'complimentary') {
        freePaise += row.subtotal + row.taxTotal;
      }

      if (isPaid) {
        totalPaise += row.grandTotal;
      }
    }

    return (
      cashCollected: cashPaise / 100.0,
      upiCollected: upiPaise / 100.0,
      freeTotal: freePaise / 100.0,
      totalCollected: totalPaise / 100.0,
    );
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

  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    var query = _db.orders
        .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
        .where((o) => o.storeId.equals(ts.toExpr(storeId)));

    if (fromDate != null) {
      query = query.where((o) => o.createdAt.isAfterValue(fromDate));
    }
    if (toDate != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(toDate));
    }

    final orderRows = await query
        .orderBy((o) => [(o.createdAt, ts.Order.descending)])
        .fetch();

    var totalRevenuePaise = 0;
    var upiPaise = 0;
    var cashPaise = 0;
    var paidPaise = 0;
    var freePaise = 0;
    var paidCount = 0;
    var freeCount = 0;

    final hourlyCounts = List<int>.filled(8, 0);

    for (final o in orderRows) {
      final hour = o.createdAt.toLocal().hour;
      if (hour >= 8 && hour < 10) {
        hourlyCounts[0]++;
      } else if (hour >= 10 && hour < 12) {
        hourlyCounts[1]++;
      } else if (hour >= 12 && hour < 14) {
        hourlyCounts[2]++;
      } else if (hour >= 14 && hour < 16) {
        hourlyCounts[3]++;
      } else if (hour >= 16 && hour < 18) {
        hourlyCounts[4]++;
      } else if (hour >= 18 && hour < 20) {
        hourlyCounts[5]++;
      } else if (hour >= 20 && hour < 22) {
        hourlyCounts[6]++;
      } else {
        hourlyCounts[7]++;
      }

      final isComplimentary =
          o.paymentMethod.toLowerCase() == PaymentMethod.complimentary.name ||
          o.paymentStatus.toLowerCase() == PaymentStatus.refunded.name;

      if (!isComplimentary) {
        totalRevenuePaise += o.grandTotal;
        paidPaise += o.grandTotal;
        paidCount++;
      } else {
        freePaise += o.subtotal > 0 ? o.subtotal : 100;
        freeCount++;
      }

      if (o.paymentMethod.toLowerCase() == PaymentMethod.upi.name) {
        upiPaise += o.grandTotal;
      } else if (o.paymentMethod.toLowerCase() == PaymentMethod.cash.name) {
        cashPaise += o.grandTotal;
      }
    }

    final totalOrders = orderRows.length;
    final totalRevenue = totalRevenuePaise / 100.0;
    final aov = totalOrders > 0 ? (totalRevenue / totalOrders) : 0.0;

    final stocks = await _db.stocks
        .where((s) => s.storeId.equals(ts.toExpr(storeId)))
        .fetch();
    final lowStockCount = stocks
        .where((s) => s.quantity <= s.lowStockThreshold)
        .length;

    // Previous period comparison for growth percentage
    var revenueGrowth = 0.0;
    var ordersGrowth = 0.0;
    var aovGrowth = 0.0;

    if (fromDate != null) {
      final now = toDate ?? DateTime.now().toUtc();
      final duration = now.difference(fromDate);
      final prevFromDate = fromDate.subtract(duration);
      final prevToDate = fromDate;

      final prevRows = await _db.orders
          .where((o) => o.merchantId.equals(ts.toExpr(merchantId)))
          .where((o) => o.storeId.equals(ts.toExpr(storeId)))
          .where((o) => o.createdAt.isAfterValue(prevFromDate))
          .where((o) => o.createdAt.isBeforeValue(prevToDate))
          .fetch();

      var prevRevenuePaise = 0;
      for (final p in prevRows) {
        final isComp =
            p.paymentMethod.toLowerCase() == PaymentMethod.complimentary.name ||
            p.paymentStatus.toLowerCase() == PaymentStatus.refunded.name;
        if (!isComp) prevRevenuePaise += p.grandTotal;
      }

      final prevRevenue = prevRevenuePaise / 100.0;
      final prevOrders = prevRows.length;
      final prevAov = prevOrders > 0 ? (prevRevenue / prevOrders) : 0.0;

      if (prevRevenue > 0) {
        revenueGrowth = ((totalRevenue - prevRevenue) / prevRevenue) * 100.0;
      } else if (totalRevenue > 0) {
        revenueGrowth = 100.0;
      }

      if (prevOrders > 0) {
        ordersGrowth = ((totalOrders - prevOrders) / prevOrders) * 100.0;
      } else if (totalOrders > 0) {
        ordersGrowth = 100.0;
      }

      if (prevAov > 0) {
        aovGrowth = ((aov - prevAov) / prevAov) * 100.0;
      } else if (aov > 0) {
        aovGrowth = 100.0;
      }
    }

    final productRows = await _db.products
        .leftJoin(_db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(_db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .where((p, s, c) => p.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final orderItemTuples = await _db.orderItems
        .leftJoin(_db.orders)
        .on((item, o) => item.orderId.equals(o.id))
        .leftJoin(_db.products)
        .on((item, o, p) => item.productId.equals(p.id))
        .leftJoin(_db.categories)
        .on((item, o, p, c) => p.categoryId.equals(c.id))
        .where((item, o, p, c) => item.storeId.equals(ts.toExpr(storeId)))
        .fetch();

    final categoryMap = <String, double>{};
    for (final tuple in orderItemTuples) {
      final item = tuple.$1;
      final o = tuple.$2;
      final c = tuple.$4;

      if (o != null) {
        if (fromDate != null && o.createdAt.isBefore(fromDate)) continue;
        if (toDate != null && o.createdAt.isAfter(toDate)) continue;
      }

      final catName = c?.name ?? 'General';
      final itemTotal = (item.quantity * item.unitPrice) / 100.0;
      categoryMap[catName] = (categoryMap[catName] ?? 0.0) + itemTotal;
    }

    final categoryLabels = categoryMap.isEmpty
        ? <String>[]
        : categoryMap.keys.take(5).toList();
    final categoryData = categoryLabels
        .map((cat) => categoryMap[cat] ?? 0.0)
        .toList();

    final productSalesMap =
        <
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
        if (fromDate != null && o.createdAt.isBefore(fromDate)) continue;
        if (toDate != null && o.createdAt.isAfter(toDate)) continue;
      }

      final pId = item.productId;
      final name = p?.name ?? 'Unknown Product';
      final categoryName = c?.name ?? 'General';
      final current = productSalesMap[pId];

      final qty = item.quantity;
      final rev = item.quantity * item.unitPrice;

      if (current == null) {
        productSalesMap[pId] = (
          name: name,
          category: categoryName,
          totalQuantitySold: qty,
          totalRevenuePaise: rev,
        );
      } else {
        productSalesMap[pId] = (
          name: name,
          category: categoryName,
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

    final lowStockProducts = productRows
        .where((tuple) {
          final s = tuple.$2;
          return s != null && s.quantity <= s.lowStockThreshold;
        })
        .take(5)
        .map((tuple) {
          final p = tuple.$1;
          final s = tuple.$2;
          final c = tuple.$3;
          return {
            'id': p.id,
            'name': p.name,
            'category': c?.name ?? 'General',
            'quantity': s?.quantity ?? 0,
            'lowStockThreshold': s?.lowStockThreshold ?? 5,
            'sellingPrice': p.sellingPrice,
          };
        })
        .toList();

    return {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'aov': aov,
      'lowStockCount': lowStockCount,
      'revenueGrowth': revenueGrowth,
      'ordersGrowth': ordersGrowth,
      'aovGrowth': aovGrowth,
      'paymentMethods': {
        'upiTotal': upiPaise / 100.0,
        'cashTotal': cashPaise / 100.0,
      },
      'paymentStatus': {
        'paidTotal': paidPaise / 100.0,
        'freeTotal': freePaise / 100.0,
        'paidCount': paidCount,
        'freeCount': freeCount,
      },
      'categorySales': {
        'labels': categoryLabels,
        'data': categoryData,
      },
      'hourlyTraffic': {
        'labels': [
          '8 AM',
          '10 AM',
          '12 PM',
          '2 PM',
          '4 PM',
          '6 PM',
          '8 PM',
          '10 PM',
        ],
        'data': hourlyCounts,
      },
      'topProducts': topProducts,
      'lowStockProducts': lowStockProducts,
    };
  }
}
