import 'package:customer/components/signal_component.dart';
import 'package:customer/components/toast.dart';
import 'package:customer/pages/register.dart';
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
    if (customer != null) return '/';
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
                final customer = customerAuthSignal.value.value;
                if (customer == null) {
                  return const RegisterPage();
                }
                return child;
              },
              routes: [
                Route(
                  path: '/',
                  builder: (context, state) {
                    final customer = customerAuthSignal.value.value;
                    return div(
                      classes: 'min-h-screen flex items-center justify-center p-6',
                      [
                        h1(classes: 'text-2xl font-bold text-primary', [
                          .text('Welcome back, ${customer?.name ?? ''}!'),
                        ]),
                      ],
                    );
                  },
                ),
              ],
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
      error: (error, stackTrace) => Router(
        routes: [
          Route(
            path: '/',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
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
