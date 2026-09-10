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
        classes: 'w-full flex items-center gap-3 px-3.5 sm:px-4 h-11 sm:h-12 bg-white hover:border-slate-300 rounded-xl border border-border-medium shadow-2xs transition-all cursor-text focus-within:bg-white focus-within:border-[#0B132B] focus-within:ring-1 focus-within:ring-[#0B132B]',
        [
          Search(classes: 'w-4 h-4 text-slate-400 shrink-0'),
          input(
            type: InputType.text,
            classes: 'grow w-full bg-transparent text-xs sm:text-sm text-slate-900 font-medium focus:outline-none placeholder:text-slate-400 [&::-webkit-search-cancel-button]:hidden [&::-webkit-search-decoration]:hidden',
            attributes: {
              'placeholder': 'Search store by name or slug...',
              'value': searchQuery,
            },
            onInput: (value) => onQueryChanged((value as String?) ?? ''),
          ),
          if (searchQuery.isNotEmpty)
            button(
              classes: 'btn btn-ghost btn-xs btn-circle text-slate-400 hover:text-slate-700 cursor-pointer',
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
