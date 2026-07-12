import 'dart:math';

import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
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

String _generateOrderReference() {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final suffix = List.generate(
    6,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
  return 'ORD-${DateTime.now().millisecondsSinceEpoch}-$suffix';
}

Future<Response> _onPost(RequestContext context) async {
  final tokenPayload = context.read<TokenPayload>();
  final body = await context.request.json() as Map<String, dynamic>;

  final validationError = await OrderValidator.create(body);
  if (validationError != null) {
    return badRequest(message: validationError);
  }

  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'Store ID is required.');
  }
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final merchantId = tokenPayload.sub;
  final terminalCode = tokenPayload.terminalCode;

  final productsList = body['products'] as List<dynamic>;

  final sourceStr = body['source'] as String? ?? 'terminal';
  final typeStr = body['type'] as String? ?? 'dineIn';
  final paymentMethodStr = body['paymentMethod'] as String? ?? 'cash';

  final source = OrderSource.values.firstWhere(
    (e) => e.name == sourceStr,
    orElse: () => OrderSource.terminal,
  );
  final type = OrderType.values.firstWhere(
    (e) => e.name == typeStr,
    orElse: () => OrderType.dineIn,
  );
  final paymentMethod = PaymentMethod.values.firstWhere(
    (e) => e.name == paymentMethodStr,
    orElse: () => PaymentMethod.cash,
  );

  const status = OrderStatus.completed;
  const paymentStatus = PaymentStatus.paid;

  final orderRepo = context.read<OrderRepository>();
  final orderItemRepo = context.read<OrderItemRepository>();
  final productRepo = context.read<ProductRepository>();
  final stockRepo = context.read<StockRepository>();

  final itemProductIds = productsList
      .map((e) => (e as Map<String, dynamic>)['productId'] as String)
      .toList();
  final products = await productRepo.getByIds(itemProductIds);
  final productMap = {for (final p in products) p.id: p};

  var calculatedSubtotal = 0;
  var calculatedTaxTotal = 0;
  final calculatedItems = <Map<String, dynamic>>[];

  for (final itemData in productsList) {
    final itemMap = itemData as Map<String, dynamic>;
    final productId = itemMap['productId'] as String;
    final quantity = itemMap['quantity'] as int;

    final product = productMap[productId];
    if (product == null) {
      return badRequest(message: 'Product with ID $productId not found.');
    }

    final unitPrice = product.sellingPrice;
    final taxRate = product.taxRate;

    final itemSubtotal = unitPrice * quantity;
    final itemTax = (itemSubtotal * taxRate) / 100.0;
    final roundedItemTax = itemTax.round();

    calculatedSubtotal += itemSubtotal;
    calculatedTaxTotal += roundedItemTax;

    calculatedItems.add({
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'taxRate': taxRate,
    });
  }

  final calculatedGrandTotal = calculatedSubtotal + calculatedTaxTotal;

  try {
    final completeOrder = await Database.db.transact(() async {
      final billNo = await orderRepo.getNextBillNo(storeId);
      final orderReference = _generateOrderReference();

      final orderRow = await orderRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        orderReference: orderReference,
        billNo: billNo,
        source: source,
        type: type,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        subtotal: calculatedSubtotal,
        taxTotal: calculatedTaxTotal,
        grandTotal: calculatedGrandTotal,
        terminalCode: terminalCode,
      );

      final createdItems = <OrderItemRow>[];
      for (final item in calculatedItems) {
        final productId = item['productId'] as String;
        final quantity = item['quantity'] as int;
        final unitPrice = item['unitPrice'] as int;
        final taxRate = item['taxRate'] as double;

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
