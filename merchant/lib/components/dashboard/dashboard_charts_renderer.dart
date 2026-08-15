import 'package:jaspr/jaspr.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/utils/chart_js.dart';
import 'package:web/web.dart' as web;

class DashboardChartsRenderer {
  const DashboardChartsRenderer._();

  static void initAllCharts() {
    final pMethods = dashboardPaymentMethodsSignal.value;
    final pStatus = dashboardPaymentStatusSignal.value;
    final summary = dashboardSummarySignal.value;

    final formattedTotal = '₹ ${summary.totalRevenue.toStringAsFixed(2)}';
    final formattedUpi = '₹ ${pMethods.upiTotal.toStringAsFixed(2)}';
    final formattedCash = '₹ ${pMethods.cashTotal.toStringAsFixed(2)}';

    // 1. Sales & Revenue Trend Chart
    drawChart(
      canvasId: 'salesTrendChart',
      type: 'line',
      data: {
        'labels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        'datasets': [
          {
            'label': 'Revenue (₹)',
            'data': [
              summary.totalRevenue * 0.1,
              summary.totalRevenue * 0.15,
              summary.totalRevenue * 0.12,
              summary.totalRevenue * 0.18,
              summary.totalRevenue * 0.22,
              summary.totalRevenue * 0.14,
              summary.totalRevenue * 0.09,
            ],
            'borderColor': '#10B981',
            'backgroundColor': 'rgba(16, 185, 129, 0.1)',
            'fill': true,
            'tension': 0.4,
            'borderWidth': 2.5,
            'pointRadius': 3,
            'pointBackgroundColor': '#10B981',
          },
          {
            'label': 'Orders',
            'data': [
              (summary.totalOrders * 0.1).round(),
              (summary.totalOrders * 0.15).round(),
              (summary.totalOrders * 0.12).round(),
              (summary.totalOrders * 0.18).round(),
              (summary.totalOrders * 0.22).round(),
              (summary.totalOrders * 0.14).round(),
              (summary.totalOrders * 0.09).round(),
            ],
            'borderColor': '#3B82F6',
            'backgroundColor': 'rgba(59, 130, 246, 0.05)',
            'fill': true,
            'tension': 0.4,
            'borderWidth': 2,
            'borderDash': [4, 4],
            'pointRadius': 2.5,
            'pointBackgroundColor': '#3B82F6',
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'plugins': {
          'legend': {'display': false},
          'tooltip': {
            'mode': 'index',
            'intersect': false,
            'padding': 8,
            'cornerRadius': 6,
          },
        },
        'scales': {
          'x': {
            'grid': {'display': false},
          },
          'y': {
            'grid': {'color': '#F3F4F6'},
            'beginAtZero': true,
          },
        },
      },
    );

    // 2. Payment Method Share Chart (UPI vs Cash)
    drawChart(
      canvasId: 'paymentMethodChart',
      type: 'doughnut',
      data: {
        'labels': ['UPI / QR Code', 'Cash'],
        'datasets': [
          {
            'data': [pMethods.upiTotal, pMethods.cashTotal],
            'backgroundColor': ['#191645', '#43c6ac'],
            'borderWidth': 0,
            'hoverOffset': 3,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'cutout': '70%',
        'plugins': {
          'legend': {'display': false},
          'tooltip': {'enabled': false},
        },
        'centerHoverLabels': {
          'labelId': 'paymentCenterLabel',
          'valueId': 'paymentCenterValue',
          'defaultLabel': 'TOTAL',
          'defaultValue': formattedTotal,
          'items': [
            {'label': 'UPI / QR CODE', 'value': formattedUpi},
            {'label': 'CASH', 'value': formattedCash},
          ],
        },
      },
    );

    final totalOrdersCount = pStatus.paidCount + pStatus.freeCount;

    // 3. Paid vs Free Chart
    drawChart(
      canvasId: 'paidFreeChart',
      type: 'doughnut',
      data: {
        'labels': ['Paid Orders', 'Free / Complimentary'],
        'datasets': [
          {
            'data': [pStatus.paidCount, pStatus.freeCount],
            'backgroundColor': ['#8B5CF6', '#F59E0B'],
            'borderWidth': 0,
            'hoverOffset': 3,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'cutout': '70%',
        'plugins': {
          'legend': {'display': false},
          'tooltip': {'enabled': false},
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
    final catSales = dashboardCategorySalesSignal.value;
    drawChart(
      canvasId: 'topCategoriesChart',
      type: 'bar',
      data: {
        'labels': catSales.labels,
        'datasets': [
          {
            'label': 'Sales (₹)',
            'data': catSales.data,
            'backgroundColor': [
              '#10B981',
              '#3B82F6',
              '#8B5CF6',
              '#F59E0B',
              '#EC4899',
            ],
            'borderRadius': 6,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'plugins': {
          'legend': {'display': false},
        },
        'scales': {
          'x': {
            'grid': {'display': false},
          },
          'y': {
            'grid': {'color': '#F3F4F6'},
            'beginAtZero': true,
          },
        },
      },
    );

    // 5. Hourly Order Distribution Chart
    final hourlyOrders = dashboardHourlyOrdersSignal.value;
    drawChart(
      canvasId: 'hourlyOrdersChart',
      type: 'bar',
      data: {
        'labels': hourlyOrders.labels,
        'datasets': [
          {
            'label': 'Order Count',
            'data': hourlyOrders.data,
            'backgroundColor': 'rgba(59, 130, 246, 0.85)',
            'hoverBackgroundColor': '#2563EB',
            'borderRadius': 5,
          },
        ],
      },
      options: {
        'responsive': true,
        'maintainAspectRatio': false,
        'plugins': {
          'legend': {'display': false},
        },
        'scales': {
          'x': {
            'grid': {'display': false},
          },
          'y': {
            'grid': {'color': '#F3F4F6'},
            'beginAtZero': true,
          },
        },
      },
    );
  }
}
