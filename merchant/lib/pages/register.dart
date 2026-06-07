import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:merchant/providers/field_providers.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Register extends StatelessComponent {
  const Register({super.key});

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final fullName = context.read(fullNameProvider).trim();
    final businessName = context.read(businessNameProvider).trim();
    final whatsappNumber = context.read(whatsappNumberProvider).trim();
    final email = context.read(registerEmailProvider).trim();
    final password = context.read(registerPasswordProvider).trim();

    print('full name = $fullName');
    print('business name = $businessName');
    print('whatsapp number = $whatsappNumber');
    print('email = $email');
    print('password = $password');

    context
        .read(authProvider.notifier)
        .register(
          name: fullName,
          businessName: businessName,
          whatsappNumber: whatsappNumber,
          email: email,
          password: password,
        );
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
  }

  @override
  Component build(BuildContext context) {
    return AuthLayout(
      title: 'Create Your Account',
      descriptionLine1: 'Register your business to start billing',
      descriptionLine2: 'and tracking sales today.',
      isMinHeight: true,
      formContent: form(
        classes: 'card-body items-start',
        method: .post,
        events: {
          'submit': (e) => _onSubmit(context, e),
        },
        [
          FormField(
            onChange: (value) =>
                _onChange(fullNameProvider, context, value),
            id: 'fullname',
            labelText: 'Full Name',
            icon: User(classes: 'w-4.5 h-4.5'),
            type: .text,
            attributes: {'placeholder': 'Jack Dev', 'required': ''},
            hintText: 'Name is required.',
          ),

          FormField(
            id: 'businessName',
            labelText: 'Business Name',
            icon: Building(classes: 'w-4.5 h-4.5'),
            type: .text,
            onChange: (value) =>
                _onChange(businessNameProvider, context, value),
            attributes: {
              'placeholder': 'Acme Retail Solutions',
              'required': '',
            },
            hintText: 'Business Name is required.',
          ),

          FormField(
            id: 'whatsappNumber',
            labelText: 'Whatsapp Number',
            icon: Phone(classes: 'w-4.5 h-4.5'),
            type: .tel,
            onChange: (value) =>
                _onChange(whatsappNumberProvider, context, value),
            attributes: {
              'placeholder': '7449261057',
              'required': '',
              'pattern': ValidationPatterns.whatsappHtml,
              'minlength': '10',
              'maxlength': '10',
              'title': 'Must be 10 digits',
            },
            hintText: 'Must be 10 digits.',
          ),

          FormField(
            id: 'email',
            labelText: 'Email',
            icon: Mail(classes: 'w-4.5 h-4.5'),
            type: .email,
            onChange: (value) =>
                _onChange(registerEmailProvider, context, value),
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
            onChange: (value) =>
                _onChange(registerPasswordProvider, context, value),
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
