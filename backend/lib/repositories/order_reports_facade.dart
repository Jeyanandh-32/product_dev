import 'package:backend/repositories/order_reports_repository.dart';
import 'package:backend/repositories/order_types.dart';

/// Mixin providing reporting and analytics queries to the order repository.
mixin OrderReportsFacade {
  /// Access to the underlying reports repository.
  OrderReportsRepository get reports;

  /// Computes order summary totals.
  Future<OrderSummaryResult> getOrderSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => reports.getOrderSummary(
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Computes payment breakdown summary.
  Future<PaymentSummaryResult> getPaymentSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => reports.getPaymentSummary(
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Computes Profit & Loss analytics report.
  Future<ProfitLossReportResult> getProfitLossReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) => reports.getProfitLossReport(
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
    searchQuery: searchQuery,
    limit: limit,
    offset: offset,
  );

  /// Computes live dashboard metrics.
  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => reports.getDashboardAnalytics(
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );
}
