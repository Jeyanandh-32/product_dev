import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/signals/products_signal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Terminal Logout and State Reset Tests', () {
    final now = DateTime.now();

    test('resetAllTerminalSignals cleanly restores all domain states to default', () {
      final p = Product(id: 'p1', merchantId: 'm1', name: 'Test', basePrice: 10, sellingPrice: 20, taxRate: 5, isActive: true, createdAt: now, updatedAt: now);
      cartSignal.value = CartState(items: [CartItem(product: p, quantity: 2)], noOfItems: 1, orderQuantity: 2, subtotal: 40.0, discountTotal: 5.0, taxTotal: 2.0, grandTotal: 37.0);
      discountInputSignal.value = 5.0;
      paymentModeSignal.value = PaymentMethod.complimentary;
      printBillSignal.value = false;
      showOrderSummaryDetailsSignal.value = false;

      searchQuerySignal.value = 'coffee';
      productsSignal.value = const AsyncData([]);
      selectedCategorySignal.value = Category(id: 'c1', merchantId: 'm1', storeId: 's1', name: 'Beverages', isActive: true, createdAt: now, updatedAt: now);
      activeTerminalPageSignal.value = TerminalNavPage.orders;

      orderSourceTabSignal.value = OrderSourceTab.online;
      orderDatePresetSignal.value = OrderDatePreset.past7Days;
      orderSearchQuerySignal.value = 'ORD-123';
      orderPageSizeSignal.value = 100;
      orderCurrentPageSignal.value = 3;
      orderPaymentMethodFilterSignal.value = PaymentMethod.upi;
      orderStatusFilterSignal.value = OrderStatus.completed;

      inventorySearchSignal.value = 'latte';
      inventoryCategoryFilterSignal.value = 'c1';
      inventoryCounterFilterSignal.value = 'cnt1';
      inventoryStatusFilterSignal.value = true;
      inventoryStockHealthFilterSignal.value = StockHealthFilter.lowStock;
      inventoryPageSignal.value = 4;
      categorySearchSignal.value = 'food';
      counterSearchSignal.value = 'bar';

      resetAllTerminalSignals();

      // Assert Cart reset
      expect(cartSignal.value.items.isEmpty, isTrue);
      expect(cartSignal.value.grandTotal, 0.0);
      expect(discountInputSignal.value, 0.0);
      expect(paymentModeSignal.value, PaymentMethod.cash);
      expect(printBillSignal.value, isTrue);
      expect(showOrderSummaryDetailsSignal.value, isTrue);

      // Assert Catalog reset
      expect(searchQuerySignal.value, '');
      expect(productsSignal.value.isLoading, isTrue);
      expect(selectedCategorySignal.value, isNull);

      // Assert Navigation reset
      expect(activeTerminalPageSignal.value, TerminalNavPage.billing);

      // Assert Orders reset
      expect(orderSourceTabSignal.value, OrderSourceTab.thisTerminal);
      expect(orderDatePresetSignal.value, OrderDatePreset.today);
      expect(orderSearchQuerySignal.value, '');
      expect(orderPageSizeSignal.value, 50);
      expect(orderCurrentPageSignal.value, 1);
      expect(orderPaymentMethodFilterSignal.value, isNull);
      expect(orderStatusFilterSignal.value, isNull);
      expect(ordersSignal.value.isLoading, isTrue);

      // Assert Inventory reset
      expect(inventorySearchSignal.value, '');
      expect(inventoryCategoryFilterSignal.value, isNull);
      expect(inventoryCounterFilterSignal.value, isNull);
      expect(inventoryStatusFilterSignal.value, isNull);
      expect(inventoryStockHealthFilterSignal.value, StockHealthFilter.all);
      expect(inventoryPageSignal.value, 1);
      expect(categorySearchSignal.value, '');
      expect(counterSearchSignal.value, '');
    });

    test('logoutTerminal clears authentication and resets all state', () async {
      authSignal.value = AsyncData(Terminal(code: '101', merchantId: 'm1', storeId: 's1', name: 'POS 1', isActive: true, createdAt: now, updatedAt: now));
      searchQuerySignal.value = 'stale search';
      activeTerminalPageSignal.value = TerminalNavPage.inventoryProducts;

      await logoutTerminal();

      expect(authSignal.value.value, isNull);
      expect(searchQuerySignal.value, '');
      expect(activeTerminalPageSignal.value, TerminalNavPage.billing);
    });
  });
}
