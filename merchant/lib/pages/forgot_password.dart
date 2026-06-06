import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/providers/field_providers.dart';
import 'package:web/web.dart' hide Lock;

class ForgotPassword extends StatelessComponent {
  const ForgotPassword({super.key});

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final email = context.read(forgotPasswordEmailProvider).trim();

    print('email = $email');
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'bg-neutral h-screen w-full', [
      div(
        classes:
            'max-w-120 mx-auto h-full flex flex-col justify-center items-center px-6 md:px-0',
        [
          h1(classes: 'font-script text-primary text-[40px] font-normal', [
            .text('Branding'),
          ]),

          h1(classes: 'text-center text-3xl font-bold mt-4 mb-2', [
            .text('Forgot Password?'),
          ]),

          h4(classes: 'text-gray-500 text-center mb-8', [
            .text(
              'Enter to your email to',
            ),
            br(),
            .text('get password reset link.'),
          ]),

          div(classes: 'card bg-white shadow-sm w-full mb-8', [
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
                  onChange: (value) =>
                      _onChange(forgotPasswordEmailProvider, context, value),
                  attributes: {
                    'placeholder': 'jacksparrow@example.com',
                    'required': '',
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
          ]),

          button(
            classes: 'text-sm hover:cursor-pointer text-accent font-semibold',
            onClick: () => context.push('/login'),
            [
              .text('Back to Sign In'),
            ],
          ),
        ],
      ),
    ]);
  }
}
