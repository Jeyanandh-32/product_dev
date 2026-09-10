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

/// Chart options presets generator for standard dashboard bar and line charts.
class DashboardBarChartOptions {
  const DashboardBarChartOptions._();

  /// Responsive horizontal bar options for category sales breakdown.
  static Map<String, dynamic> categoryHorizontalBar() => {
    'indexAxis': 'y',
    'responsive': true,
    'maintainAspectRatio': false,
    'plugins': {
      'legend': {'display': false},
      'tooltip': {
        'mode': 'nearest',
        'intersect': true,
        'padding': 8,
        'cornerRadius': 6,
      },
    },
    'scales': {
      'x': {
        'grid': {'color': '#F3F4F6'},
        'beginAtZero': true,
        'ticks': {
          'font': {'size': 10, 'family': 'Plus Jakarta Sans, sans-serif'},
          'color': '#6B7280',
          'maxTicksLimit': 6,
        },
      },
      'y': {
        'grid': {'display': false},
        'ticks': {
          'font': {
            'size': 11,
            'family': 'Plus Jakarta Sans, sans-serif',
            'weight': '600',
          },
          'color': '#374151',
          'autoSkip': false,
        },
      },
    },
  };

  /// Responsive bar options for hourly order volume distribution.
  static Map<String, dynamic> hourlyOrdersBar() => {
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
        'ticks': {
          'font': {'size': 10, 'family': 'Plus Jakarta Sans, sans-serif'},
          'color': '#6B7280',
          'maxRotation': 0,
          'minRotation': 0,
          'autoSkip': true,
          'maxTicksLimit': 8,
        },
      },
      'y': {
        'grid': {'color': '#F3F4F6'},
        'beginAtZero': true,
        'ticks': {
          'font': {'size': 10, 'family': 'Plus Jakarta Sans, sans-serif'},
          'color': '#6B7280',
          'precision': 0,
        },
      },
    },
  };

  /// Responsive line options for revenue and order progression trends.
  static Map<String, dynamic> salesTrendLine() => {
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
        'ticks': {
          'font': {'size': 10, 'family': 'Plus Jakarta Sans, sans-serif'},
          'color': '#6B7280',
          'maxRotation': 0,
          'minRotation': 0,
        },
      },
      'y': {
        'grid': {'color': '#F3F4F6'},
        'beginAtZero': true,
        'ticks': {
          'font': {'size': 10, 'family': 'Plus Jakarta Sans, sans-serif'},
          'color': '#6B7280',
        },
      },
    },
  };
}
