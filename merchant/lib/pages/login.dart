import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/auth_layout.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/pages/loading.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:merchant/providers/field_providers.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Login extends StatelessComponent {
  const Login({super.key});

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final email = context.read(loginEmailProvider).trim();
    final password = context.read(loginPasswordProvider).trim();

    print('email = $email');
    print('password = $password');

    context.read(authProvider.notifier).login(email: email, password: password);
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
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
            onChange: (value) =>
                _onChange(loginEmailProvider, context, value),
            attributes: {
              'placeholder': 'jacksparrow@example.com',
              'required': '',
            },
            hintText: 'Email is required.',
          ),

          FormField(
            id: 'password',
            labelText: 'Password',
            icon: Lock(classes: 'w-4.5 h-4.5'),
            type: .password,
            enableForgotPassword: true,
            onChange: (value) =>
                _onChange(loginPasswordProvider, context, value),
            attributes: {
              'placeholder': '*********',
              'required': '',
              'pattern': ValidationPatterns.password,
              'minlength': '6',
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
