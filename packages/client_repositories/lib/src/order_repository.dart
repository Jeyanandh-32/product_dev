import 'package:api_client/api_client.dart';
import 'package:client_repositories/src/order_online_checkout_helper.dart';
import 'package:client_repositories/src/order_reports_helper.dart';
import 'package:client_repositories/src/order_response_types.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

export 'package:client_repositories/src/order_response_types.dart';

/// Client repository for creating, retrieving, updating, and paying orders via backend API.
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
  }) =>
      OrderOnlineCheckoutHelper.initiateOnlinePayment(
        storeId: storeId,
        products: products,
        discountTotal: discountTotal,
        useWallet: useWallet,
      );

  /// Retrieves order details by primary UUID or bill number.
  static Future<Order> getById({required String storeId, required String id}) =>
      OrderReportsHelper.getById(storeId: storeId, id: id);

  /// Updates order state, payment status, or payment method via PATCH /v1/orders/[id].
  static Future<Order> updateStatus({
    required String storeId,
    required String id,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
  }) => OrderReportsHelper.updateStatus(
    storeId: storeId,
    id: id,
    status: status,
    paymentStatus: paymentStatus,
    paymentMethod: paymentMethod,
  );

  /// Retrieves paginated orders report with summary totals for merchant management.
  static Future<OrderPaginatedResponse> getAll({
    required String storeId,
    int? page,
    int? size,
    String? source,
    String? terminalCode,
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
  }) => OrderReportsHelper.getAll(
    storeId: storeId,
    page: page,
    size: size,
    source: source,
    terminalCode: terminalCode,
    fromDate: fromDate,
    toDate: toDate,
    paymentMethod: paymentMethod,
    status: status,
    paymentStatus: paymentStatus,
  );

  /// Retrieves dashboard analytics metrics.
  static Future<Map<String, dynamic>> getDashboardAnalytics({
    required String storeId,
    String? fromDate,
    String? toDate,
  }) => OrderReportsHelper.getDashboardAnalytics(
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Verifies status of a pending order payment.
  static Future<Order> verifyStatus({required String reference}) =>
      OrderOnlineCheckoutHelper.verifyStatus(reference: reference);

  /// Retrieves customer order history.
  static Future<PaginatedResponse<Order>> getCustomerOrders({
    String? storeId,
    String? date,
    String? fromDate,
    String? toDate,
    int? page,
    int? size,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.customerOrders,
        queryParameters: {
          'storeId': ?storeId,
          'date': ?date,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
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
