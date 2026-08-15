import 'package:customer/components/store/recent_store_chip.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:models/models.dart' as m;

/// Horizontal scrollable bar of recently visited stores.
class RecentStoresSection extends StatelessComponent {
  final List<m.Store> recentStores;
  final ValueChanged<m.Store> onSelectStore;

  const RecentStoresSection({
    super.key,
    required this.recentStores,
    required this.onSelectStore,
  });

  @override
  Component build(BuildContext context) {
    if (recentStores.isEmpty) return div([]);

    return div(classes: 'flex flex-col gap-3', [
      div(classes: 'flex items-center justify-between', [
        h2(
          classes:
              'text-xs font-bold uppercase tracking-wider text-gray-400 flex items-center gap-2',
          [
            Clock(classes: 'w-4 h-4 text-gray-400'),
            .text('Recently Visited'),
          ],
        ),
      ]),
      div(
        classes:
            'flex gap-3 overflow-x-auto pb-2 scrollbar-none -mx-4 px-4 sm:mx-0 sm:px-0',
        [
          for (final store in recentStores)
            RecentStoreChip(
              store: store,
              onClick: () => onSelectStore(store),
            ),
        ],
      ),
    ]);
  }
}
