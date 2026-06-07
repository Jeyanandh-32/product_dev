import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/toast.dart';
import 'package:merchant/pages/forgot_password.dart';
import 'package:merchant/pages/home.dart';
import 'package:merchant/pages/loading.dart';
import 'package:merchant/pages/login.dart';
import 'package:merchant/pages/register.dart';
import 'package:merchant/providers/auth_provider.dart';

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
            Route(
              path: '/',
              builder: (context, state) => Home(),
              redirect: (context, state) {
                final merchant = context.read(authProvider).value;

                if (merchant == null) {
                  return '/login';
                }

                return null;
              },
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
