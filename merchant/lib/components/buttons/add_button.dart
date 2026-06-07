import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/plus.dart';

class AddButton extends StatelessComponent {
  const AddButton({super.key, required this.name, this.onClick, this.classes});

  final String name;
  final VoidCallback? onClick;
  final String? classes;

  @override
  Component build(BuildContext context) {
    return button(
      onClick: onClick,

      classes:
          'flex hover:cursor-pointer px-4 items-center font-semibold justify-center bg-primary text-primary-content text-sm transition-all duration-300 rounded-lg h-10 $classes',
      [
        Plus(classes: 'w-4 h-4'),
        .text(name),
      ],
    );
  }
}
