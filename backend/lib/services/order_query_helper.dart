import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// Helper coordinating paginated order querying, batch item/product/customer resolution, and summary aggregation.
class OrderQueryHelper {
  const OrderQueryHelper._();

  /// Executes high-performance paginated batch query for orders matching filters.
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

    final fromDate = AppDateQueryHelper.parseQueryFromDate(fromDateStr);
    final toDate = AppDateQueryHelper.parseQueryToDate(toDateStr);

    final orderRepo = context.orderRepo;
    final itemRepo = context.orderItemRepo;
    final productRepo = context.productRepo;
    final customerRepo = context.customerRepo;
    final tokenPayload = context.tokenPayload;

    try {
      final offset = (page - 1) * size;
      final totalFuture = orderRepo.count(
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

      final orderRowsFuture = orderRepo.getAll(
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

      final orderSummaryFuture = orderRepo.getOrderSummary(
        merchantId: tokenPayload.sub,
        storeId: context.storeId,
        fromDate: fromDate,
        toDate: toDate,
      );

      final (total, orderRows, orderSummary) = await (
        totalFuture,
        orderRowsFuture,
        orderSummaryFuture,
      ).wait;

      final orderIds = orderRows.map((o) => o.id).toList();
      final allItems = await itemRepo.getAllForOrders(orderIds);

      final itemsByOrderId = <String, List<OrderItemRow>>{};
      final productIds = <String>{};
      for (final item in allItems) {
        itemsByOrderId.putIfAbsent(item.orderId, () => []).add(item);
        productIds.add(item.productId);
      }

      final productRowsList = await productRepo.getByIds(productIds.toList());
      final productRowsMap = {for (final p in productRowsList) p.id: p};

      final customerIds = orderRows
          .map((o) => o.customerId)
          .whereType<String>()
          .toSet()
          .toList();
      final customerRowsList = await customerRepo.getByIds(customerIds);
      final customerRowsMap = {for (final c in customerRowsList) c.id: c};

      final orders = <Map<String, dynamic>>[];
      for (final orderRow in orderRows) {
        final itemRows = itemsByOrderId[orderRow.id] ?? const [];
        final customerRow = orderRow.customerId != null
            ? customerRowsMap[orderRow.customerId]
            : null;
        orders.add(
          orderRow
              .toOrder(
                itemRows,
                productRows: productRowsMap,
                customerRow: customerRow,
              )
              .toJson(),
        );
      }

      final totalPages = (total / size).ceil();

      return success(
        data: {
          'currentPage': page,
          'pageSize': size,
          'totalItems': total,
          'totalPages': totalPages,
          'summary': orderSummary.toJson(),
          'orders': orders,
        },
      );
    } catch (e) {
      return error(message: e.toString());
    }
  }
}
