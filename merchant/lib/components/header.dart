import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Store;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  void _changeStore(BuildContext context, Store store) {
    context.read(storeProvider.notifier).state = store;
    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  @override
  Component build(BuildContext context) {
    final store = context.watch(storeProvider);
    final isNavOpen = context.watch(navOpenProvider);
    final headerTitle = context.watch(headerTitleProvider);
    final headerSubTitle = context.watch(headerSubTitleProvider);
    final stores = context.watch(storesProvider).value;

    if (stores != null && stores.isNotEmpty) {
      if (store == null || !stores.any((st) => st.id == store.id)) {
        Future.microtask(() {
          context.read(storeProvider.notifier).state = stores.first;
        });
      }
    }

    return div(
      classes:
          'w-full h-15 px-4 lg:px-8 flex justify-between items-center bg-white border-b border-border-medium',
      [
        div(classes: 'flex items-center gap-3 lg:gap-0', [
          button(
            classes:
                'block lg:hidden hover:cursor-pointer transition-all duration-300',
            onClick: () =>
                context.read(navOpenProvider.notifier).state = !isNavOpen,
            [
              Menu(classes: 'w-5 h-5'),
            ],
          ),

          h3(classes: 'font-semibold flex items-center gap-1.5 text-primary', [
            .text(headerTitle),
            if (headerSubTitle != null) ...[
              span(classes: 'text-gray-300 text-sm font-normal', [.text('/')]),
              span(classes: 'text-sm text-gray-400 font-normal', [
                .text(headerSubTitle),
              ]),
            ],
          ]),
        ]),

        if (store != null)
          div(classes: 'dropdown dropdown-bottom dropdown-end', [
            div(
              classes:
                  'btn rounded-full border border-border-medium px-4 bg-white hover:bg-base-200 text-sm h-8 min-h-0',
              attributes: {
                'tabindex': '0',
                'role': 'button',
              },
              [
                .text(store.name),
                ChevronDown(classes: 'w-4 h-4'),
              ],
            ),

            ul(
              attributes: {'tabindex': '-1'},
              classes:
                  'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 w-52 p-2 shadow-sm border border-border-light',
              [
                if (stores != null)
                  for (final s in stores)
                    dropdownButton(
                      name: s.name,
                      onClick: () => _changeStore(context, s),
                    ),
              ],
            ),
          ]),
      ],
    );
  }

  li dropdownButton({
    required String name,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes: 'rounded-md hover:bg-neutral',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
