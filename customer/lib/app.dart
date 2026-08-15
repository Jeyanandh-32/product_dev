import 'package:customer/components/navigation/customer_app_router.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/components/toast.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Root customer web application component managing auth state and declarative routing.
class App extends SignalComponent {
  const App({super.key});

  @override
  SignalState<App> createState() => _AppState();
}

class _AppState extends SignalState<App> {
  @override
  Component buildSignal(BuildContext context) {
    final authState = customerAuthSignal.value;

    return authState.map(
      data: (data) => main_([
        const Toast(),
        Router(routes: CustomerAppRouter.buildRoutes()),
      ]),
      error: (error, stackTrace) => main_([
        const Toast(),
        Router(routes: CustomerAppRouter.buildRoutes()),
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
