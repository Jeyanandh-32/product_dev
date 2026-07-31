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
import 'package:merchant/providers/auth_provider.dart';

class App extends SignalComponent {
  const App({super.key});

  @override
  SignalState<App> createState() => _AppState();
}

class _AppState extends SignalState<App> {
  @override
  Component buildSignal(BuildContext context) {
    final authState = authSignal.value;
    return authState.map(
      data: (data) => main_([
        const Toast(),
        Router(
          routes: [
            Route(
              path: '/',
              builder: (context, state) => const Home(),
              redirect: (context, state) {
                final merchant = authSignal.value.value;
                if (merchant == null) return '/login';
                return null;
              },
            ),
            Route(
              path: '/register',
              builder: (context, state) => const Register(),
              redirect: (context, state) {
                final merchant = authSignal.value.value;
                if (merchant == null) return null;
                return '/';
              },
            ),
            Route(
              path: '/login',
              builder: (context, state) => const Login(),
              redirect: (context, state) {
                final merchant = authSignal.value.value;
                if (merchant == null) return null;
                return '/';
              },
            ),
            Route(
              path: '/forgotPassword',
              builder: (context, state) => const ForgotPassword(),
              redirect: (context, state) {
                final merchant = authSignal.value.value;
                if (merchant == null) return null;
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
            builder: (context, state) => const Login(),
          ),
        ],
      ),
      loading: () => const Loading(),
    );
  }
}
