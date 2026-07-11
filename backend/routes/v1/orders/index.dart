import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
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
  final tokenPayload = context.read<TokenPayload>();
  final body = await context.request.json() as Map<String, dynamic>;

  final validationError = await OrderValidator.create(body);
  if (validationError != null) {
    return badRequest(message: validationError);
  }

  final storeId = body['storeId'] as String;
  final orderReference = body['orderReference'] as String;
  final sourceStr = body['source'] as String;
  final typeStr = body['type'] as String;
  final paymentMethodStr = body['paymentMethod'] as String;
  final subtotal = body['subtotal'] as int;
  final taxTotal = body['taxTotal'] as int;
  final grandTotal = body['grandTotal'] as int;
  final terminalCode = body['terminalCode'] as String?;
  final items = body['items'] as List<dynamic>;

  if (tokenPayload.role == UserRole.terminal &&
      terminalCode != tokenPayload.terminalCode) {
    return unauthorized(message: 'Unauthorized terminal code.');
  }

  final source = OrderSource.values.firstWhere((e) => e.name == sourceStr);
  final type = OrderType.values.firstWhere((e) => e.name == typeStr);
  final paymentMethod = PaymentMethod.values.firstWhere(
    (e) => e.name == paymentMethodStr,
  );

  const status = OrderStatus.completed;
  const paymentStatus = PaymentStatus.paid;

  final orderRepo = context.read<OrderRepository>();
  final orderItemRepo = context.read<OrderItemRepository>();
  final stockRepo = context.read<StockRepository>();

  try {
    final completeOrder = await Database.db.transact(() async {
      final billNo = await orderRepo.getNextBillNo(storeId);

      final orderRow = await orderRepo.create(
        merchantId: tokenPayload.sub,
        storeId: storeId,
        orderReference: orderReference,
        billNo: billNo,
        source: source,
        type: type,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        taxTotal: taxTotal,
        grandTotal: grandTotal,
        terminalCode: terminalCode,
      );

      final createdItems = <OrderItemRow>[];
      for (final itemData in items) {
        final itemMap = itemData as Map<String, dynamic>;
        final productId = itemMap['productId'] as String;
        final quantity = itemMap['quantity'] as int;
        final unitPrice = itemMap['unitPrice'] as int;
        final taxRate = (itemMap['taxRate'] as num).toDouble();

        final orderItem = await orderItemRepo.create(
          orderId: orderRow.id,
          productId: productId,
          storeId: storeId,
          quantity: quantity,
          unitPrice: unitPrice,
          taxRate: taxRate,
        );
        createdItems.add(orderItem);

        await stockRepo.deductStock(
          productId: productId,
          storeId: storeId,
          quantityToDeduct: quantity,
        );
      }

      return orderRow.toOrder(createdItems);
    });

    return success(data: {'order': completeOrder});
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onGet(RequestContext context) async {
  final tokenPayload = context.read<TokenPayload>();
  final orderRepo = context.read<OrderRepository>();

  final parameters = context.request.uri.queryParameters;

  final storeId = parameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'Store ID is required.');
  }
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final limitStr = parameters['limit'];
  final offsetStr = parameters['offset'];

  int? limit;
  if (limitStr != null && limitStr.isNotEmpty) {
    limit = int.tryParse(limitStr);
    if (limit == null || limit <= 0) {
      return badRequest(message: 'limit must be a positive integer.');
    }
  }

  int? offset;
  if (offsetStr != null && offsetStr.isNotEmpty) {
    offset = int.tryParse(offsetStr);
    if (offset == null || offset < 0) {
      return badRequest(message: 'offset must be a non-negative integer.');
    }
  }

  try {
    final orderRows = await orderRepo.getAll(
      merchantId: tokenPayload.sub,
      storeId: storeId,
      limit: limit,
      offset: offset,
    );

    final orders = orderRows.map((orderRow) => orderRow.toOrder([])).toList();

    return success(data: {'orders': orders});
  } catch (e) {
    return error(message: e.toString());
  }
}
