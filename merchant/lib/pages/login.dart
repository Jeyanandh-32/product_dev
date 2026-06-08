import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/pages/loading.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Login extends StatefulComponent {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final email = _email.trim();
    final password = _password.trim();

    print('email = $email');
    print('password = $password');

    context.read(authProvider.notifier).login(email: email, password: password);
  }

  @override
  Component build(BuildContext context) {
    final authState = context.watch(authProvider);
    if (authState.isLoading) return Loading();

    return AuthLayout(
      title: 'Sign in to your account',
      descriptionLine1: 'Enter to your credentials to access',
      descriptionLine2: 'and tracking sales today.',
      formContent: form(
        classes: 'card-body items-start',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(context, e),
        },
        [
          FormField(
            id: 'email',
            labelText: 'Email',
            icon: Mail(classes: 'w-4.5 h-4.5'),
            type: .email,
            onChange: (value) => _email = value as String,
            attributes: {
              'placeholder': 'jacksparrow@example.com',
              'required': '',
              'value': _email,
            },
            hintText: 'Email is required.',
          ),

          FormField(
            id: 'password',
            labelText: 'Password',
            icon: Lock(classes: 'w-4.5 h-4.5'),
            type: .password,
            enableForgotPassword: true,
            onChange: (value) => _password = value as String,
            attributes: {
              'placeholder': '*********',
              'required': '',
              'pattern': ValidationPatterns.password,
              'minlength': '6',
              'value': _password,
            },
            hintText:
                'Must be 6+ characters with a number, lowercase, and uppercase.',
          ),

          button(
            classes: 'btn btn-primary mt-3 rounded-lg h-12 w-full',
            type: .submit,
            [
              .text('Sign In'),
            ],
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer',
        onClick: () => context.push('/register'),
        [
          span([.text('New to Brand?')]),
          span(classes: 'text-accent font-semibold ml-1', [
            .text('Create an account'),
          ]),
        ],
      ),
    );
  }
}
