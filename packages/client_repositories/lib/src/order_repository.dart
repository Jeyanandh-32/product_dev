import 'package:api_client/api_client.dart';
import 'package:client_repositories/src/order_response_types.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

export 'package:client_repositories/src/order_response_types.dart';

/// Client repository for creating, retrieving, and paying orders via backend API.
abstract final class OrderRepository {
  /// Places an in-store terminal order.
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

  /// Initiates an online checkout session via PhonePe payment gateway or store wallet.
  static Future<OnlinePaymentInitiationResult> initiateOnlinePayment({
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

  /// Retrieves order details by primary UUID.
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

  /// Retrieves paginated orders report with summary totals for merchant management.
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
        cashCollected:
            (summaryData['cashCollected'] as num?)?.toDouble() ?? 0.0,
        upiCollected: (summaryData['upiCollected'] as num?)?.toDouble() ?? 0.0,
        walletCollected:
            (summaryData['walletCollected'] as num?)?.toDouble() ?? 0.0,
        freeTotal: (summaryData['freeTotal'] as num?)?.toDouble() ?? 0.0,
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

  /// Retrieves dashboard analytics metrics.
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

  /// Verifies status of a pending order payment.
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

  /// Retrieves customer order history.
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
