import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/pages/cart_page.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/pages/login.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Listenable bridge notifying [GoRouter] whenever [authSignal] updates.
class RouterListenable extends ChangeNotifier {
  RouterListenable() {
    authSignal.subscribe((_) {
      notifyListeners();
    });
  }
}

/// Global listenable instance bound to reactive authentication state changes.
final routerListenable = RouterListenable();

/// Application router defining routes, guards, and auth redirects.
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
      builder: (context, state) =>
          const FScaffold(childPad: false, child: Loading()),
    ),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/', builder: (context, state) => const Home()),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
  ],
);
