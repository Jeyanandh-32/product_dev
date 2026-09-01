/// Typed record types for merchant dashboard analytics data.
typedef DashboardSummaryData = ({
  double totalRevenue,
  int totalOrders,
  double aov,
  int lowStockCount,
  double revenueGrowth,
  double ordersGrowth,
  double aovGrowth,
  double onlineTotal,
  double inStoreTotal,
  double netRevenue,
});

typedef DashboardCategorySalesData = ({
  List<String> labels,
  List<double> data,
});

typedef DashboardHourlyOrdersData = ({
  List<String> labels,
  List<int> data,
});

/// Chart options presets generator for standard dashboard bar charts.
class DashboardBarChartOptions {
  const DashboardBarChartOptions._();

  static Map<String, dynamic> standard() => {
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
  };
}
