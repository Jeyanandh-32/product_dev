import 'package:customer/components/layouts/app_layout.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/components/toast.dart';
import 'package:customer/pages/cart.dart';
import 'package:customer/pages/login.dart';
import 'package:customer/pages/order_status.dart';
import 'package:customer/pages/orders.dart';
import 'package:customer/pages/profile.dart';
import 'package:customer/pages/register.dart';
import 'package:customer/pages/store_detail.dart';
import 'package:customer/pages/store_search.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class App extends SignalComponent {
  const App({super.key});

  @override
  SignalState<App> createState() => _AppState();
}

class _AppState extends SignalState<App> {
  String? _guestOnlyRedirect(BuildContext context, RouteState state) {
    final customer = customerAuthSignal.value.value;
    if (customer != null) {
      final savedRedirect = redirectPathSignal.value;
      if (savedRedirect != null && savedRedirect.isNotEmpty) {
        redirectPathSignal.value = null;
        return savedRedirect;
      }
      return '/';
    }
    return null;
  }

  @override
  Component buildSignal(BuildContext context) {
    final authState = customerAuthSignal.value;

    return authState.map(
      data: (data) => main_([
        const Toast(),
        Router(
          routes: [
            ShellRoute(
              builder: (context, state, child) {
                return AppLayout(child: child);
              },
              routes: [
                Route(
                  path: '/',
                  builder: (context, state) => const StoreSearchPage(),
                ),
                Route(
                  path: '/stores',
                  redirect: (context, state) => '/?all=true',
                ),
                Route(
                  path: '/store/:slug',
                  builder: (context, state) => StoreDetailPage(
                    slug: state.params['slug'] ?? '',
                  ),
                ),
                Route(
                  path: '/cart',
                  builder: (context, state) => const CartPage(),
                ),
                Route(
                  path: '/order/status',
                  builder: (context, state) => OrderStatusPage(
                    reference: state.queryParams['reference'] ?? '',
                  ),
                ),
                Route(
                  path: '/orders',
                  builder: (context, state) => const CustomerOrdersPage(),
                  redirect: (context, state) {
                    final customer = customerAuthSignal.value.value;
                    if (customer == null) {
                      redirectPathSignal.value = '/orders';
                      return '/login';
                    }
                    return null;
                  },
                ),
                Route(
                  path: '/profile',
                  builder: (context, state) => const CustomerProfilePage(),
                  redirect: (context, state) {
                    final customer = customerAuthSignal.value.value;
                    if (customer == null) {
                      redirectPathSignal.value = '/profile';
                      return '/login';
                    }
                    return null;
                  },
                ),
              ],
            ),
            Route(
              path: '/login',
              builder: (context, state) => const LoginPage(),
              redirect: _guestOnlyRedirect,
            ),
            Route(
              path: '/register',
              builder: (context, state) => const RegisterPage(),
              redirect: _guestOnlyRedirect,
            ),
            Route(
              path: '/:path*',
              redirect: (context, state) => '/',
            ),
          ],
        ),
      ]),
      error: (error, stackTrace) => main_([
        const Toast(),
        Router(
          routes: [
            ShellRoute(
              builder: (context, state, child) => AppLayout(child: child),
              routes: [
                Route(
                  path: '/',
                  builder: (context, state) => const StoreSearchPage(),
                ),
                Route(
                  path: '/store/:slug',
                  builder: (context, state) => StoreDetailPage(
                    slug: state.params['slug'] ?? '',
                  ),
                ),
                Route(
                  path: '/cart',
                  builder: (context, state) => const CartPage(),
                ),
                Route(
                  path: '/order/status',
                  builder: (context, state) => OrderStatusPage(
                    reference: state.queryParams['reference'] ?? '',
                  ),
                ),
                Route(
                  path: '/orders',
                  builder: (context, state) => const CustomerOrdersPage(),
                  redirect: (context, state) => '/login',
                ),
                Route(
                  path: '/profile',
                  builder: (context, state) => const CustomerProfilePage(),
                  redirect: (context, state) => '/login',
                ),
              ],
            ),
            Route(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
            Route(
              path: '/register',
              builder: (context, state) => const RegisterPage(),
            ),
            Route(
              path: '/:path*',
              redirect: (context, state) => '/',
            ),
          ],
        ),
      ]),
      loading: () => main_([
        div(
          classes: 'min-h-screen flex items-center justify-center bg-base-100',
          [
            span(
              classes: 'loading loading-spinner loading-lg text-primary',
              [],
            ),
          ],
        ),
      ]),
    );
  }
}
