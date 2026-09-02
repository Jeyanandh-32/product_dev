import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final tokenPayload = context.tokenPayload;
  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final date = context.request.uri.queryParameters['date'];
  final storeId = context.request.uri.queryParameters['storeId'];
  final orderRepo = context.orderRepo;
  final offset = (page - 1) * size;

  try {
    final result = await orderRepo.getCustomerOrders(
      customerId: tokenPayload.sub,
      storeId: storeId,
      date: date,
      limit: size,
      offset: offset,
    );

    final orders = result.items;
    final total = result.total;
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages == 0 ? 1 : totalPages,
        'orders': orders.map((Order o) => o.toJson()).toList(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
