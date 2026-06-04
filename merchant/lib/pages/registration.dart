import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/providers/registration_provider.dart';
import 'package:web/web.dart' hide Lock;

class Registration extends StatelessComponent {
  const Registration({super.key});

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final fullName = context.read(fullNameProvider).trim();
    final businessName = context.read(businessNameProvider).trim();
    final whatsappNumber = context.read(whatsappNumberProvider).trim();
    final email = context.read(emailProvider).trim();
    final password = context.read(passwordProvider).trim();

    print('full name = $fullName');
    print('business name = $businessName');
    print('whatsapp number = $whatsappNumber');
    print('email = $email');
    print('password = $password');
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
  }

  @override
  Component build(BuildContext context) {
    return main_(classes: 'bg-neutral min-h-screen w-full', [
      div(
        classes:
            'max-w-120 mx-auto h-full flex flex-col justify-center items-center px-6 md:px-0 py-10',
        [
          h1(classes: 'font-script text-primary text-[40px] font-normal', [
            .text('Branding'),
          ]),

          h1(classes: 'text-center text-3xl font-bold mt-4 mb-2', [
            .text('Create Your Account'),
          ]),

          h4(classes: 'text-gray-500 text-center mb-8', [
            .text(
              'Register your business to start billing',
            ),
            br(),
            .text('and tracking sales today.'),
          ]),

          div(classes: 'card bg-white shadow-sm w-full', [
            form(
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
                    'pattern': '[0-9]{10}',
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
                  onChange: (value) => _onChange(emailProvider, context, value),
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
                      _onChange(passwordProvider, context, value),
                  attributes: {
                    'placeholder': '*********',
                    'required': '',
                    'pattern': '(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
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
          ]),
        ],
      ),
    ]);
  }
}
