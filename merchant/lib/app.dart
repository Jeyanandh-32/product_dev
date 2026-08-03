import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/toast.dart';
import 'package:merchant/pages/forgot_password.dart';
import 'package:merchant/pages/home.dart';
import 'package:merchant/pages/login.dart';
import 'package:merchant/pages/register.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/sub_tabs/categories.dart';
import 'package:merchant/sub_tabs/counters.dart';
import 'package:merchant/sub_tabs/orders.dart';
import 'package:merchant/sub_tabs/payments.dart';
import 'package:merchant/sub_tabs/products.dart';
import 'package:merchant/sub_tabs/profit_loss.dart';
import 'package:merchant/sub_tabs/stock_summary.dart';
import 'package:merchant/tabs/account.dart';
import 'package:merchant/tabs/dashboard.dart';
import 'package:merchant/tabs/settings.dart';
import 'package:merchant/tabs/stores.dart';

class App extends SignalComponent {
  const App({super.key});

  @override
  SignalState<App> createState() => _AppState();
}

class _AppState extends SignalState<App> {
  String? _guestOnlyRedirect(BuildContext context, RouteState state) {
    final merchant = authSignal.value.value;
    if (merchant != null) return '/';
    return null;
  }

  @override
  Component buildSignal(BuildContext context) {
    final authState = authSignal.value;
    return authState.map(
      data: (data) => main_([
        const Toast(),
        Router(
          routes: [
            ShellRoute(
              builder: (context, state, child) {
                final merchant = authSignal.value.value;
                if (merchant == null) {
                  return const Login();
                }
                return Home(child: child);
              },
              routes: [
                Route(
                  path: '/',
                  builder: (context, state) => const Dashboard(),
                ),
                Route(
                  path: '/inventory',
                  redirect: (context, state) => '/inventory/products',
                ),
                Route(
                  path: '/inventory/products',
                  builder: (context, state) => const Products(),
                ),
                Route(
                  path: '/inventory/categories',
                  builder: (context, state) => const Categories(),
                ),
                Route(
                  path: '/inventory/counters',
                  builder: (context, state) => const Counters(),
                ),
                Route(
                  path: '/reports',
                  redirect: (context, state) => '/reports/orders',
                ),
                Route(
                  path: '/reports/orders',
                  builder: (context, state) => const Orders(),
                ),
                Route(
                  path: '/reports/payments',
                  builder: (context, state) => const Payments(),
                ),
                Route(
                  path: '/reports/profit-loss',
                  builder: (context, state) => const ProfitLoss(),
                ),
                Route(
                  path: '/reports/stock-summary',
                  builder: (context, state) => const StockSummary(),
                ),
                Route(
                  path: '/stores',
                  builder: (context, state) => const Stores(),
                ),
                Route(
                  path: '/account',
                  builder: (context, state) => const Account(),
                ),
                Route(
                  path: '/settings',
                  builder: (context, state) => const Settings(),
                ),
              ],
            ),
            Route(
              path: '/register',
              builder: (context, state) => const Register(),
              redirect: _guestOnlyRedirect,
            ),
            Route(
              path: '/login',
              builder: (context, state) => const Login(),
              redirect: _guestOnlyRedirect,
            ),
            Route(
              path: '/forgotPassword',
              builder: (context, state) => const ForgotPassword(),
              redirect: _guestOnlyRedirect,
            ),
            Route(
              path: '/:path*',
              redirect: (context, state) => '/',
            ),
          ],
        ),
      ]),
      error: (error, stackTrace) => Router(
        routes: [
          Route(
            path: '/',
            builder: (context, state) => const Login(),
          ),
        ],
      ),
      loading: () => const Loading(),
    );
  }
}
