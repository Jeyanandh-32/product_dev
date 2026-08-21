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
    int limit = 10,
    int offset = 0,
  }) async {
    var query = db.orders
        .where((o) => o.customerId.equals(ts.toExpr(customerId)))
        .where((o) => o.paymentStatus.equals(ts.toExpr(PaymentStatus.completed.name)));

    if (storeId != null && storeId.trim().isNotEmpty) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }

    if (date != null && date.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        final startOfDay = DateTime(parsed.year, parsed.month, parsed.day);
        final endOfDay = DateTime(parsed.year, parsed.month, parsed.day, 23, 59, 59, 999);
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
