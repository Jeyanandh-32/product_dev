import 'package:merchant/components/dashboard/dashboard_chart_options.dart';
import 'package:merchant/utils/chart_js.dart';

export 'package:merchant/components/dashboard/dashboard_chart_options.dart';

/// Chart drawer functions for line and bar charts (Revenue Trend, Top Categories, Hourly Orders).
class DashboardBarLineChartsDrawer {
  const DashboardBarLineChartsDrawer._();

  static void drawSalesTrendChart(DashboardSummaryData summary) {
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
      options: DashboardBarChartOptions.salesTrendLine(),
    );
  }

  static void drawTopCategoriesChart(DashboardCategorySalesData catSales) {
    final displayLabels = catSales.labels.map((label) {
      if (label.length > 20) {
        return '${label.substring(0, 18)}…';
      }
      return label;
    }).toList();

    drawChart(
      canvasId: 'topCategoriesChart',
      type: 'bar',
      data: {
        'labels': displayLabels,
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
      options: DashboardBarChartOptions.categoryHorizontalBar(),
    );
  }

  static void drawHourlyOrdersChart(DashboardHourlyOrdersData hourlyOrders) {
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
      options: DashboardBarChartOptions.hourlyOrdersBar(),
    );
  }
}
