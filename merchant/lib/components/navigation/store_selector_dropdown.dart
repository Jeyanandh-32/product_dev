import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:models/models.dart';

/// Dropdown selector widget allowing merchant to switch active working store.
class StoreSelectorDropdown extends StatelessComponent {
  final Store store;
  final List<Store>? stores;
  final ValueChanged<Store> onSelectStore;

  const StoreSelectorDropdown({
    super.key,
    required this.store,
    required this.stores,
    required this.onSelectStore,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'dropdown dropdown-bottom dropdown-end shrink-0', [
      div(
        classes: 'btn rounded-full border border-border-medium px-3.5 sm:px-4 bg-white hover:bg-slate-50 text-xs sm:text-sm font-bold text-slate-900 h-9 min-h-0 flex items-center gap-1.5 shadow-2xs transition-all max-w-36 sm:max-w-none cursor-pointer',
        attributes: {
          'tabindex': '0',
          'role': 'button',
        },
        [
          span(classes: 'truncate max-w-24 sm:max-w-44', [
            .text(store.name),
          ]),
          ChevronDown(classes: 'w-3.5 h-3.5 text-slate-500 shrink-0'),
        ],
      ),

      ul(
        attributes: {'tabindex': '-1'},
        classes: 'dropdown-content menu bg-white rounded-2xl z-20 mt-2 w-52 p-1.5 shadow-lg border border-border-medium space-y-0.5',
        [
          if (stores case final storeList?)
            for (final s in storeList)
              li([
                a(
                  href: '#',
                  classes: 'rounded-xl hover:bg-slate-100/80 font-medium text-slate-800 py-2 px-3 text-xs sm:text-sm transition-colors',
                  onClick: () => onSelectStore(s),
                  [
                    .text(s.name),
                  ],
                ),
              ]),
        ],
      ),
    ]);
  }
}
