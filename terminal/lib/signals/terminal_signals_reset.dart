import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/signals/products_signal.dart';

/// Resets all global reactive signals and caches across the terminal application.
void resetAllTerminalSignals() {
  resetCartSignal();
  resetProductsSignal();
  resetCategoriesSignal();
  resetCountersSignal();
  resetOrdersSignal();
  resetInventoryProductsSignal();
  resetInventoryCategoriesSignal();
  resetInventoryCountersSignal();
  resetNavigationSignal();
}
