import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/search.dart';

class Searchbar extends StatelessComponent {
  const Searchbar({
    super.key,
    required this.placeholder,
    this.classes,
    this.onInput,
  });

  final String placeholder;
  final String? classes;
  final ValueChanged<String>? onInput;

  @override
  Component build(BuildContext context) {
    return label(
      classes:
          'input w-full ${classes ?? 'flex-2'} h-10 border border-border-medium bg-white rounded-xl px-3.5 text-sm text-slate-900 shadow-2xs flex items-center',
      [
        Search(classes: 'w-4 h-4 text-slate-400 shrink-0 mr-2.5'),

        input(
          type: .search,
          classes: 'grow outline-none border-none text-sm text-slate-900 placeholder:text-slate-400 w-full',
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
