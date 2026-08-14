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

  static Future<({Order order, String? tokenUrl, String merchantOrderId, bool isFullyPaidByWallet})> initiateOnlinePayment({
    required String storeId,
    required List<Map<String, dynamic>> products,
    double? discountTotal,
    bool? useWallet,
  }) async {
    try {
      final result = await dio.post(
        '/v1/orders/initiate-online-payment',
        queryParameters: {'storeId': storeId},
        data: {
          'products': products,
          'discountTotal': ?discountTotal,
          'useWallet': ?useWallet,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final order = Order.fromJson(data['order'] as Map<String, Object?>);
      final tokenUrl = data['tokenUrl'] as String?;
      final merchantOrderId = data['merchantOrderId'] as String;
      final isFullyPaidByWallet = data['isFullyPaidByWallet'] as bool? ?? false;

      return (
        order: order,
        tokenUrl: tokenUrl,
        merchantOrderId: merchantOrderId,
        isFullyPaidByWallet: isFullyPaidByWallet,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to initiate online payment.');
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
        ApiEndpoints.reportsOrders,
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

  static Future<Order> verifyStatus({required String reference}) async {
    try {
      final result = await dio.get(
        '/v1/orders/verify-status',
        queryParameters: {'reference': reference},
      );
      final data = result.data['data'] as Map<String, dynamic>;
      return Order.fromJson(data['order'] as Map<String, Object?>);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to verify order status.');
    }
  }

  static Future<PaginatedResponse<Order>> getCustomerOrders({
    String? storeId,
    String? date,
    int? page,
    int? size,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.customerOrders,
        queryParameters: {
          'storeId': ?storeId,
          'date': ?date,
          'page': ?page,
          'size': ?size,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      return parsePaginatedResponse(
        data: data,
        key: 'orders',
        fromJson: Order.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch customer orders.');
    }
  }
}
