import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    .get => _onGet(context, id),
    .patch => _onPatch(context, id),
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
    if (orderRow == null) return notFound(message: 'Order not found.');

    final itemRows = await orderItemRepo.getAllForOrder(orderRow.id);
    final productIds = itemRows.map((i) => i.productId).toSet().toList();
    final productRowsList = await productRepo.getByIds(productIds);
    final productRowsMap = {for (final p in productRowsList) p.id: p};

    final order = orderRow.toOrder(itemRows, productRows: productRowsMap);
    return success(data: {'order': order.toJson()});
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPatch(RequestContext context, String id) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final orderRepo = context.read<OrderRepository>();
  final orderItemRepo = context.read<OrderItemRepository>();
  final productRepo = context.read<ProductRepository>();

  try {
    final orderRow = await orderRepo.getByIdOrBillNo(id, context.storeId);
    if (orderRow == null) return notFound(message: 'Order not found.');

    final body = await context.request.json() as Map<String, dynamic>;
    final statusStr = body['status'] as String?;
    final paymentStatusStr = body['paymentStatus'] as String?;
    final paymentMethodStr = body['paymentMethod'] as String?;

    final status = statusStr != null ? OrderStatus.values.where((e) => e.name == statusStr).firstOrNull : null;
    final paymentStatus = paymentStatusStr != null ? PaymentStatus.values.where((e) => e.name == paymentStatusStr).firstOrNull : null;
    final paymentMethod = paymentMethodStr != null ? PaymentMethod.values.where((e) => e.name == paymentMethodStr).firstOrNull : null;

    final updatedRow = await orderRepo.update(
      id: orderRow.id,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
    );

    if (updatedRow == null) return error(message: 'Failed to update order.');

    final itemRows = await orderItemRepo.getAllForOrder(orderRow.id);
    final productIds = itemRows.map((i) => i.productId).toSet().toList();
    final productRowsList = await productRepo.getByIds(productIds);
    final productRowsMap = {for (final p in productRowsList) p.id: p};

    final order = updatedRow.toOrder(itemRows, productRows: productRowsMap);
    return success(data: {'order': order.toJson()});
  } catch (e) {
    return error(message: e.toString());
  }
}
