import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

typedef OrderSummary = ({
  int totalOrders,
  double grossSubtotal,
  double totalDiscount,
  double netRevenue,
});

typedef OrderPaginatedResponse = ({
  List<Order> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
  OrderSummary summary,
});

abstract final class OrderRepository {
  static Future<Order> create({
    required String storeId,
    required List<Map<String, dynamic>> products,
    OrderSource? source,
    OrderType? type,
    PaymentMethod? paymentMethod,
    double? discountTotal,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.orders,
        queryParameters: {'storeId': storeId},
        data: {
          'products': products,
          'source': ?source?.name,
          'type': ?type?.name,
          'paymentMethod': ?paymentMethod?.name,
          'discountTotal': ?discountTotal,
        },
      );

      return Order.fromJson(
        result.data['data']['order'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to place order.');
    }
  }

  static Future<Order> getById({
    required String storeId,
    required String id,
  }) async {
    try {
      final result = await dio.get(
        '${ApiEndpoints.orders}/$id',
        queryParameters: {'storeId': storeId},
      );

      return Order.fromJson(
        result.data['data']['order'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch order details.');
    }
  }

  static Future<OrderPaginatedResponse> getAll({
    required String storeId,
    int? page,
    int? size,
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.orders,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
          'paymentMethod': ?paymentMethod,
          'status': ?status,
          'paymentStatus': ?paymentStatus,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final paginated = parsePaginatedResponse(
        data: data,
        key: 'orders',
        fromJson: Order.fromJson,
      );

      final summaryData = (data['summary'] as Map<String, dynamic>?) ?? {};

      final summary = (
        totalOrders: summaryData['totalOrders'] as int? ?? 0,
        grossSubtotal:
            (summaryData['grossSubtotal'] as num?)?.toDouble() ?? 0.0,
        totalDiscount:
            (summaryData['totalDiscount'] as num?)?.toDouble() ?? 0.0,
        netRevenue: (summaryData['netRevenue'] as num?)?.toDouble() ?? 0.0,
      );

      return (
        items: paginated.items,
        currentPage: paginated.currentPage,
        pageSize: paginated.pageSize,
        totalItems: paginated.totalItems,
        totalPages: paginated.totalPages,
        summary: summary,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch orders.');
    }
  }

  static Future<Map<String, dynamic>> getDashboardAnalytics({
    required String storeId,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.dashboardReport,
        queryParameters: {
          'storeId': storeId,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
        },
      );

      return result.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch dashboard analytics.');
    }
  }
}
