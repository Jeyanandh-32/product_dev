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
import 'package:merchant/providers/ui_providers.dart';
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
                  builder: (context, state) => const HeaderSetter(
                    title: 'Dashboard',
                    child: Dashboard(),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory',
                  redirect: (context, state) {
                    final authResult = _authRedirect(context, state);
                    if (authResult != null) return authResult;
                    return '/inventory/products';
                  },
                ),
                Route(
                  path: '/inventory/products',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Inventory',
                    subtitle: 'Products',
                    child: Inventory(subIndex: 0),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory/categories',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Inventory',
                    subtitle: 'Category',
                    child: Inventory(subIndex: 1),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/inventory/counters',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Inventory',
                    subtitle: 'Counters',
                    child: Inventory(subIndex: 2),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports',
                  redirect: (context, state) {
                    final authResult = _authRedirect(context, state);
                    if (authResult != null) return authResult;
                    return '/reports/orders';
                  },
                ),
                Route(
                  path: '/reports/orders',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Reports',
                    subtitle: 'Orders',
                    child: Reports(subIndex: 0),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/payments',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Reports',
                    subtitle: 'Payments',
                    child: Reports(subIndex: 1),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/credits',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Reports',
                    subtitle: 'Credits',
                    child: Reports(subIndex: 2),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/profit-loss',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Reports',
                    subtitle: 'Profit & Loss',
                    child: Reports(subIndex: 3),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/reports/stock-summary',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Reports',
                    subtitle: 'Stock Summary',
                    child: Reports(subIndex: 4),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/stores',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Stores',
                    child: Stores(),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/account',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Account',
                    child: Account(),
                  ),
                  redirect: _authRedirect,
                ),
                Route(
                  path: '/settings',
                  builder: (context, state) => const HeaderSetter(
                    title: 'Settings',
                    child: Settings(),
                  ),
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

class HeaderSetter extends StatefulComponent {
  const HeaderSetter({
    required this.title,
    this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Component child;

  @override
  State<HeaderSetter> createState() => _HeaderSetterState();
}

class _HeaderSetterState extends State<HeaderSetter> {
  @override
  void initState() {
    super.initState();
    _updateHeader();
  }

  @override
  void didUpdateComponent(HeaderSetter oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.title != component.title ||
        oldComponent.subtitle != component.subtitle) {
      _updateHeader();
    }
  }

  void _updateHeader() {
    Future.microtask(() {
      context.read(headerTitleProvider.notifier).state = component.title;
      context.read(headerSubTitleProvider.notifier).state = component.subtitle;
    });
  }

  @override
  Component build(BuildContext context) {
    return component.child;
  }
}


