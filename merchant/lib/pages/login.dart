import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/providers/login_provider.dart';
import 'package:web/web.dart' hide Lock;

class Login extends StatelessComponent {
  const Login({super.key});

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final email = context.read(emailProvider).trim();
    final password = context.read(passwordProvider).trim();

    print('email = $email');
    print('password = $password');
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
  }

  @override
  Component build(BuildContext context) {
    return main_(classes: 'bg-neutral h-screen w-full', [
      div(
        classes:
            'max-w-120 mx-auto h-full flex flex-col justify-center items-center px-6 md:px-0',
        [
          h1(classes: 'font-script text-primary text-[40px] font-normal', [
            .text('Branding'),
          ]),

          h1(classes: 'text-center text-3xl font-bold mt-4 mb-2', [
            .text('Sign in to your account'),
          ]),

          h4(classes: 'text-gray-500 text-center mb-8', [
            .text(
              'Enter to your credentials to access',
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
                    .text('Sign In'),
                  ],
                ),
              ],
            ),
          ]),
        ],
      ),
    ]);
  }
}
