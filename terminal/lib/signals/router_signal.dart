import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/pages/account_page.dart';
import 'package:terminal/pages/cart_page.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/pages/inventory_categories_page.dart';
import 'package:terminal/pages/inventory_counters_page.dart';
import 'package:terminal/pages/inventory_products_page.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/pages/login.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/auth_signal.dart';

class RouterListenable extends ChangeNotifier {
  RouterListenable() {
    authSignal.subscribe((_) {
      notifyListeners();
    });
  }
}

final routerListenable = RouterListenable();

final appRouter = GoRouter(
  initialLocation: '/loading',
  refreshListenable: routerListenable,
  redirect: (context, state) {
    final authState = authSignal.value;

    if (authState.isLoading) {
      return state.matchedLocation == '/loading' ? null : '/loading';
    }

    final terminal = authState.value;
    final isLoggingIn = state.matchedLocation == '/login';

    if (terminal == null) {
      return isLoggingIn ? null : '/login';
    }

    if (isLoggingIn || state.matchedLocation == '/loading') {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const FScaffold(childPad: false, child: Loading()),
    ),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/', builder: (context, state) => const Home()),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(path: '/account', builder: (context, state) => const AccountPage()),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersPage()),
    GoRoute(
      path: '/inventory/products',
      builder: (context, state) => const InventoryProductsPage(),
    ),
    GoRoute(
      path: '/inventory/categories',
      builder: (context, state) => const InventoryCategoriesPage(),
    ),
    GoRoute(
      path: '/inventory/counters',
      builder: (context, state) => const InventoryCountersPage(),
    ),
  ],
);
