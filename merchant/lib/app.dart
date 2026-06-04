import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/pages/home.dart';
import 'package:merchant/pages/login.dart';
import 'package:merchant/pages/registration.dart';
import 'package:merchant/providers/auth_provider.dart';

// The main component of your application.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        Route(
          path: '/',
          builder: (context, state) => Home(),
          redirect: (context, state) {
            final merchant = context.read(authProvider);

            if (merchant == null) {
              return '/login';
            }

            return null;
          },
        ),
        Route(
          path: '/register',
          builder: (context, state) => Registration(),
          redirect: (context, state) {
            final merchant = context.read(authProvider);

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
            final merchant = context.read(authProvider);

            if (merchant == null) {
              return null;
            }

            return '/';
          },
        ),
      ],
    );
  }
}
