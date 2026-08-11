import 'package:customer/components/toast.dart';
import 'package:customer/pages/register.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return main_([
      const Toast(),
      Router(
        routes: [
          Route(
            path: '/',
            redirect: (context, state) => '/register',
          ),
          Route(
            path: '/register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
    ]);
  }
}
