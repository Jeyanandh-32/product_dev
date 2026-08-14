import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return methodNotAllowed();
  }

  final reference = context.request.uri.queryParameters['reference'];
  if (reference == null || reference.isEmpty) {
    return badRequest(message: 'Order reference is required.');
  }

  try {
    final db = Database.db;
    final orderRepo = OrderRepository(db: db);

    final orderRow = await db.orders
        .where((o) => o.orderReference.equals(toExpr(reference)))
        .first
        .fetch();

    if (orderRow == null) {
      return notFound(message: 'Order not found.');
    }

    // If order is still pending or failed, verify live payment status from PhonePe Status API
    if (orderRow.paymentStatus == PaymentStatus.pending.name ||
        orderRow.paymentStatus == PaymentStatus.failed.name) {
      final phonePeConfigRow = await db.storePhonepeConfigs
          .where((c) => c.storeId.equals(toExpr(orderRow.storeId)))
          .first
          .fetch();

      if (phonePeConfigRow != null) {
        final phonePeService = PhonePeService();
        final statusResult = await phonePeService.checkOrderStatus(
          config: phonePeConfigRow.toStorePhonePeConfig(),
          merchantOrderId: reference,
        );

        final state = (statusResult['state'] as String?) ??
            (statusResult['data'] is Map
                ? (statusResult['data'] as Map)['state'] as String?
                : null);

        final stateUpper = state?.toUpperCase();
        final itemRows = await OrderItemRepository(db: db).getAllForOrder(orderRow.id);
        final orderService = OrderService(
          orderRepo: orderRepo,
          orderItemRepo: OrderItemRepository(db: db),
          productRepo: ProductRepository(db: db),
          stockRepo: StockRepository(db: db),
        );

        if (stateUpper == 'COMPLETED') {
          await orderService.completeOrderPayment(
            orderRow: orderRow,
            orderItems: itemRows,
          );
        } else {
          // If state is FAILED, CANCELLED, DECLINED, EXPIRED, or not COMPLETED on verification redirect
          await orderService.cancelOrder(
            orderRow: orderRow,
          );
        }
      }
    }

    // Re-fetch updated row
    final updatedOrderRow = (await db.orders.byKey(orderRow.id).fetch())!;
    final itemRows = await OrderItemRepository(db: db).getAllForOrder(orderRow.id);
    final productRowsMap = <String, ProductRow>{};

    for (final item in itemRows) {
      if (!productRowsMap.containsKey(item.productId)) {
        final productResult = await ProductRepository(db: db).getById(item.productId);
        if (productResult != null) {
          productRowsMap[item.productId] = productResult.$1;
        }
      }
    }

    final order = updatedOrderRow.toOrder(itemRows, productRows: productRowsMap);
    return success(data: {'order': order.toJson()});
  } catch (e) {
    return error(message: e.toString());
  }
}
