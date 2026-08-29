import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:models/models.dart';

/// Compact chip widget displaying a previously visited store for quick access.
class RecentStoreChip extends StatelessComponent {
  final Store store;
  final VoidCallback onClick;

  const RecentStoreChip({
    super.key,
    required this.store,
    required this.onClick,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-2xl p-3.5 min-w-50 sm:min-w-60 border border-gray-200 hover:border-black transition-all cursor-pointer flex items-center gap-3 shrink-0 group shadow-2xs',
      events: {'click': (e) => onClick()},
      [
        div(
          classes: 'w-10 h-10 rounded-xl bg-gray-100 text-black flex items-center justify-center font-bold shrink-0 group-hover:bg-black group-hover:text-white transition-colors',
          [
            icon.Store(classes: 'w-5 h-5'),
          ],
        ),
        div(classes: 'flex flex-col min-w-0', [
          h3(
            classes:
                'text-sm font-bold text-black truncate group-hover:opacity-80',
            [
              .text(store.name),
            ],
          ),
          if (store.storeType case final type? when type.isNotEmpty)
            span(
              classes: 'text-xs text-gray-400 font-medium truncate',
              [
                .text(type),
              ],
            ),
        ]),
      ],
    );
  }
}
