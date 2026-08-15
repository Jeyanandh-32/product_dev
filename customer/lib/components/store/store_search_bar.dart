import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;

/// Search input bar with instant clear button for store discovery.
class StoreSearchBar extends StatelessComponent {
  final String searchQuery;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;

  const StoreSearchBar({
    super.key,
    required this.searchQuery,
    required this.onQueryChanged,
    required this.onClear,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'w-full flex flex-col sm:flex-row gap-3 items-center', [
      label(
        classes:
            'w-full flex items-center gap-3 px-3.5 sm:px-4 h-11 sm:h-12 bg-gray-50 hover:bg-gray-100/90 rounded-xl border border-gray-200 shadow-2xs transition-all cursor-text focus-within:bg-white focus-within:border-black focus-within:ring-1 focus-within:ring-black',
        [
          Search(classes: 'w-4 h-4 text-gray-500 shrink-0'),
          input(
            type: InputType.text,
            classes:
                'grow w-full bg-transparent text-xs sm:text-sm text-black font-medium focus:outline-none placeholder:text-gray-400 [&::-webkit-search-cancel-button]:hidden [&::-webkit-search-decoration]:hidden',
            attributes: {
              'placeholder': 'Search store by name or slug...',
              'value': searchQuery,
            },
            onInput: (value) => onQueryChanged((value as String?) ?? ''),
          ),
          if (searchQuery.isNotEmpty)
            button(
              classes:
                  'btn btn-ghost btn-xs btn-circle text-gray-400 hover:text-black cursor-pointer',
              onClick: onClear,
              [
                X(classes: 'w-4 h-4'),
              ],
            ),
        ],
      ),
    ]);
  }
}
