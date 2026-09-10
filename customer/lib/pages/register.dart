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

class RegisterPage extends SignalComponent {
  const RegisterPage({super.key});

  @override
  SignalState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends SignalState<RegisterPage> {
  String _fullName = '';
  String _whatsappNumber = '';
  String _password = '';

  void _onSubmit(Event e) {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final fullName = _fullName.trim();
    final whatsappNumber = _whatsappNumber.trim();
    final password = _password.trim();

    registerCustomer(
      name: fullName,
      mobileNumber: whatsappNumber,
      pin: password,
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final isSubmitting = customerAuthSubmittingSignal.value;

    return AuthLayout(
      formContent: form(
        classes: 'w-full flex flex-col',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(e),
        },
        [
          FormField(
            onChange: (value) => _fullName = value as String,
            id: 'fullname',
            labelText: 'Full Name',
            icon: User(classes: 'w-4.5 h-4.5 text-slate-500'),
            type: .text,
            attributes: {
              'placeholder': 'Jack Dev',
              'required': '',
              'value': _fullName,
            },
            hintText: 'Name is required.',
          ),

          FormField(
            id: 'whatsappNumber',
            labelText: 'Mobile Number',
            icon: Phone(classes: 'w-4.5 h-4.5 text-slate-500'),
            type: .tel,
            onChange: (value) => _whatsappNumber = value as String,
            attributes: {
              'placeholder': '7449261057',
              'required': '',
              'pattern': ValidationPatterns.whatsappHtml,
              'minlength': '10',
              'maxlength': '10',
              'title': 'Must be 10 digits',
              'value': _whatsappNumber,
            },
            hintText: 'Must be 10 digits.',
          ),

          FormField(
            id: 'password',
            labelText: 'Security PIN',
            icon: Lock(classes: 'w-4.5 h-4.5 text-slate-500'),
            type: .password,
            onChange: (value) => setState(() => _password = value as String),
            attributes: {
              'placeholder': '••••••',
              'required': '',
              'inputmode': 'numeric',
              'pattern': '[0-9]*',
              'minlength': '6',
              'maxlength': '6',
              'value': _password,
            },
            hintText: 'Must be a 6-digit numeric PIN.',
          ),

          button(
            classes: 'w-full h-12 mt-2 rounded-2xl bg-[#0B132B] hover:bg-[#1C2541] text-white font-extrabold text-sm flex items-center justify-center gap-2.5 transition-all cursor-pointer shadow-[0_4px_14px_rgba(11,19,43,0.22)] active:scale-98 disabled:bg-[#0B132B] disabled:text-white disabled:opacity-85 disabled:cursor-not-allowed border-0',
            type: .submit,
            disabled: isSubmitting,
            [
              if (isSubmitting) ...[
                span(
                  classes: 'loading loading-spinner loading-xs text-white',
                  [],
                ),
                span(classes: 'text-sm font-bold text-white', [
                  .text('Registering...'),
                ]),
              ] else
                .text('Register'),
            ],
          ),
        ],
      ),
      footerContent: div(classes: 'flex items-center gap-1.5 justify-center', [
        span(
          classes: 'text-sm text-slate-500',
          [.text('Already have an account?')],
        ),
        button(
          type: .button,
          classes: 'text-sm font-semibold text-blue-600 hover:underline hover:cursor-pointer border-0 bg-transparent p-0',
          onClick: () => context.push('/login'),
          [.text('Sign In')],
        ),
      ]),
    );
  }
}
