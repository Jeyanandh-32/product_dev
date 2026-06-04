import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class FormField extends StatelessComponent {
  final String id;
  final String labelText;
  final Component icon;
  final InputType type;
  final Map<String, String>? attributes;
  final String hintText;
  final void Function(dynamic)? onChange;

  const FormField({
    super.key,
    required this.id,
    required this.labelText,
    required this.icon,
    required this.type,
    required this.attributes,
    required this.hintText,
    this.onChange,
  });

  @override
  Component build(BuildContext context) {
    return fieldset(classes: 'fieldset w-full mb-4', [
      label(
        htmlFor: id,
        classes: 'label text-[14px] font-semibold text-gray-500',
        [icon, .text(labelText)],
      ),
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
