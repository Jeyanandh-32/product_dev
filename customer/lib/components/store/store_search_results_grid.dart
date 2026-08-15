import 'package:customer/components/store/store_search_row.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:models/models.dart' as m;

/// Grid displaying online stores filtered by name, slug, and category keywords.
class StoreSearchResultsGrid extends StatelessComponent {
  final List<m.Store> stores;
  final String searchQuery;
  final ValueChanged<m.Store> onSelectStore;

  const StoreSearchResultsGrid({
    super.key,
    required this.stores,
    required this.searchQuery,
    required this.onSelectStore,
  });

  @override
  Component build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final filtered = stores.where((store) {
      if (query.isEmpty) return true;
      return store.name.toLowerCase().contains(query) ||
          (store.slug?.toLowerCase().contains(query) ?? false) ||
          (store.storeType?.toLowerCase().contains(query) ?? false);
    }).toList();

    if (filtered.isEmpty) {
      return div(
        classes:
            'p-12 sm:p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center gap-3',
        [
          SearchX(classes: 'w-10 h-10 text-gray-300'),
          .text(
            query.isEmpty
                ? 'No online stores available currently.'
                : 'No online stores match your search query.',
          ),
        ],
      );
    }

    return div(
      classes: 'grid grid-cols-1 md:grid-cols-1 lg:grid-cols-2 gap-4 w-full',
      [
        for (final store in filtered)
          StoreSearchRow(
            store: store,
            onOpen: () => onSelectStore(store),
          ),
      ],
    );
  }
}
