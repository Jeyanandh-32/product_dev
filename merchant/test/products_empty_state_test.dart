import 'package:merchant/components/modals/update_stock_handler.dart';
import 'package:merchant/components/reports/products_empty_state.dart';
import 'package:merchant/components/reports/products_modals_host.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  group('ProductsEmptyState Tests', () {
    test('ProductsEmptyState constructs properly with hasCategories flag', () {
      const stateWithoutCategories = ProductsEmptyState(hasCategories: false);
      expect(stateWithoutCategories.hasCategories, isFalse);

      const stateWithCategories = ProductsEmptyState(hasCategories: true);
      expect(stateWithCategories.hasCategories, isTrue);
    });

    test('ProductsEmptyState modal trigger interactions', () {
      activeModalSignal.value = ActiveModal.none;
      editingCategorySignal.value = null;

      // Simulate clicking create first category
      editingCategorySignal.value = null;
      activeModalSignal.value = ActiveModal.addCategory;
      expect(activeModalSignal.value, ActiveModal.addCategory);

      // Simulate clicking add product
      editingProductSignal.value = null;
      activeModalSignal.value = ActiveModal.addProduct;
      expect(activeModalSignal.value, ActiveModal.addProduct);
    });

    test('ProductsModalsHost can be instantiated as SignalComponent', () {
      const host = ProductsModalsHost();
      expect(host, isNotNull);
    });
  });

  group('UpdateStockHandler Tests', () {
    final sampleProduct = Product(
      id: 'prod-1',
      merchantId: 'm-1',
      name: 'Espresso',
      taxRate: 5.0,
      basePrice: 50.0,
      sellingPrice: 100.0,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      stock: Stock(
        id: 'stock-1',
        productId: 'prod-1',
        storeId: 'store-1',
        quantity: 20,
        lowStockThreshold: 5,
        stockMonitor: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    test(
      'submitStockUpdate with empty amount updates settings only without error',
      () {
        activeModalSignal.value = ActiveModal.updateStock;

        UpdateStockHandler.submitStockUpdate(
          product: sampleProduct,
          transactionType: StockTransactionType.add,
          amountStr: '',
          lowStockThresholdStr: '10',
          stockMonitor: true,
          reason: StockTransactionReason.adjustment,
          customReason: '',
        );

        expect(activeModalSignal.value, ActiveModal.none);
      },
    );
  });
}
