import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart';

class AddTerminalModal extends StatelessComponent {
  void _onSubmit(BuildContext context, Event e) {
    context.read(activeModalProvider.notifier).state = .none;
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Add Terminal',
      child: form(
        method: .post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'terminalName',
            labelText: 'Terminal Name',
            type: .text,
            attributes: {'placeholder': 'Terminal 1', 'required': ''},
            hintText: 'Terminal name is required.',
          ),

          FormField(
            id: 'password',
            labelText: 'Password',
            type: .password,
            attributes: {
              'placeholder': '*********',
              'required': '',
              'minlength': '6',
              'pattern': ValidationPatterns.password,
            },
            hintText:
                'Must be 6+ characters with a number, lowercase, and uppercase.',
          ),

          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: .submit,
              classes:
                  'bg-primary text-primary-content px-6 h-10 rounded-lg hover:cursor-pointer hover:bg-opacity-80 transition-all duration-300',
              [
                .text('Save'),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
