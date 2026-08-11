import 'package:customer/components/fields/form_field.dart';
import 'package:customer/components/layouts/auth_layout.dart';
import 'package:customer/components/signal_component.dart';
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
  }

  @override
  Component buildSignal(BuildContext context) {
    return AuthLayout(
      title: 'Create Your Account',
      descriptionLine1: 'Register to start ordering',
      descriptionLine2: '',
      formContent: form(
        classes: 'card-body items-start',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(e),
        },
        [
          FormField(
            onChange: (value) => _fullName = value as String,
            id: 'fullname',
            labelText: 'Full Name',
            icon: User(classes: 'w-4.5 h-4.5'),
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
            labelText: 'Whatsapp Number',
            icon: Phone(classes: 'w-4.5 h-4.5'),
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
            labelText: '6-Digit Security PIN',
            icon: Lock(classes: 'w-4.5 h-4.5'),
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
            classes:
                'btn btn-primary mt-3 rounded-lg h-12 w-full flex items-center justify-center font-semibold text-base cursor-pointer',
            type: .submit,
            [
              .text('Register'),
            ],
          ),

          span(classes: 'text-gray-500 text-center px-8 md:px-16 mt-6', [
            .text(
              'By clicking "Register", you agree to our Terms of Service and Privacy Policy.',
            ),
          ]),
        ],
      ),
      footerContent: button(
        classes: 'text-sm hover:cursor-pointer',
        onClick: () => context.push('/login'),
        [
          span([.text('Already have an account?')]),
          span(classes: 'text-accent font-semibold ml-1', [
            .text('Sign in to Brand'),
          ]),
        ],
      ),
    );
  }
}
