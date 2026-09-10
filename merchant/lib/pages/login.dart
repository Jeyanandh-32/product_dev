import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/auth/auth_submit_button.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Login extends SignalComponent {
  const Login({super.key});

  @override
  SignalState<Login> createState() => _LoginState();
}

class _LoginState extends SignalState<Login> {
  String _email = '';
  String _password = '';

  void _onSubmit(Event e) {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final email = _email.trim();
    final password = _password.trim();

    loginMerchant(email: email, password: password);
  }

  @override
  Component buildSignal(BuildContext context) {
    final isSubmitting = authSubmittingSignal.value;

    return AuthLayout(
      formContent: form(
        classes: 'w-full flex flex-col',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(e),
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
            onChange: (value) => setState(() => _password = value as String),

            attributes: {
              'placeholder': '*********',
              'required': '',
              'pattern': ValidationPatterns.password,
              'minlength': '6',
              'value': _password,
            },
            hintText: 'Must be 6+ characters with a number, lowercase, and uppercase.',
          ),

          AuthSubmitButton(
            label: 'Sign In',
            loadingLabel: 'Signing In...',
            isLoading: isSubmitting,
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer',
        onClick: () => context.push('/register'),
        [
          span(classes: 'text-slate-500', [.text('New to Finch?')]),
          span(classes: 'text-blue-600 font-semibold ml-1.5 hover:underline', [
            .text('Create an account'),
          ]),
        ],
      ),
    );
  }
}
