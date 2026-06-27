import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/pages/login.dart';
import 'package:terminal/providers/auth_provider.dart';

class RouterListenable extends ChangeNotifier {
  RouterListenable(Ref ref) {
    ref.listen(authProvider, (prev, next) {
      notifyListeners();
    });
  }
}

final routerListenableProvider = Provider<Listenable>((ref) {
  return RouterListenable(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = ref.watch(routerListenableProvider);

  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // While authenticating on startup, show loading page.
      // If we are on the login screen, let the login screen handle its own loading indicator.
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
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const Scaffold(
          body: Loading(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
    ],
  );
});
