import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map;

/// Search input bar for store menu items.
class StoreProductSearchBar extends StatelessComponent {
  final String searchQuery;
  final ValueChanged<String> onQueryChanged;

  const StoreProductSearchBar({
    super.key,
    required this.searchQuery,
    required this.onQueryChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'w-full', [
      label(
        classes:
            'w-full flex items-center gap-3 px-4 h-12 bg-gray-50 hover:bg-gray-100/90 rounded-xl border border-gray-200 shadow-2xs transition-all cursor-text focus-within:bg-white focus-within:border-black focus-within:ring-1 focus-within:ring-black',
        [
          Search(classes: 'w-4 h-4 text-gray-500 shrink-0'),
          input(
            type: InputType.text,
            classes:
                'grow w-full bg-transparent text-sm text-black font-medium focus:outline-none placeholder:text-gray-400 [&::-webkit-search-cancel-button]:hidden [&::-webkit-search-decoration]:hidden',
            attributes: {
              'placeholder': 'Search menu products...',
              'value': searchQuery,
            },
            onInput: (value) => onQueryChanged((value as String?) ?? ''),
          ),
          if (searchQuery.isNotEmpty)
            button(
              classes:
                  'btn btn-ghost btn-xs btn-circle text-gray-400 hover:text-black cursor-pointer',
              onClick: () => onQueryChanged(''),
              [
                X(classes: 'w-4 h-4'),
              ],
            ),
        ],
      ),
    ]);
  }
}
