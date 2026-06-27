import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/pages/login.dart';
import 'package:terminal/providers/auth_provider.dart';

class RouterListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final routerListenable = RouterListenable();

final router = GoRouter(
  initialLocation: '/loading',
  refreshListenable: routerListenable,
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const Scaffold(body: Loading()),
    ),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/', builder: (context, state) => const Home()),
  ],
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final authState = container.read(authProvider);

    if (authState.isLoading) {
      if (state.matchedLocation == '/login') {
        return null;
      }
      return '/loading';
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
);
