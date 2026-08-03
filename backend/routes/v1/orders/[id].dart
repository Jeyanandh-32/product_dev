import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    .get => _onGet(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final orderRepo = context.read<OrderRepository>();
  final orderItemRepo = context.read<OrderItemRepository>();
  final productRepo = context.read<ProductRepository>();

  try {
    final orderRow = await orderRepo.getByIdOrBillNo(id, context.storeId);
    if (orderRow == null) {
      return notFound(message: 'Order not found.');
    }

    final itemRows = await orderItemRepo.getAllForOrder(id);
    final productRowsMap = <String, ProductRow>{};

    for (final item in itemRows) {
      if (!productRowsMap.containsKey(item.productId)) {
        final productResult = await productRepo.getById(item.productId);
        if (productResult != null) {
          productRowsMap[item.productId] = productResult.$1;
        }
      }
    }

    final order = orderRow.toOrder(itemRows, productRows: productRowsMap);

    return success(data: {'order': order.toJson()});
  } catch (e) {
    return error(message: e.toString());
  }
}
