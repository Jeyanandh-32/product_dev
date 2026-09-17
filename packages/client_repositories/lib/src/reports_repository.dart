import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

import 'reports_response_types.dart';

/// Client repository for fetching analytics, profit-and-loss, and stock reports.
class ReportsRepository {
  const ReportsRepository._();

  /// Fetches a paginated profit-and-loss report for a store within an optional date range.
  static Future<ProfitLossReportResponse> getProfitLoss({
    required String storeId,
    int? page,
    int? size,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.profitLoss,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'fromDate': fromDate?.toIso8601String(),
          'toDate': toDate?.toIso8601String(),
          'search': ?search,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final paginated = parsePaginatedResponse(
        data: data,
        key: 'items',
        fromJson: ProfitLossItem.fromJson,
      );

      final summary = data['summary'] as Map<String, dynamic>? ?? {};
      final totalCostPrice =
          (summary['totalCostPrice'] as num?)?.toDouble() ?? 0.0;
      final totalCollectedPrice =
          (summary['totalCollectedPrice'] as num?)?.toDouble() ?? 0.0;
      final totalProfit = (summary['totalProfit'] as num?)?.toDouble() ?? 0.0;
      final totalMarginPercentage =
          (summary['totalMarginPercentage'] as num?)?.toDouble() ?? 0.0;

      return (
        items: paginated.items,
        currentPage: paginated.currentPage,
        pageSize: paginated.pageSize,
        totalItems: paginated.totalItems,
        totalPages: paginated.totalPages,
        totalCostPrice: totalCostPrice,
        totalCollectedPrice: totalCollectedPrice,
        totalProfit: totalProfit,
        totalMarginPercentage: totalMarginPercentage,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch profit loss report.');
    }
  }

  /// Fetches an aggregated stock movement summary report for a store within an optional date range.
  static Future<StockSummaryReportResponse> getStockSummary({
    required String storeId,
    int? page,
    int? size,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.stockSummary,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'fromDate': fromDate?.toIso8601String(),
          'toDate': toDate?.toIso8601String(),
          'search': ?search,
        },
      );

      final data = result.data['data'] as Map<String, dynamic>;
      final paginated = parsePaginatedResponse(
        data: data,
        key: 'items',
        fromJson: StockSummaryItem.fromJson,
      );

      final summary = data['summary'] as Map<String, dynamic>? ?? {};

      return (
        items: paginated.items,
        currentPage: paginated.currentPage,
        pageSize: paginated.pageSize,
        totalItems: paginated.totalItems,
        totalPages: paginated.totalPages,
        totalOpeningStock: summary['totalOpeningStock'] as int? ?? 0,
        totalIn: summary['totalIn'] as int? ?? 0,
        totalOut: summary['totalOut'] as int? ?? 0,
        totalWastage: summary['totalWastage'] as int? ?? 0,
        totalAdjustment: summary['totalAdjustment'] as int? ?? 0,
        totalClosingStock: summary['totalClosingStock'] as int? ?? 0,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch stock summary report.');
    }
  }
}
