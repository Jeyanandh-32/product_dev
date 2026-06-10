import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/components/fields/form_field.dart';
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
      descriptionLine1: 'Enter to your email to',
      descriptionLine2: 'get password reset link.',
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

          button(
            classes: 'btn btn-primary mt-3 rounded-lg h-12 w-full',
            type: .submit,
            [
              .text('Get link'),
            ],
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer text-accent font-semibold',
        onClick: () => context.push('/login'),
        [
          .text('Back to Sign In'),
        ],
      ),
    );
  }
}
