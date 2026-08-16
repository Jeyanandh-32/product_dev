import 'package:customer/components/fields/form_field.dart';
import 'package:customer/components/layouts/auth_layout.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class LoginPage extends SignalComponent {
  const LoginPage({super.key});

  @override
  SignalState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends SignalState<LoginPage> {
  String _mobileNumber = '';
  String _pin = '';

  void _onSubmit(Event e) {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final mobileNumber = _mobileNumber.trim();
    final pin = _pin.trim();

    loginCustomer(
      mobileNumber: mobileNumber,
      pin: pin,
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final isSubmitting = customerAuthSubmittingSignal.value;

    return AuthLayout(
      title: 'Sign in to your account',
      descriptionLine1: 'Enter your 10-digit mobile number and',
      descriptionLine2: '6-digit security PIN to access your orders.',
      formContent: form(
        classes: 'w-full flex flex-col items-start',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(e),
        },
        [
          FormField(
            id: 'mobileNumber',
            labelText: 'Mobile Number',
            icon: Phone(classes: 'w-4 h-4 text-gray-500'),
            type: .tel,
            onChange: (value) => _mobileNumber = value as String,
            attributes: {
              'placeholder': '7449261057',
              'required': '',
              'pattern': ValidationPatterns.whatsappHtml,
              'minlength': '10',
              'maxlength': '10',
              'title': 'Must be 10 digits',
              'value': _mobileNumber,
            },
            hintText: 'Must be 10 digits.',
          ),

          FormField(
            id: 'pin',
            labelText: '6-Digit Security PIN',
            icon: Lock(classes: 'w-4 h-4 text-gray-500'),
            type: .password,
            onChange: (value) => setState(() => _pin = value as String),
            attributes: {
              'placeholder': '••••••',
              'required': '',
              'inputmode': 'numeric',
              'pattern': '[0-9]*',
              'minlength': '6',
              'maxlength': '6',
              'value': _pin,
            },
            hintText: 'Must be a 6-digit numeric PIN.',
          ),

          button(
            classes:
                'w-full h-12 mt-2 rounded-xl bg-black hover:bg-gray-800 text-white font-extrabold text-sm flex items-center justify-center gap-2.5 transition-all cursor-pointer shadow-2xs active:scale-98 disabled:bg-black disabled:text-white disabled:opacity-85 disabled:cursor-not-allowed border-0',
            type: .submit,
            disabled: isSubmitting,
            [
              if (isSubmitting) ...[
                span(classes: 'loading loading-spinner loading-xs text-white', []),
                span(classes: 'text-sm font-bold text-white', [.text('Signing In...')]),
              ] else
                .text('Sign In'),
            ],
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-xs font-semibold text-gray-500 hover:text-black cursor-pointer border-0 bg-transparent p-0',
        onClick: () => context.push('/register'),
        [
          span([.text("Don't have an account?")]),
          span(classes: 'text-black font-extrabold underline ml-1', [
            .text('Register now'),
          ]),
        ],
      ),
    );
  }
}
