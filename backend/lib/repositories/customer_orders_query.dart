import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Fetches customer order history and resolves related products and items.
class CustomerOrdersQuery {
  const CustomerOrdersQuery._();

  /// Fetches paginated orders belonging to a customer with their line items.
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
        .where(
          (o) => o.paymentStatus.equals(ts.toExpr(PaymentStatus.completed.name)),
        );

    if (storeId != null && storeId.trim().isNotEmpty) {
      query = query.where((o) => o.storeId.equals(ts.toExpr(storeId)));
    }

    if (date != null && date.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        final startOfDay = DateTime(parsed.year, parsed.month, parsed.day);
        final endOfDay = DateTime(
          parsed.year,
          parsed.month,
          parsed.day,
          23,
          59,
          59,
          999,
        );
        query = query
            .where(
              (o) => o.createdAt.isAfterValue(
                startOfDay.subtract(const Duration(milliseconds: 1)),
              ),
            )
            .where(
              (o) => o.createdAt.isBeforeValue(
                endOfDay.add(const Duration(milliseconds: 1)),
              ),
            );
      }
    }

    final rows = await query.fetch();
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final total = rows.length;
    final paginatedRows = rows.skip(offset).take(limit).toList();

    final itemRepo = OrderItemRepository(db: db);
    final productRepo = ProductRepository(db: db);

    final orders = <Order>[];
    for (final orderRow in paginatedRows) {
      final itemRows = await itemRepo.getAllForOrder(orderRow.id);
      final productRowsMap = <String, ProductRow>{};
      for (final item in itemRows) {
        if (!productRowsMap.containsKey(item.productId)) {
          final res = await productRepo.getById(item.productId);
          if (res != null) {
            productRowsMap[item.productId] = res.$1;
          }
        }
      }
      orders.add(orderRow.toOrder(itemRows, productRows: productRowsMap));
    }

    return (items: orders, total: total);
  }
}
