import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
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

  final queryParams = context.request.uri.queryParameters;
  final fromDateStr = queryParams['fromDate'];
  final toDateStr = queryParams['toDate'];
  final paymentMethodStr = queryParams['paymentMethod'];
  final statusStr = queryParams['status'];
  final paymentStatusStr = queryParams['paymentStatus'];

  final fromDate = fromDateStr != null && fromDateStr.isNotEmpty
      ? DateTime.tryParse(fromDateStr)?.toUtc()
      : null;
  DateTime? toDate;
  if (toDateStr != null && toDateStr.isNotEmpty) {
    final parsed = DateTime.tryParse(toDateStr);
    if (parsed != null) {
      toDate = DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        23,
        59,
        59,
        999,
      );
    }
  }

  final orderRepo = context.read<OrderRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await orderRepo.count(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      fromDate: fromDate,
      toDate: toDate,
      paymentMethod: paymentMethodStr,
      status: statusStr,
      paymentStatus: paymentStatusStr,
    );

    final offset = (page - 1) * size;
    final orderRows = await orderRepo.getAll(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      fromDate: fromDate,
      toDate: toDate,
      paymentMethod: paymentMethodStr,
      status: statusStr,
      paymentStatus: paymentStatusStr,
      limit: size,
      offset: offset,
    );

    final orderSummary = await orderRepo.getOrderSummary(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      fromDate: fromDate,
      toDate: toDate,
    );

    final orders = orderRows
        .map((orderRow) => orderRow.toOrder(const []).toJson())
        .toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'summary': {
          'totalOrders': orderSummary.totalOrders,
          'grossSubtotal': orderSummary.grossSubtotal,
          'totalDiscount': orderSummary.totalDiscount,
          'netRevenue': orderSummary.netRevenue,
        },
        'orders': orders,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
