import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/auth/auth_submit_button.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:web/web.dart' hide Lock;

class ForgotPassword extends StatefulComponent {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email = '';

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final email = _email.trim();

    print('email = $email');
  }

  @override
  Component build(BuildContext context) {
    return AuthLayout(
      title: 'Forgot Password?',
      descriptionLine1: 'Enter your email to receive a',
      descriptionLine2: 'password reset link.',
      formContent: form(
        classes: 'w-full flex flex-col',
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

          AuthSubmitButton(
            label: 'Send Reset Link',
            loadingLabel: 'Sending Link...',
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer text-blue-600 font-semibold hover:underline',
        onClick: () => context.push('/login'),
        [
          .text('Back to Sign In'),
        ],
      ),
    );
  }
}
