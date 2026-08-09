import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Register extends StatefulComponent {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _fullName = '';
  String _businessName = '';
  String _whatsappNumber = '';
  String _email = '';
  String _password = '';

  void _onSubmit(Event e) {
    e.preventDefault();
    final fullName = _fullName.trim();
    final businessName = _businessName.trim();
    final whatsappNumber = _whatsappNumber.trim();
    final email = _email.trim();
    final password = _password.trim();

    registerMerchant(
      name: fullName,
      businessName: businessName,
      whatsappNumber: whatsappNumber,
      email: email,
      password: password,
    );
  }

  @override
  Component build(BuildContext context) {
    return AuthLayout(
      title: 'Create Your Account',
      descriptionLine1: 'Register your business to start billing',
      descriptionLine2: 'and tracking sales today.',
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
            id: 'businessName',
            labelText: 'Business Name',
            icon: Building(classes: 'w-4.5 h-4.5'),
            type: .text,
            onChange: (value) => _businessName = value as String,
            attributes: {
              'placeholder': 'Acme Retail Solutions',
              'required': '',
              'value': _businessName,
            },
            hintText: 'Business Name is required.',
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
            onChange: (value) => setState(() => _password = value as String),

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
              .text('Register'),
            ],
          ),

          span(classes: 'text-gray-500 text-center px-8  md:px-16 mt-6', [
            .text(
              'By clicking "Register Business", you agree to our Terms of Service and Privacy Policy.',
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
