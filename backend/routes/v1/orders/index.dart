import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  try {
    final body = await context.validateBody(OrderValidator.create);
    final input = OrderCreate.fromJson(body);
    final tokenPayload = context.tokenPayload;
    final orderService = context.read<OrderService>();

    final productsList = input.products
        .map((p) => {'productId': p.productId, 'quantity': p.quantity})
        .toList();

    final source = OrderSource.values.firstWhere(
      (e) => e.name == input.source,
      orElse: () => OrderSource.terminal,
    );
    final type = OrderType.values.firstWhere(
      (e) => e.name == input.type,
      orElse: () => OrderType.dineIn,
    );
    final paymentMethod = PaymentMethod.values.firstWhere(
      (e) => e.name == input.paymentMethod,
      orElse: () => PaymentMethod.cash,
    );

    final completeOrder = await orderService.checkout(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      productsInput: productsList,
      source: source,
      type: type,
      paymentMethod: paymentMethod,
      terminalCode: tokenPayload.terminalCode,
    );

    return success(data: {'order': completeOrder});
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onGet(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final orderRepo = context.read<OrderRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await orderRepo.count(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
    );

    final offset = (page - 1) * size;
    final orderRows = await orderRepo.getAll(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      limit: size,
      offset: offset,
    );

    final orders = orderRows
        .map((orderRow) => orderRow.toOrder(const <OrderItemRow>[]).toJson())
        .toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'orders': orders,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
