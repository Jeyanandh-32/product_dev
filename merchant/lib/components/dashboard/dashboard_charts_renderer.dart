import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/dashboard/dashboard_bar_line_charts_drawer.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/utils/chart_js.dart';
import 'package:web/web.dart' as web;

/// Orchestrator for drawing Chart.js charts on the merchant KPI dashboard.
class DashboardChartsRenderer {
  const DashboardChartsRenderer._();

  static void initAllCharts() {
    final pMethods = dashboardPaymentMethodsSignal.value;
    final pStatus = dashboardPaymentStatusSignal.value;
    final summary = dashboardSummarySignal.value;

    final formattedTotal = '₹ ${summary.totalRevenue.toStringAsFixed(2)}';
    final formattedUpi = '₹ ${pMethods.upiTotal.toStringAsFixed(2)}';
    final formattedCash = '₹ ${pMethods.cashTotal.toStringAsFixed(2)}';

    // 1. Sales & Revenue Trend Line Chart
    DashboardBarLineChartsDrawer.drawSalesTrendChart(summary);

    // 2. Payment Methods Donut Chart
    drawChart(
      canvasId: 'paymentMethodChart',
      type: 'doughnut',
      data: {
        'labels': ['UPI', 'Cash'],
        'datasets': [
          {
            'data': [pMethods.upiTotal, pMethods.cashTotal],
            'backgroundColor': ['#8B5CF6', '#10B981'],
            'borderWidth': 0,
            'hoverOffset': 4,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'cutout': '75%',
        'plugins': {
          'legend': {'display': false},
        },
        'centerHoverLabels': {
          'labelId': 'paymentCenterLabel',
          'valueId': 'paymentCenterValue',
          'defaultLabel': 'TOTAL',
          'defaultValue': formattedTotal,
          'items': [
            {'label': 'UPI', 'value': formattedUpi},
            {'label': 'CASH', 'value': formattedCash},
          ],
        },
      },
    );

    // 3. Payment / Order Status Donut Chart
    final totalOrdersCount = pStatus.paidCount + pStatus.freeCount;
    drawChart(
      canvasId: 'paidFreeChart',
      type: 'doughnut',
      data: {
        'labels': ['Paid Orders', 'Free / Complimentary'],
        'datasets': [
          {
            'data': [pStatus.paidCount, pStatus.freeCount],
            'backgroundColor': ['#10B981', '#3B82F6'],
            'borderWidth': 0,
            'hoverOffset': 4,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'cutout': '75%',
        'plugins': {
          'legend': {'display': false},
        },
        'centerHoverLabels': {
          'labelId': 'paidFreeCenterLabel',
          'valueId': 'paidFreeCenterValue',
          'defaultLabel': 'ORDERS',
          'defaultValue': '$totalOrdersCount Total',
          'items': [
            {'label': 'PAID ORDERS', 'value': '${pStatus.paidCount} Orders'},
            {'label': 'FREE / COMP', 'value': '${pStatus.freeCount} Orders'},
          ],
        },
      },
    );

    // Reset center overlay DOM elements
    if (kIsWeb) {
      final pLabel = web.document.getElementById('paymentCenterLabel');
      final pValue = web.document.getElementById('paymentCenterValue');
      if (pLabel != null && pValue != null) {
        pLabel.textContent = 'TOTAL';
        pValue.textContent = formattedTotal;
      }

      final pfLabel = web.document.getElementById('paidFreeCenterLabel');
      final pfValue = web.document.getElementById('paidFreeCenterValue');
      if (pfLabel != null && pfValue != null) {
        pfLabel.textContent = 'ORDERS';
        pfValue.textContent = '$totalOrdersCount Total';
      }
    }

    // 4. Top Categories Breakdown Chart
    DashboardBarLineChartsDrawer.drawTopCategoriesChart(
      dashboardCategorySalesSignal.value,
    );

    // 5. Hourly Order Distribution Chart
    DashboardBarLineChartsDrawer.drawHourlyOrdersChart(
      dashboardHourlyOrdersSignal.value,
    );
  }
}
