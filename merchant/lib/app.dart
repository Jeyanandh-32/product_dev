import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/toast.dart';
import 'package:merchant/pages/forgot_password.dart';
import 'package:merchant/pages/home.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/pages/login.dart';
import 'package:merchant/pages/register.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:merchant/tabs/account.dart';
import 'package:merchant/tabs/dashboard.dart';
import 'package:merchant/tabs/inventory.dart';
import 'package:merchant/tabs/reports.dart';
import 'package:merchant/tabs/settings.dart';
import 'package:merchant/tabs/stores.dart';

String? _authRedirect(BuildContext context, RouteState state) {
  final merchant = context.read(authProvider).value;
  if (merchant == null) {
    return '/login';
  }
  return null;
}

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    final authState = context.watch(authProvider);
    return authState.when(
      data: (data) => main_([
        Toast(),
        Router(
          routes: [
            ShellRoute(
              builder: (context, state, child) => Home(child: child),
              routes: [
                Route(
                  path: '/',
                  builder: (context, state) => const Dashboard(),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory',
                  builder: (context, state) => const Inventory(subIndex: 0),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory/categories',
                  builder: (context, state) => const Inventory(subIndex: 1),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory/counters',
                  builder: (context, state) => const Inventory(subIndex: 2),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports',
                  builder: (context, state) => const Reports(subIndex: 0),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/payments',
                  builder: (context, state) => const Reports(subIndex: 1),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/credits',
                  builder: (context, state) => const Reports(subIndex: 2),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/profit-loss',
                  builder: (context, state) => const Reports(subIndex: 3),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/stock-summary',
                  builder: (context, state) => const Reports(subIndex: 4),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/stores',
                  builder: (context, state) => const Stores(),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/account',
                  builder: (context, state) => const Account(),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/settings',
                  builder: (context, state) => const Settings(),
                  redirect: _authRedirect,
                ),
              ],
            ),
            Route(
              path: '/register',
              builder: (context, state) => Register(),
              redirect: (context, state) {
                final merchant = context.read(authProvider).value;

                if (merchant == null) {
                  return null;
                }

                return '/';
              },
            ),
            Route(
              path: '/login',
              builder: (context, state) => Login(),
              redirect: (context, state) {
                final merchant = context.read(authProvider).value;

                if (merchant == null) {
                  return null;
                }

                return '/';
              },
            ),
            Route(
              path: '/forgotPassword',
              builder: (context, state) => ForgotPassword(),
              redirect: (context, state) {
                final merchant = context.read(authProvider).value;

                if (merchant == null) {
                  return null;
                }

                return '/';
              },
            ),
          ],
        ),
      ]),
      error: (error, stackTrace) => Router(
        routes: [
          Route(
            path: '/',
            builder: (context, state) => Login(),
          ),
        ],
      ),
      loading: () => Loading(),
    );
  }
}

