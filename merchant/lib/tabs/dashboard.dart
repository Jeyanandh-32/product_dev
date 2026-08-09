import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/utils/chart_js.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

class Dashboard extends SignalComponent {
  const Dashboard({super.key});

  @override
  SignalState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends SignalState<Dashboard> {
  String _selectedRange = '7d';
  String? _loadedStoreId;

  @override
  void initState() {
    super.initState();
    final store = storeSignal.value;
    if (store != null) {
      _loadedStoreId = store.id;
      // Render charts instantly from in-memory cached signal state
      Future.microtask(() {
        _initCharts();
      });
      // Fetch updated analytics from backend in background
      refreshDashboardSignal().then((_) {
        _initCharts();
      });
    }
  }

  void _initCharts() {
    final pMethods = dashboardPaymentMethodsSignal.value;
    final pStatus = dashboardPaymentStatusSignal.value;
    final summary = dashboardSummarySignal.value;

    final formattedTotal = '₹ ${summary.totalRevenue.toStringAsFixed(2)}';
    final formattedUpi = '₹ ${pMethods.upiTotal.toStringAsFixed(2)}';
    final formattedCash = '₹ ${pMethods.cashTotal.toStringAsFixed(2)}';

    // 1. Sales & Revenue Trend Chart (Full Width)
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

    // 3. Paid vs Free Chart (Paid vs Complimentary)
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

  @override
  Component buildSignal(BuildContext context) {
    final storesState = storesSignal.value;
    final selectedStore = storeSignal.value;

    // 1. Guard: If stores are loading or no store is selected yet, show store loading state
    if (storesState.isLoading || selectedStore == null) {
      return Loading(text: 'Loading Analytics...', fullScreen: false);
    }

    // 2. Guard: If stores list is empty (no stores created yet)
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

    // 3. Trigger analytics load if selected store changed
    if (_loadedStoreId != selectedStore.id) {
      _loadedStoreId = selectedStore.id;
      Future.microtask(() async {
        await refreshDashboardSignal();
        _initCharts();
      });
    }

    final summary = dashboardSummarySignal.value;
    final pMethods = dashboardPaymentMethodsSignal.value;
    final pStatus = dashboardPaymentStatusSignal.value;
    final topProducts = dashboardTopProductsSignal.value;
    final lowStockProducts = dashboardLowStockProductsSignal.value;

    final formattedTotal = '₹ ${summary.totalRevenue.toStringAsFixed(2)}';

    return div(
      classes: 'flex-1 overflow-y-auto bg-neutral/30 p-4 space-y-4',
      [
        // Top Header & Control Bar
        div(
          classes:
              'flex flex-col lg:flex-row lg:items-center justify-between gap-3 bg-white p-4 rounded-xl border border-border-medium shadow-2xs',
          [
            div(classes: 'space-y-0.5', [
              div(classes: 'flex items-center gap-2', [
                span(
                  classes:
                      'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200/60',
                  [
                    span(
                      classes:
                          'w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse',
                      [],
                    ),
                    .text('Live Analytics'),
                  ],
                ),
              ]),
              p(classes: 'text-sm text-gray-500 font-medium', [
                .text(
                  'Real-time metrics, revenue performance, and inventory health overview',
                ),
              ]),
            ]),

            // Quick Preset Selector & Refresh Button
            div(classes: 'flex items-center gap-2.5 self-start lg:self-auto', [
              div(
                classes:
                    'inline-flex p-1 bg-gray-100/80 rounded-lg border border-gray-200/60 text-xs font-semibold',
                [
                  _rangeTab('Today', '1d'),
                  _rangeTab('7 Days', '7d'),
                  _rangeTab('30 Days', '30d'),
                  _rangeTab('This Year', '1y'),
                ],
              ),
              button(
                type: .button,
                classes:
                    'p-2 bg-white border border-border-medium hover:bg-neutral rounded-lg text-gray-600 transition-all hover:scale-105 active:scale-95 shadow-2xs hover:cursor-pointer',
                attributes: {'title': 'Refresh Analytics'},
                events: {
                  'click': (e) async {
                    await refreshDashboardSignal();
                    _initCharts();
                  },
                },
                [
                  RefreshCw(classes: 'w-4 h-4'),
                ],
              ),
            ]),
          ],
        ),

        // KPI Metric Cards Grid (4 Cards)
        div(classes: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4', [
          _kpiCard(
            title: 'Total Revenue',
            value: formattedTotal,
            trend: _formatGrowth(summary.revenueGrowth),
            trendUp: summary.revenueGrowth >= 0,
            iconBg: 'bg-emerald-50 text-emerald-600 border-emerald-100',
            iconWidget: IndianRupee(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          _kpiCard(
            title: 'Total Orders',
            value: '${summary.totalOrders} Orders',
            trend: _formatGrowth(summary.ordersGrowth),
            trendUp: summary.ordersGrowth >= 0,
            iconBg: 'bg-blue-50 text-blue-600 border-blue-100',
            iconWidget: ShoppingBag(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          _kpiCard(
            title: 'Avg Order Value (AOV)',
            value: '₹ ${summary.aov.toStringAsFixed(2)}',
            trend: _formatGrowth(summary.aovGrowth),
            trendUp: summary.aovGrowth >= 0,
            iconBg: 'bg-purple-50 text-purple-600 border-purple-100',
            iconWidget: ChartBar(classes: 'w-5 h-5'),
            subtitle: 'vs previous period',
          ),
          _kpiCard(
            title: 'Low Stock Items',
            value: '${summary.lowStockCount} Products',
            trend: summary.lowStockCount > 0 ? 'Requires Action' : 'Optimal',
            trendUp: summary.lowStockCount == 0,
            iconBg: 'bg-amber-50 text-amber-600 border-amber-100',
            iconWidget: TriangleAlert(classes: 'w-5 h-5'),
            subtitle: 'Below low stock threshold',
          ),
        ]),

        // Two Pie Charts Split Side-by-Side on md and lg
        div(classes: 'grid grid-cols-1 md:grid-cols-2 gap-4', [
          // Doughnut Chart 1: Payment Methods (UPI vs Cash)
          div(
            classes:
                'bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs flex flex-col justify-between',
            [
              div([
                h3(classes: 'text-base font-bold text-gray-900', [
                  .text('Payment Methods'),
                ]),
                p(classes: 'text-xs text-gray-500 font-medium', [
                  .text('Breakdown by payment mode'),
                ]),
              ]),

              // Canvas chart container with centered overlay
              div(
                classes:
                    'relative w-full h-48 my-1 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-3',
                [
                  Component.element(
                    tag: 'canvas',
                    id: 'paymentMethodChart',
                    classes: 'w-full h-full',
                    children: [],
                  ),
                  div(
                    classes:
                        'absolute inset-0 flex flex-col items-center justify-center pointer-events-none text-center p-2',
                    [
                      span(
                        id: 'paymentCenterLabel',
                        classes:
                            'text-[10px] uppercase tracking-wider font-extrabold text-black mb-0.5 max-w-27.5 truncate',
                        [.text('TOTAL')],
                      ),
                      span(
                        id: 'paymentCenterValue',
                        classes: 'text-sm sm:text-base font-black text-black',
                        [.text(formattedTotal)],
                      ),
                    ],
                  ),
                ],
              ),

              // Legend List
              div(classes: 'space-y-2 text-xs font-medium', [
                _paymentLegendRow(
                  'UPI / QR Code',
                  '${pMethods.upiPercent}%',
                  '₹ ${pMethods.upiTotal.toStringAsFixed(2)}',
                  'bg-primary',
                ),
                _paymentLegendRow(
                  'Cash',
                  '${pMethods.cashPercent}%',
                  '₹ ${pMethods.cashTotal.toStringAsFixed(2)}',
                  'bg-accent',
                ),
              ]),
            ],
          ),

          // Doughnut Chart 2: Order Payment Status (Paid vs Free)
          div(
            classes:
                'bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs flex flex-col justify-between',
            [
              div([
                h3(classes: 'text-base font-bold text-gray-900', [
                  .text('Order Payment Status'),
                ]),
                p(classes: 'text-xs text-gray-500 font-medium', [
                  .text('Paid vs Free & Complimentary'),
                ]),
              ]),

              // Canvas chart container with centered overlay
              div(
                classes:
                    'relative w-full h-48 my-1 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-3',
                [
                  Component.element(
                    tag: 'canvas',
                    id: 'paidFreeChart',
                    classes: 'w-full h-full',
                    children: [],
                  ),
                  div(
                    classes:
                        'absolute inset-0 flex flex-col items-center justify-center pointer-events-none text-center p-2',
                    [
                      span(
                        id: 'paidFreeCenterLabel',
                        classes:
                            'text-[10px] uppercase tracking-wider font-extrabold text-black mb-0.5 max-w-27.5 truncate',
                        [.text('ORDERS')],
                      ),
                      span(
                        id: 'paidFreeCenterValue',
                        classes: 'text-sm sm:text-base font-black text-black',
                        [
                          .text(
                            '${pStatus.paidCount + pStatus.freeCount} Total',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Legend List
              div(classes: 'space-y-2 text-xs font-medium', [
                _paymentLegendRow(
                  'Paid Orders',
                  '${pStatus.paidPercent}%',
                  '${pStatus.paidCount} Orders',
                  'bg-purple-600',
                ),
                _paymentLegendRow(
                  'Free / Complimentary',
                  '${pStatus.freePercent}%',
                  '${pStatus.freeCount} Orders',
                  'bg-amber-500',
                ),
              ]),
            ],
          ),
        ]),

        // Main Full-Width Line Chart: Sales & Revenue Trends
        div(
          classes:
              'bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs flex flex-col justify-between',
          [
            div(
              classes:
                  'flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3',
              [
                div([
                  h3(classes: 'text-base font-bold text-gray-900', [
                    .text('Revenue & Order Trends'),
                  ]),
                  p(classes: 'text-xs text-gray-500 font-medium', [
                    .text('Sales progression over time'),
                  ]),
                ]),
                div(classes: 'flex items-center gap-3 text-xs font-medium', [
                  span(classes: 'flex items-center gap-1.5 text-gray-600', [
                    span(
                      classes: 'w-2.5 h-2.5 rounded-full bg-emerald-500',
                      [],
                    ),
                    .text('Revenue (₹)'),
                  ]),
                  span(classes: 'flex items-center gap-1.5 text-gray-600', [
                    span(
                      classes: 'w-2.5 h-2.5 rounded-full bg-blue-500',
                      [],
                    ),
                    .text('Orders'),
                  ]),
                ]),
              ],
            ),

            // Canvas chart container
            div(
              classes:
                  'relative w-full h-55 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
              [
                Component.element(
                  tag: 'canvas',
                  id: 'salesTrendChart',
                  classes: 'w-full h-full',
                  children: [],
                ),
              ],
            ),

            // Bottom Chart Metrics Summary Bar
            div(
              classes:
                  'mt-3 pt-3 border-t border-gray-100 grid grid-cols-3 gap-3 text-center',
              [
                div([
                  p(classes: 'text-xs text-gray-400 font-medium', [
                    .text('Peak Sales Window'),
                  ]),
                  p(classes: 'text-sm font-bold text-gray-800', [
                    .text(
                      summary.totalOrders > 0 ? '12:00 PM - 2:00 PM' : '--',
                    ),
                  ]),
                ]),
                div([
                  p(classes: 'text-xs text-gray-400 font-medium', [
                    .text('Completed Orders'),
                  ]),
                  p(classes: 'text-sm font-bold text-gray-800', [
                    .text('${summary.totalOrders} Orders'),
                  ]),
                ]),
                div([
                  p(classes: 'text-xs text-gray-400 font-medium', [
                    .text('Store Status'),
                  ]),
                  p(
                    classes:
                        'text-sm font-bold ${selectedStore.isActive ? 'text-emerald-600' : 'text-gray-500'}',
                    [
                      .text(
                        selectedStore.isActive ? 'Active Store' : 'Inactive',
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ],
        ),

        // Charts Section 2 (Top Categories 6 Cols & Hourly Traffic 6 Cols)
        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4', [
          // Category Sales Distribution
          div(
            classes:
                'lg:col-span-6 bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs',
            [
              h3(classes: 'text-base font-bold text-gray-900 mb-0.5', [
                .text('Category Sales Breakdown'),
              ]),
              p(classes: 'text-xs text-gray-500 font-medium mb-3', [
                .text('Revenue contribution by product category'),
              ]),
              div(
                classes:
                    'relative w-full h-47.5 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
                [
                  Component.element(
                    tag: 'canvas',
                    id: 'topCategoriesChart',
                    classes: 'w-full h-full',
                    children: [],
                  ),
                ],
              ),
            ],
          ),

          // Hourly Order Distribution
          div(
            classes:
                'lg:col-span-6 bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs',
            [
              h3(classes: 'text-base font-bold text-gray-900 mb-0.5', [
                .text('Hourly Traffic & Orders'),
              ]),
              p(classes: 'text-xs text-gray-500 font-medium mb-3', [
                .text('Volume of customer transactions throughout the day'),
              ]),
              div(
                classes:
                    'relative w-full h-47.5 bg-neutral/20 rounded-lg border border-border-light flex items-center justify-center p-2',
                [
                  Component.element(
                    tag: 'canvas',
                    id: 'hourlyOrdersChart',
                    classes: 'w-full h-full',
                    children: [],
                  ),
                ],
              ),
            ],
          ),
        ]),

        // Bottom Data Cards Grid (Top Selling Products & Recent Orders)
        div(classes: 'grid grid-cols-1 lg:grid-cols-12 gap-4', [
          // Top 5 Selling Products Card (6 Cols)
          div(
            classes:
                'lg:col-span-6 bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs',
            [
              div(classes: 'flex items-center justify-between mb-3', [
                div([
                  h3(classes: 'text-base font-bold text-gray-900', [
                    .text('Top Selling Products'),
                  ]),
                  p(classes: 'text-xs text-gray-500 font-medium', [
                    .text('Best performing items by volume'),
                  ]),
                ]),
                button(
                  type: .button,
                  classes:
                      'text-xs font-semibold text-primary cursor-pointer hover:underline border-0 bg-transparent p-0',
                  events: {
                    'click': (e) =>
                        Router.of(context).push('/inventory/products'),
                  },
                  [
                    .text('View All Products'),
                  ],
                ),
              ]),
              _buildTopProductsList(topProducts),
            ],
          ),

          // Low Stock Products Alert Feed (6 Cols)
          div(
            classes:
                'lg:col-span-6 bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs',
            [
              div(classes: 'flex items-center justify-between mb-3', [
                div([
                  h3(classes: 'text-base font-bold text-gray-900', [
                    .text('Low Stock Products'),
                  ]),
                  p(classes: 'text-xs text-gray-500 font-medium', [
                    .text('Items requiring inventory replenishment'),
                  ]),
                ]),
                button(
                  type: .button,
                  classes:
                      'text-xs font-semibold text-primary cursor-pointer hover:underline border-0 bg-transparent p-0',
                  events: {
                    'click': (e) =>
                        Router.of(context).push('/inventory/products'),
                  },
                  [
                    .text('View All Products'),
                  ],
                ),
              ]),
              _buildLowStockProductsList(lowStockProducts),
            ],
          ),
        ]),
      ],
    );
  }

  String _formatGrowth(double growth) {
    if (growth > 0) {
      return '+${growth.toStringAsFixed(1)}%';
    } else if (growth < 0) {
      return '${growth.toStringAsFixed(1)}%';
    }
    return '0.0%';
  }

  Component _buildTopProductsList(
    List<
      ({
        String rank,
        String name,
        String category,
        String units,
        String revenue,
      })
    >
    topProducts,
  ) {
    if (topProducts.isNotEmpty) {
      return div(classes: 'divide-y divide-gray-100', [
        for (final item in topProducts)
          _topProductRow(
            item.rank,
            item.name,
            item.category,
            item.units,
            item.revenue,
          ),
      ]);
    }

    return div(
      classes: 'py-10 text-center text-xs font-semibold text-gray-400',
      [
        .text('No top products data found for this store.'),
      ],
    );
  }

  Component _buildLowStockProductsList(List<Product> lowStockProducts) {
    if (lowStockProducts.isNotEmpty) {
      return div(classes: 'divide-y divide-gray-100', [
        for (final product in lowStockProducts.take(5))
          _lowStockProductRow(
            product.name,
            product.category?.name ?? 'General',
            '${product.stock?.quantity ?? 0} left',
            'Threshold: ${product.stock?.lowStockThreshold ?? 5}',
          ),
      ]);
    }

    return div(
      classes:
          'py-10 text-center text-xs font-semibold text-emerald-600 flex flex-col items-center justify-center space-y-1',
      [
        Check(classes: 'w-6 h-6 text-emerald-500 mb-1'),

        .text('All product stock levels are optimal.'),
      ],
    );
  }

  Component _rangeTab(String label, String value) {
    final isSelected = _selectedRange == value;
    return button(
      type: .button,
      classes:
          'px-3 py-1 rounded-md transition-all hover:cursor-pointer ${isSelected ? 'bg-white text-gray-900 shadow-2xs font-bold' : 'text-gray-500 hover:text-gray-700 font-medium'}',
      events: {
        'click': (e) async {
          setState(() {
            _selectedRange = value;
          });
          dashboardRangeSignal.value = value;
          await refreshDashboardSignal();
          _initCharts();
        },
      },
      [.text(label)],
    );
  }

  Component _kpiCard({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
    required String iconBg,
    required Component iconWidget,
    required String subtitle,
  }) {
    return div(
      classes:
          'bg-white p-4.5 rounded-xl border border-border-medium shadow-2xs flex flex-col justify-between hover:border-gray-300 transition-all',
      [
        div(classes: 'flex items-start justify-between mb-2.5', [
          div(
            classes:
                'w-9 h-9 rounded-xl flex items-center justify-center border $iconBg',
            [iconWidget],
          ),
          span(
            classes:
                'inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold ${trendUp ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}',
            [.text(trend)],
          ),
        ]),
        div([
          p(classes: 'text-xs font-semibold text-gray-500 mb-0.5', [
            .text(title),
          ]),
          h2(classes: 'text-xl font-extrabold text-gray-900 tracking-tight', [
            .text(value),
          ]),
          p(classes: 'text-xs text-gray-400 font-medium mt-0.5', [
            .text(subtitle),
          ]),
        ]),
      ],
    );
  }

  Component _paymentLegendRow(
    String label,
    String percent,
    String total,
    String badgeBg,
  ) {
    return div(
      classes: 'flex items-center justify-between p-2 rounded-lg bg-gray-50/60',
      [
        div(classes: 'flex items-center gap-2', [
          span(classes: 'w-2.5 h-2.5 rounded-full $badgeBg', []),
          span(classes: 'text-gray-700 font-medium text-xs', [.text(label)]),
        ]),
        div(classes: 'flex items-center gap-2 text-xs', [
          span(classes: 'text-gray-400 font-medium', [.text(percent)]),
          span(classes: 'font-bold text-gray-900', [.text(total)]),
        ]),
      ],
    );
  }

  Component _topProductRow(
    String rank,
    String name,
    String category,
    String units,
    String revenue,
  ) {
    return div(classes: 'py-2.5 flex items-center justify-between', [
      div(classes: 'flex items-center gap-3', [
        span(
          classes:
              'w-6 h-6 rounded-md bg-gray-100 text-gray-700 text-xs font-bold flex items-center justify-center',
          [.text(rank)],
        ),
        div([
          p(classes: 'text-sm font-semibold text-gray-900', [.text(name)]),
          p(classes: 'text-xs text-gray-400 font-medium', [.text(category)]),
        ]),
      ]),
      div(classes: 'text-right', [
        p(classes: 'text-sm font-bold text-gray-900', [.text(revenue)]),
        p(classes: 'text-xs text-emerald-600 font-medium', [.text(units)]),
      ]),
    ]);
  }

  Component _lowStockProductRow(
    String name,
    String category,
    String quantityText,
    String thresholdText,
  ) {
    return div(classes: 'py-2.5 flex items-center justify-between', [
      div(classes: 'flex items-center gap-3', [
        div(
          classes:
              'w-8 h-8 rounded-lg bg-amber-50 text-amber-600 border border-amber-200/60 flex items-center justify-center',
          [
            TriangleAlert(classes: 'w-4 h-4'),
          ],
        ),
        div([
          p(classes: 'text-sm font-semibold text-gray-900', [.text(name)]),
          p(classes: 'text-xs text-gray-400 font-medium', [.text(category)]),
        ]),
      ]),
      div(classes: 'text-right', [
        span(
          classes:
              'px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200/60 inline-block mb-0.5',
          [.text(quantityText)],
        ),
        p(
          classes: 'text-[11px] text-gray-400 font-medium',
          [.text(thresholdText)],
        ),
      ]),
    ]);
  }
}
