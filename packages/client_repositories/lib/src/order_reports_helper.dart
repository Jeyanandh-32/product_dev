import 'package:api_client/api_client.dart';
import 'package:client_repositories/src/order_response_types.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Helper handling merchant reports orders query and dashboard analytics requests.
class OrderReportsHelper {
  const OrderReportsHelper._();

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
}
