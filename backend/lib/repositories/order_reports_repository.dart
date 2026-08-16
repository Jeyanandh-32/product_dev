import 'package:backend/database/schema.dart';
import 'package:backend/repositories/dashboard_analytics_query.dart';
import 'package:backend/repositories/order_summary_calculator.dart';
import 'package:backend/repositories/profit_loss_report_query.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository delegating complex analytics, summaries, and financial reports.
class OrderReportsRepository {
  const OrderReportsRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Computes order summary totals (count, gross, discounts, net revenue, and payment channels).
  Future<
    ({
      int totalOrders,
      double grossSubtotal,
      double totalDiscount,
      double netRevenue,
      double cashCollected,
      double upiCollected,
      double walletCollected,
      double freeTotal,
    })
  >
  getOrderSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => OrderSummaryCalculator.calculateOrderSummary(
    db: db,
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Computes collected payments summary categorized by Cash, UPI, and Free.
  Future<
    ({
      double cashCollected,
      double upiCollected,
      double freeTotal,
      double totalCollected,
    })
  >
  getPaymentSummary({
    required String merchantId,
    String? storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => OrderSummaryCalculator.calculatePaymentSummary(
    db: db,
    merchantId: merchantId,
    storeId: storeId,
    fromDate: fromDate,
    toDate: toDate,
  );

  /// Computes comprehensive Profit & Loss analytics using [ProfitLossReportQuery].
  Future<
    ({
      int total,
      List<ProfitLossItem> items,
      double totalCostPrice,
      double totalCollectedPrice,
      double totalProfit,
      double totalMarginPercentage,
    })
  >
  getProfitLossReport({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int limit = 10,
    int offset = 0,
  }) =>
      ProfitLossReportQuery(db: db).execute(
        merchantId: merchantId,
        storeId: storeId,
        fromDate: fromDate,
        toDate: toDate,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      );

  /// Computes aggregated live dashboard metrics using [DashboardAnalyticsQuery].
  Future<Map<String, dynamic>> getDashboardAnalytics({
    required String merchantId,
    required String storeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) =>
      DashboardAnalyticsQuery(db: db).execute(
        merchantId: merchantId,
        storeId: storeId,
        fromDate: fromDate,
        toDate: toDate,
      );
}
