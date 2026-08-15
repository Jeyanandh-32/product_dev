import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:merchant/components/dashboard/category_sales_chart_card.dart';
import 'package:merchant/components/dashboard/dashboard_charts_renderer.dart';
import 'package:merchant/components/dashboard/dashboard_header_bar.dart';
import 'package:merchant/components/dashboard/hourly_orders_chart_card.dart';
import 'package:merchant/components/dashboard/kpi_metric_card.dart';
import 'package:merchant/components/dashboard/low_stock_card.dart';
import 'package:merchant/components/dashboard/payment_method_chart_card.dart';
import 'package:merchant/components/dashboard/payment_status_chart_card.dart';
import 'package:merchant/components/dashboard/revenue_trend_chart_card.dart';
import 'package:merchant/components/dashboard/top_products_card.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';

class Dashboard extends SignalComponent {
  const Dashboard({super.key});

  @override
  SignalState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends SignalState<Dashboard> {
  DashboardRange _selectedRange = .days7;
  String? _loadedStoreId;

  @override
  void initState() {
    super.initState();
    final store = storeSignal.value;
    if (store != null) {
      _loadedStoreId = store.id;
      refreshDashboardSignal().then((_) {
        DashboardChartsRenderer.initAllCharts();
      });
    }
  }

  Future<void> _handleRefresh() async {
    await refreshDashboardSignal();
    DashboardChartsRenderer.initAllCharts();
  }

  Future<void> _handleRangeChange(DashboardRange range) async {
    setState(() {
      _selectedRange = range;
    });
    dashboardRangeSignal.value = range;
    await _handleRefresh();
  }

  String _formatGrowth(double growth) {
    if (growth > 0) {
      return '+${growth.toStringAsFixed(1)}%';
    } else if (growth < 0) {
      return '${growth.toStringAsFixed(1)}%';
    }
    return '0.0%';
  }

  @override
  Component buildSignal(BuildContext context) {
    final storesState = storesSignal.value;
    final selectedStore = storeSignal.value;

    if (storesState.isLoading) {
      return Loading(text: 'Loading Analytics...', fullScreen: false);
    }

    final storeList = storesState.value ?? [];
    if (storeList.isEmpty) {
      return div(
        classes:
            'flex-1 flex flex-col items-center justify-center bg-neutral/30 p-8 space-y-3',
        [
          ShoppingBag(classes: 'w-12 h-12 text-gray-400 mb-2'),
          h3(classes: 'text-lg font-bold text-gray-800', [
            .text('No Stores Found'),
          ]),
          p(classes: 'text-sm font-medium text-gray-500 max-w-sm text-center', [
            .text(
              'Please create a store in Stores section to view dashboard analytics.',
            ),
          ]),
        ],
      );
    }

    if (selectedStore == null) {
      return Loading(text: 'Loading Analytics...', fullScreen: false);
    }

    if (_loadedStoreId != selectedStore.id) {
      _loadedStoreId = selectedStore.id;
      Future.microtask(() => _handleRefresh());
    }

    final summary = dashboardSummarySignal.value;
    final pMethods = dashboardPaymentMethodsSignal.value;
    final pStatus = dashboardPaymentStatusSignal.value;
    final topProducts = dashboardTopProductsSignal.value;
    final lowStockProducts = dashboardLowStockProductsSignal.value;

    final formattedTotal = '₹ ${summary.totalRevenue.toStringAsFixed(2)}';
    final totalOrdersCount = pStatus.paidCount + pStatus.freeCount;

    return div(
      classes: 'flex-1 overflow-y-auto bg-neutral/30 p-4 space-y-4',
      [
        DashboardHeaderBar(
          selectedRange: _selectedRange,
          onRangeChanged: _handleRangeChange,
          onRefresh: _handleRefresh,
        ),

        // KPI Metric Cards Grid
        div(classes: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4', [
          KpiMetricCard(
            title: 'Total Revenue',
            value: formattedTotal,
            trend: _formatGrowth(summary.revenueGrowth),
            trendUp: summary.revenueGrowth >= 0,
            iconBg: 'bg-emerald-50 text-emerald-600 border-emerald-100',
            iconWidget: IndianRupee(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          KpiMetricCard(
            title: 'Total Orders',
            value: '${summary.totalOrders} Orders',
            trend: _formatGrowth(summary.ordersGrowth),
            trendUp: summary.ordersGrowth >= 0,
            iconBg: 'bg-blue-50 text-blue-600 border-blue-100',
            iconWidget: ShoppingBag(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          KpiMetricCard(
            title: 'Avg Order Value (AOV)',
            value: '₹ ${summary.aov.toStringAsFixed(2)}',
            trend: _formatGrowth(summary.aovGrowth),
            trendUp: summary.aovGrowth >= 0,
            iconBg: 'bg-purple-50 text-purple-600 border-purple-100',
            iconWidget: ChartBar(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          KpiMetricCard(
            title: 'Low Stock Items',
            value: '${summary.lowStockCount} Products',
            trend: summary.lowStockCount > 0 ? 'Requires Action' : 'Optimal',
            trendUp: summary.lowStockCount == 0,
            iconBg: 'bg-amber-50 text-amber-600 border-amber-100',
            iconWidget: TriangleAlert(classes: 'w-5 h-5'),
            subtitle: 'Below low stock threshold',
          ),
        ]),

        // Two Pie/Doughnut Charts Split Side-by-Side
        div(classes: 'grid grid-cols-1 md:grid-cols-2 gap-4', [
          PaymentMethodChartCard(
            formattedTotal: formattedTotal,
            upiPercent: '${pMethods.upiPercent}%',
            upiTotalFormatted: '₹ ${pMethods.upiTotal.toStringAsFixed(2)}',
            cashPercent: '${pMethods.cashPercent}%',
            cashTotalFormatted: '₹ ${pMethods.cashTotal.toStringAsFixed(2)}',
          ),
          PaymentStatusChartCard(
            totalOrdersCount: totalOrdersCount,
            paidPercent: pStatus.paidPercent,
            paidCount: pStatus.paidCount,
            freePercent: pStatus.freePercent,
            freeCount: pStatus.freeCount,
          ),
        ]),

        RevenueTrendChartCard(
          totalOrders: summary.totalOrders,
          isStoreActive: selectedStore.isActive,
        ),

        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4', [
          const CategorySalesChartCard(),
          const HourlyOrdersChartCard(),
        ]),

        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4', [
          TopProductsCard(topProducts: topProducts),
          LowStockCard(lowStockProducts: lowStockProducts),
        ]),
      ],
    );
  }
}
