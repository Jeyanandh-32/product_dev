import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Fetches customer order history and resolves related products and items via batch queries.
class CustomerOrdersQuery {
  const CustomerOrdersQuery._();

  /// Fetches paginated orders belonging to a customer with their line items using high-performance batch fetching.
  static Future<({List<Order> items, int total})> fetchCustomerOrders({
    required ts.Database<DatabaseSchema> db,
    required String customerId,
    String? storeId,
    String? date,
    String? fromDate,
    String? toDate,
    int limit = 10,
    int offset = 0,
  }) async {
    var query = db.orders
        .where((o) => o.customerId.equals(ts.toExpr(customerId)))
        .where((o) => o.paymentStatus.equals(ts.toExpr(PaymentStatus.completed.name)));

    if (storeId != null && storeId.trim().isNotEmpty) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }

    final parsedFrom = AppDateQueryHelper.parseQueryFromDate(fromDate);
    if (parsedFrom != null) {
      query = query.where((o) => o.createdAt.isAfterValue(parsedFrom.subtract(const Duration(milliseconds: 1))));
    }
    final parsedTo = AppDateQueryHelper.parseQueryToDate(toDate);
    if (parsedTo != null) {
      query = query.where((o) => o.createdAt.isBeforeValue(parsedTo.add(const Duration(milliseconds: 1))));
    } else if (date != null && date.trim().isNotEmpty && (fromDate == null || fromDate.isEmpty)) {
      final startOfDay = AppDateQueryHelper.parseQueryFromDate(date);
      final endOfDay = AppDateQueryHelper.parseQueryToDate(date);
      if (startOfDay != null && endOfDay != null) {
        query = query
            .where((o) => o.createdAt.isAfterValue(startOfDay.subtract(const Duration(milliseconds: 1))))
            .where((o) => o.createdAt.isBeforeValue(endOfDay.add(const Duration(milliseconds: 1))));
      }
    }

    final rows = await query.fetch();
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final total = rows.length;
    final paginatedRows = rows.skip(offset).take(limit).toList();

    final itemRepo = OrderItemRepository(db: db);
    final productRepo = ProductRepository(db: db);

    final orderIds = paginatedRows.map((o) => o.id).toList();
    final allItems = await itemRepo.getAllForOrders(orderIds);

    final itemsByOrderId = <String, List<OrderItemRow>>{};
    final productIds = <String>{};
    for (final item in allItems) {
      itemsByOrderId.putIfAbsent(item.orderId, () => []).add(item);
      productIds.add(item.productId);
    }

    final productRowsList = await productRepo.getByIds(productIds.toList());
    final productRowsMap = {for (final p in productRowsList) p.id: p};

    final orders = paginatedRows
        .map((o) => o.toOrder(itemsByOrderId[o.id] ?? const [], productRows: productRowsMap))
        .toList();

    return (items: orders, total: total);
  }
}
