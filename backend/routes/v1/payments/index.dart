import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => methodNotAllowed(),
  };
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

    final payments = orderRows.map((row) {
      final order = row.toOrder(const <OrderItemRow>[]);
      final isPaid = order.paymentStatus == PaymentStatus.paid;
      return Payment(
        id: order.id,
        orderReference: order.orderReference,
        orderId: '${order.billNo}',
        orderAmount: order.grandTotal,
        paidAmount: isPaid ? order.grandTotal : 0.0,
        paymentMode: order.paymentMethod,
        date: order.createdAt,
      );
    }).toList();

    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'payments': payments,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
