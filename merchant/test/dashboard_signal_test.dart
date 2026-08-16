import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/signals/dashboard_signals_updater.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Merchant Dashboard Signal & Analytics Calculation Tests', () {
    setUp(() {
      resetDashboardSignal();
    });

    test('resetDashboardSignal correctly initializes and zeroes all dashboard state', () {
      expect(dashboardRangeSignal.value, DashboardRange.days7);

      final summary = dashboardSummarySignal.value;
      expect(summary.totalRevenue, 0.0);
      expect(summary.totalOrders, 0);
      expect(summary.aov, 0.0);
      expect(summary.lowStockCount, 0);
      expect(summary.revenueGrowth, 0.0);
      expect(summary.ordersGrowth, 0.0);
      expect(summary.aovGrowth, 0.0);

      final paymentMethods = dashboardPaymentMethodsSignal.value;
      expect(paymentMethods.upiTotal, 0.0);
      expect(paymentMethods.cashTotal, 0.0);
      expect(paymentMethods.upiPercent, 0);
      expect(paymentMethods.cashPercent, 0);

      final paymentStatus = dashboardPaymentStatusSignal.value;
      expect(paymentStatus.paidTotal, 0.0);
      expect(paymentStatus.freeTotal, 0.0);
      expect(paymentStatus.paidCount, 0);
      expect(paymentStatus.freeCount, 0);
      expect(paymentStatus.paidPercent, 0);
      expect(paymentStatus.freePercent, 0);

      expect(dashboardTopProductsSignal.value.isEmpty, isTrue);
      expect(dashboardLowStockProductsSignal.value.isEmpty, isTrue);
      expect(dashboardRecentOrdersSignal.value.value?.isEmpty ?? false, isTrue);
    });

    test('DashboardRange signal state transitions cleanly', () {
      dashboardRangeSignal.value = DashboardRange.today;
      expect(dashboardRangeSignal.value, DashboardRange.today);

      dashboardRangeSignal.value = DashboardRange.days30;
      expect(dashboardRangeSignal.value, DashboardRange.days30);

      dashboardRangeSignal.value = DashboardRange.year1;
      expect(dashboardRangeSignal.value, DashboardRange.year1);
    });

    test('DashboardSignalsUpdater.applyAnalytics parses analytics payload in Rupees correctly', () {
      final mockAnalyticsPayload = <String, dynamic>{
        'totalRevenue': 15450.50, // ₹15,450.50
        'totalOrders': 120,
        'aov': 128.75, // ₹128.75
        'lowStockCount': 3,
        'revenueGrowth': 15.2,
        'ordersGrowth': 8.5,
        'aovGrowth': 6.2,
        'paymentMethods': {
          'upiTotal': 10815.35, // ~70% of ₹15,450.50
          'cashTotal': 4635.15, // ~30% of ₹15,450.50
        },
        'paymentStatus': {
          'paidTotal': 15450.50,
          'freeTotal': 0.0,
          'paidCount': 114,
          'freeCount': 6,
        },
        'categorySales': {
          'labels': ['Beverages', 'Bakery', 'Desserts'],
          'data': [8000.0, 5000.0, 2450.50],
        },
        'hourlyTraffic': {
          'labels': ['9 AM', '12 PM', '3 PM', '6 PM', '9 PM'],
          'data': [15, 45, 20, 30, 10],
        },
        'topProducts': [
          {
            'name': 'Cold Coffee',
            'category': 'Beverages',
            'quantitySold': 65,
            'totalRevenue': 520000.0, // 520000 paise = ₹5200.00
          },
          {
            'name': 'Paneer Sandwich',
            'category': 'Snacks',
            'quantitySold': 40,
            'totalRevenue': 480000.0, // 480000 paise = ₹4800.00
          },
        ],
        'lowStockProducts': [
          {
            'id': 'prod-milk',
            'name': 'Organic Milk',
            'sellingPrice': 6000.0, // 6000 paise = ₹60.00
            'quantity': 4,
            'lowStockThreshold': 10,
            'category': 'Dairy',
          },
        ],
      };

      DashboardSignalsUpdater.applyAnalytics(
        analytics: mockAnalyticsPayload,
        storeId: 'store-100',
      );

      final summary = dashboardSummarySignal.value;
      expect(summary.totalRevenue, 15450.50);
      expect(summary.totalOrders, 120);
      expect(summary.aov, 128.75);
      expect(summary.lowStockCount, 3);
      expect(summary.revenueGrowth, 15.2);
      expect(summary.ordersGrowth, 8.5);

      final paymentMethods = dashboardPaymentMethodsSignal.value;
      expect(paymentMethods.upiTotal, 10815.35);
      expect(paymentMethods.cashTotal, 4635.15);
      expect(paymentMethods.upiPercent, 70);
      expect(paymentMethods.cashPercent, 30);

      final paymentStatus = dashboardPaymentStatusSignal.value;
      expect(paymentStatus.paidCount, 114);
      expect(paymentStatus.freeCount, 6);
      expect(paymentStatus.paidPercent, 95);
      expect(paymentStatus.freePercent, 5);

      final topProducts = dashboardTopProductsSignal.value;
      expect(topProducts.length, 2);
      expect(topProducts[0].name, 'Cold Coffee');
      expect(topProducts[0].units, '65 sold');
      expect(topProducts[0].revenue, '₹ 5200.00');

      final lowStock = dashboardLowStockProductsSignal.value;
      expect(lowStock.length, 1);
      expect(lowStock[0].name, 'Organic Milk');
      expect(lowStock[0].stock?.quantity, 4);
    });

    test('DashboardSignalsUpdater.applyOrdersFallback calculates metrics accurately from order models', () {
      final orderItem1 = OrderItem(
        id: 'oi-1',
        productId: 'p-1',
        product: null,
        storeId: 's-1',
        quantity: 2,
        unitPrice: 150.0,
        taxRate: 5.0,
      );

      final orderItem2 = OrderItem(
        id: 'oi-2',
        productId: 'p-2',
        product: null,
        storeId: 's-1',
        quantity: 1,
        unitPrice: 100.0,
        taxRate: 10.0,
      );

      final orderItem3 = OrderItem(
        id: 'oi-3',
        productId: 'p-3',
        product: null,
        storeId: 's-1',
        quantity: 1,
        unitPrice: 50.0,
        taxRate: 0.0,
      );

      // Order 1: UPI payment (₹315.00)
      final order1 = Order(
        id: 'order-1',
        merchantId: 'm-1',
        storeId: 's-1',
        orderReference: 'ORD-001',
        billNo: 1,
        source: OrderSource.terminal,
        type: OrderType.dineIn,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.upi,
        subtotal: 300.0,
        taxTotal: 15.0,
        grandTotal: 315.0,
        items: [orderItem1],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Order 2: Cash payment (₹110.00)
      final order2 = Order(
        id: 'order-2',
        merchantId: 'm-1',
        storeId: 's-1',
        orderReference: 'ORD-002',
        billNo: 2,
        source: OrderSource.terminal,
        type: OrderType.takeaway,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.cash,
        subtotal: 100.0,
        taxTotal: 10.0,
        grandTotal: 110.0,
        items: [orderItem2],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Order 3: Complimentary payment (₹0.00 grandTotal, ₹50.00 subtotal)
      final order3 = Order(
        id: 'order-3',
        merchantId: 'm-1',
        storeId: 's-1',
        orderReference: 'ORD-003',
        billNo: 3,
        source: OrderSource.terminal,
        type: OrderType.dineIn,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.complimentary,
        subtotal: 50.0,
        taxTotal: 0.0,
        grandTotal: 0.0,
        items: [orderItem3],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final OrderPaginatedResponse paginatedOrders = (
        items: [order1, order2, order3],
        currentPage: 1,
        pageSize: 50,
        totalItems: 3,
        totalPages: 1,
        summary: (
          totalOrders: 3,
          grossSubtotal: 450.0,
          totalDiscount: 0.0,
          netRevenue: 425.0, // ₹315.00 + ₹110.00 = ₹425.00
          cashCollected: 110.0,
          upiCollected: 315.0,
          walletCollected: 0.0,
          freeTotal: 50.0,
        ),
      );

      DashboardSignalsUpdater.applyOrdersFallback(paginatedOrders);

      final summary = dashboardSummarySignal.value;
      // Total Revenue = ₹425.00, Total Orders = 3, AOV = 425 / 3 = 141.666...
      expect(summary.totalRevenue, 425.0);
      expect(summary.totalOrders, 3);
      expect(summary.aov, closeTo(141.67, 0.01));

      final paymentMethods = dashboardPaymentMethodsSignal.value;
      // UPI = ₹315.00, Cash = ₹110.00 -> Sum = ₹425.00
      // UPI% = (315 / 425) * 100 = 74%, Cash% = 26%
      expect(paymentMethods.upiTotal, 315.0);
      expect(paymentMethods.cashTotal, 110.0);
      expect(paymentMethods.upiPercent, 74);
      expect(paymentMethods.cashPercent, 26);

      final paymentStatus = dashboardPaymentStatusSignal.value;
      // 2 Paid (order1, order2), 1 Complimentary (order3)
      expect(paymentStatus.paidCount, 2);
      expect(paymentStatus.freeCount, 1);
      expect(paymentStatus.paidPercent, 67);
      expect(paymentStatus.freePercent, 33);
      expect(paymentStatus.paidTotal, 425.0);
      expect(paymentStatus.freeTotal, 50.0);

      // Verify recent orders signal contains all items
      expect(dashboardRecentOrdersSignal.value.value?.length, 3);
    });
  });
}
