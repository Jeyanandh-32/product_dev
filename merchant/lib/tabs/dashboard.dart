import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:merchant/components/dashboard/category_sales_chart_card.dart';
import 'package:merchant/components/dashboard/dashboard_charts_renderer.dart';
import 'package:merchant/components/dashboard/dashboard_header_bar.dart';
import 'package:merchant/components/dashboard/dashboard_kpi_grid.dart';
import 'package:merchant/components/dashboard/dashboard_payment_charts_row.dart';
import 'package:merchant/components/dashboard/hourly_orders_chart_card.dart';
import 'package:merchant/components/dashboard/low_stock_card.dart';
import 'package:merchant/components/dashboard/revenue_trend_chart_card.dart';
import 'package:merchant/components/dashboard/top_products_card.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';

/// Merchant executive dashboard displaying performance KPIs, sales trends, and inventory health.
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
        classes: 'flex-1 flex flex-col items-center justify-center bg-neutral/30 p-8 space-y-3',
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
    final totalOrdersCount = pStatus.paidCount + pStatus.freeCount;

    return div(
      classes: 'flex-1 overflow-y-auto bg-neutral/30 p-3 sm:p-4 space-y-4',
      [
        DashboardHeaderBar(
          selectedRange: _selectedRange,
          onRangeChanged: _handleRangeChange,
          onRefresh: _handleRefresh,
        ),

        DashboardKpiGrid(
          totalRevenue: summary.totalRevenue,
          totalOrders: summary.totalOrders,
          aov: summary.aov,
          lowStockCount: summary.lowStockCount,
          revenueGrowth: summary.revenueGrowth,
          ordersGrowth: summary.ordersGrowth,
          aovGrowth: summary.aovGrowth,
        ),

        DashboardPaymentChartsRow(
          totalRevenue: summary.totalRevenue,
          upiPercent: pMethods.upiPercent,
          upiTotal: pMethods.upiTotal,
          cashPercent: pMethods.cashPercent,
          cashTotal: pMethods.cashTotal,
          totalOrdersCount: totalOrdersCount,
          paidPercent: pStatus.paidPercent,
          paidCount: pStatus.paidCount,
          freePercent: pStatus.freePercent,
          freeCount: pStatus.freeCount,
        ),

        RevenueTrendChartCard(
          totalOrders: summary.totalOrders,
          isStoreActive: selectedStore.isActive,
        ),

        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4 min-w-0', [
          const CategorySalesChartCard(),
          const HourlyOrdersChartCard(),
        ]),

        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4 min-w-0', [
          TopProductsCard(topProducts: topProducts),
          LowStockCard(lowStockProducts: lowStockProducts),
        ]),
      ],
    );
  }
}
