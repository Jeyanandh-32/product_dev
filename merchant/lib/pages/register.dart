import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/auth/auth_submit_button.dart';
import 'package:merchant/components/auth/register_form_inputs.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:web/web.dart' hide Lock;

/// Registration page for onboarding new merchants to Finch POS.
class Register extends SignalComponent {
  const Register({super.key});

  @override
  SignalState<Register> createState() => _RegisterState();
}

class _RegisterState extends SignalState<Register> {
  String _fullName = '';
  String _businessName = '';
  String _whatsappNumber = '';
  String _email = '';
  String _password = '';

  void _onSubmit(Event e) {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    registerMerchant(
      name: _fullName.trim(),
      businessName: _businessName.trim(),
      whatsappNumber: _whatsappNumber.trim(),
      email: _email.trim(),
      password: _password.trim(),
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final isSubmitting = authSubmittingSignal.value;

    return AuthLayout(
      formContent: form(
        classes: 'w-full flex flex-col',
        method: .post,
        events: {'submit': _onSubmit},
        [
          RegisterFormInputs(
            fullName: _fullName,
            businessName: _businessName,
            whatsappNumber: _whatsappNumber,
            email: _email,
            password: _password,
            onFullNameChanged: (v) => _fullName = v,
            onBusinessNameChanged: (v) => _businessName = v,
            onWhatsappNumberChanged: (v) => _whatsappNumber = v,
            onEmailChanged: (v) => _email = v,
            onPasswordChanged: (v) => setState(() => _password = v),
          ),
          AuthSubmitButton(
            label: 'Create Account',
            loadingLabel: 'Creating Account...',
            isLoading: isSubmitting,
          ),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer',
        onClick: () => context.push('/login'),
        [
          span(classes: 'text-slate-500', [.text('Already have an account?')]),
          span(classes: 'text-blue-600 font-semibold ml-1.5 hover:underline', [
            .text('Sign in to Finch'),
          ]),
        ],
      ),
    );
  }
}
