import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/search.dart';

class Searchbar extends StatelessComponent {
  const Searchbar({super.key, required this.placeholder, this.classes, this.onInput});

  final String placeholder;
  final String? classes;
  final ValueChanged<String>? onInput;

  @override
  Component build(BuildContext context) {
    return label(
      classes:
          'input ${classes ?? 'flex-2'} ring ring-inset ring-border-light rounded-lg',
      [
        Search(classes: 'h-[1em] opacity-50'),

        input(
          type: .search,
          classes: 'grow',
          attributes: {
            'required': '',
            'placeholder': placeholder,
          },
          onInput: onInput,
        ),
      ],
    );
  }
}
