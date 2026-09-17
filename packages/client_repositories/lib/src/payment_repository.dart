import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Aggregated collection totals for cash, UPI, and total revenue.
typedef PaymentSummary = ({
  double cashCollected,
  double upiCollected,
  double freeTotal,
  double totalCollected,
});

/// Paginated payment list response with aggregate collection summary.
typedef PaymentPaginatedResponse = ({
  List<Payment> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
  PaymentSummary summary,
});

/// Client repository for querying payment transactions and summaries.
abstract final class PaymentRepository {
  /// Fetches a paginated list of payments for a store matching the given criteria.
  static Future<PaymentPaginatedResponse> getAll({
    required String storeId,
    int? page,
    int? size,
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    String? paymentStatus,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.reportsPayments,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
          'paymentMethod': ?paymentMethod,
          'paymentStatus': ?paymentStatus,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final paginated = parsePaginatedResponse(
        data: data,
        key: 'payments',
        fromJson: Payment.fromJson,
      );

      final summaryData = (data['summary'] as Map<String, dynamic>?) ?? {};

      final summary = (
        cashCollected:
            (summaryData['cashCollected'] as num?)?.toDouble() ?? 0.0,
        upiCollected: (summaryData['upiCollected'] as num?)?.toDouble() ?? 0.0,
        freeTotal: (summaryData['freeTotal'] as num?)?.toDouble() ?? 0.0,
        totalCollected:
            (summaryData['totalCollected'] as num?)?.toDouble() ?? 0.0,
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
      handleDioError(e, 'Failed to fetch payments.');
    }
  }
}
