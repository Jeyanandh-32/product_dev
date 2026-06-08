import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/terminals_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart';

class AddEditTerminalModal extends StatefulComponent {
  const AddEditTerminalModal({super.key, this.terminal});

  final Terminal? terminal;

  @override
  State<AddEditTerminalModal> createState() => _AddEditTerminalModalState();
}

class _AddEditTerminalModalState extends State<AddEditTerminalModal> {
  late String _name;
  late String _password;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _name = component.terminal?.name ?? '';
    _password = '';
    _isActive = component.terminal?.isActive ?? true;
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final name = _name.trim();
    final password = _password.trim();
    final isActive = _isActive;

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    if (component.terminal != null) {
      context
          .read(terminalsProvider.notifier)
          .updateTerminal(
            code: component.terminal!.code,
            name: name,
            password: password.isEmpty ? null : password,
            isActive: isActive,
          );
    } else {
      context
          .read(terminalsProvider.notifier)
          .create(name: name, password: password);
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: component.terminal != null ? 'Edit Terminal' : 'Add Terminal',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'terminalName',
            labelText: 'Terminal Name',
            type: InputType.text,
            attributes: {
              'placeholder': 'Terminal 1',
              'required': '',
              'value': _name,
            },
            hintText: 'Terminal name is required.',
            onChange: (value) => _name = value as String,
          ),

          FormField(
            id: 'password',
            labelText: component.terminal != null ? 'Password (optional)' : 'Password',
            type: InputType.password,
            attributes: {
              'placeholder': '*********',
              if (component.terminal == null) 'required': '',
              'minlength': '6',
              'pattern': ValidationPatterns.password,
              'value': _password,
            },
            hintText:
                'Must be 6+ characters with a number, lowercase, and uppercase.',
            onChange: (value) => _password = value as String,
          ),

          div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
            p(
              classes: 'text-[14px] font-semibold text-gray-500',
              [.text('Active')],
            ),
            input(
              type: InputType.checkbox,
              classes:
                  'toggle ${_isActive ? 'toggle-success' : ''} hover:cursor-pointer',
              checked: _isActive,
              events: {
                'change': (e) {
                  final target = e.target as HTMLInputElement;
                  setState(() {
                    _isActive = target.checked;
                  });
                },
              },
            ),
          ]),

          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: ButtonType.submit,
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
