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
          'btn btn-primary shadow-xs flex px-4 items-center font-bold justify-center text-sm rounded-xl h-10 whitespace-nowrap shrink-0 cursor-pointer transition-all hover:scale-[1.01] active:scale-[0.98] $classes',
      [
        Plus(classes: 'w-4 h-4'),
        .text(name),
      ],
    );
  }
}
