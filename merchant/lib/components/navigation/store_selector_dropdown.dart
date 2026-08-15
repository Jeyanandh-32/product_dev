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
        classes:
            'btn rounded-full border border-border-medium px-2.5 sm:px-4 bg-white hover:bg-base-200 text-xs sm:text-sm h-8 min-h-0 flex items-center gap-1 max-w-32.5 sm:max-w-none',
        attributes: {
          'tabindex': '0',
          'role': 'button',
        },
        [
          span(classes: 'truncate max-w-21.25 sm:max-w-40', [
            .text(store.name),
          ]),
          ChevronDown(classes: 'w-3.5 h-3.5 sm:w-4 sm:h-4 shrink-0'),
        ],
      ),

      ul(
        attributes: {'tabindex': '-1'},
        classes:
            'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 w-52 p-2 shadow-sm border border-border-light',
        [
          if (stores != null)
            for (final s in stores!)
              li([
                a(
                  href: '#',
                  classes: 'rounded-md hover:bg-neutral',
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
