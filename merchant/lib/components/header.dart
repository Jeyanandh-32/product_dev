import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/ui_providers.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  void _changeStore(BuildContext context, String store) {
    context.read(storeProvider.notifier).state = store;
  }

  @override
  Component build(BuildContext context) {
    final store = context.watch(storeProvider);
    final isNavOpen = context.watch(navOpenProvider);
    final headerTitle = context.watch(headerTitleProvider);

    return div(
      classes:
          'w-full h-15 px-4 md:px-8 flex justify-between items-center bg-white border-b border-border-medium',
      [
        div(classes: 'flex items-center gap-3 md:gap-0', [
          button(
            classes:
                'block md:hidden hover:cursor-pointer transition-all duration-300',
            onClick: () =>
                context.read(navOpenProvider.notifier).state = !isNavOpen,
            [
              Menu(classes: 'w-5 h-5'),
            ],
          ),

          h3(classes: 'font-semibold', [.text(headerTitle)]),
        ]),

        div(classes: 'dropdown dropdown-bottom dropdown-end', [
          div(
            classes:
                'btn rounded-full border border-border-medium px-4 bg-white hover:bg-base-200 text-sm h-8 min-h-0',
            attributes: {
              'tabindex': '0',
              'role': 'button',
            },
            [
              .text(store),
              ChevronDown(classes: 'w-4 h-4'),
            ],
          ),

          ul(
            attributes: {'tabindex': '-1'},
            classes:
                'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 w-52 p-2 shadow-sm border border-border-light',
            [
              dropdownButton(
                name: 'STORE - 1',
                onClick: () => _changeStore(context, 'STORE - 1'),
              ),

              dropdownButton(
                name: 'STORE - 2',
                onClick: () => _changeStore(context, 'STORE - 2'),
              ),

              dropdownButton(
                name: 'STORE - 3',
                onClick: () => _changeStore(context, 'STORE - 3'),
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
        classes: 'rounded-md',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
