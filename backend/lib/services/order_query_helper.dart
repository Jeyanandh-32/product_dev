import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

/// Helper coordinating paginated order querying, customer/product resolution, and summary aggregation.
class OrderQueryHelper {
  const OrderQueryHelper._();

  /// Executes paginated query for orders matching filters.
  static Future<Response> fetchPaginatedOrders(RequestContext context) async {
    final storeIdError = context.validateStoreId();
    if (storeIdError != null) return storeIdError;

    final (pageError, page) = context.parsePage();
    if (pageError != null) return pageError;

    final (sizeError, size) = context.parseSize();
    if (sizeError != null) return sizeError;

    final queryParams = context.request.uri.queryParameters;
    final source = queryParams['source'];
    final terminalCode = queryParams['terminalCode'];
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
        toDate = DateTime.utc(parsed.year, parsed.month, parsed.day, 23, 59, 59, 999);
      }
    }

    final orderRepo = context.read<OrderRepository>();
    final itemRepo = context.read<OrderItemRepository>();
    final productRepo = context.read<ProductRepository>();
    final customerRepo = context.read<CustomerRepository>();
    final tokenPayload = context.tokenPayload;

    try {
      final total = await orderRepo.count(
        merchantId: tokenPayload.sub,
        storeId: context.storeId,
        source: source,
        terminalCode: terminalCode,
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
        source: source,
        terminalCode: terminalCode,
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

      final orders = <Map<String, dynamic>>[];
      for (final orderRow in orderRows) {
        final itemRows = await itemRepo.getAllForOrder(orderRow.id);
        final productRowsMap = <String, ProductRow>{};
        for (final item in itemRows) {
          if (!productRowsMap.containsKey(item.productId)) {
            final productResult = await productRepo.getById(item.productId);
            if (productResult != null) productRowsMap[item.productId] = productResult.$1;
          }
        }
        final customerRow = orderRow.customerId != null ? await customerRepo.getById(orderRow.customerId!) : null;
        orders.add(orderRow.toOrder(itemRows, productRows: productRowsMap, customerRow: customerRow).toJson());
      }

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
            'cashCollected': orderSummary.cashCollected,
            'upiCollected': orderSummary.upiCollected,
            'walletCollected': orderSummary.walletCollected,
            'freeTotal': orderSummary.freeTotal,
          },
          'orders': orders,
        },
      );
    } catch (e) {
      return error(message: e.toString());
    }
  }
}
