import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class FormField extends StatelessComponent {
  final String id;
  final String labelText;
  final Component icon;
  final InputType type;
  final Map<String, String>? attributes;
  final String hintText;
  final void Function(dynamic)? onChange;
  final bool enableForgotPassword;

  const FormField({
    super.key,
    required this.id,
    required this.labelText,
    required this.icon,
    required this.type,
    required this.attributes,
    required this.hintText,
    this.onChange,
    this.enableForgotPassword = false,
  });

  @override
  Component build(BuildContext context) {
    return fieldset(classes: 'fieldset w-full mb-4', [
      div(classes: 'flex items-center justify-between', [
        label(
          htmlFor: id,
          classes: 'label text-[14px] font-semibold text-gray-500',
          [icon, .text(labelText)],
        ),
        if (enableForgotPassword)
          button(
            type: .button,
            classes: 'text-sm font-semibold text-accent hover:cursor-pointer',
            onClick: () => context.push('/forgotPassword'),
            [
              .text('Forgot Password?'),
            ],
          ),
      ]),
      input(
        id: id,
        name: id,
        type: type,
        onChange: onChange,
        classes:
            'input validator h-11 border border-gray-300 w-full rounded-lg',
        attributes: attributes,
      ),
      p(classes: 'validator-hint hidden', [.text(hintText)]),
    ]);
  }
}
