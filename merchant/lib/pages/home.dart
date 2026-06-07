import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/tabs/stores.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  void _changeIndex(BuildContext context, int index) =>
      context.read(indexProvider.notifier).state = index;

  void _changeStore(BuildContext context, String store) {
    context.read(storeProvider.notifier).state = store;
  }

  @override
  Component build(BuildContext context) {
    final index = context.watch(indexProvider);
    final store = context.watch(storeProvider);

    return div(classes: 'h-screen w-full bg-neutral flex', [
      div(
        classes:
            'hidden md:flex w-[15%] h-full bg-white border-r border-border-medium flex-col items-center',
        [
          h1(classes: 'font-script text-primary text-[40px] font-normal', [
            .text('Branding'),
          ]),

          ul(classes: 'mt-4 h-full w-full px-4 space-y-1', [
            navButton(
              name: 'Dashboard',
              icon: LayoutGrid(classes: 'w-4.5 h-4.5'),
              isSelected: index == 0,
              onClick: () => _changeIndex(context, 0),
            ),
            navButton(
              name: 'Inventory',
              icon: ShoppingCart(classes: 'w-4.5 h-4.5'),
              isSelected: index == 1,
              onClick: () => _changeIndex(context, 1),
            ),
            navButton(
              name: 'Reports',
              icon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
              isSelected: index == 2,
              onClick: () => _changeIndex(context, 2),
            ),
            navButton(
              name: 'Stores',
              icon: Store(classes: 'w-4.5 h-4.5'),
              isSelected: index == 3,
              onClick: () => _changeIndex(context, 3),
            ),
            navButton(
              name: 'Account',
              icon: UserRound(classes: 'w-4.5 h-4.5'),
              isSelected: index == 4,
              onClick: () => _changeIndex(context, 4),
            ),
            navButton(
              name: 'Settings',
              icon: Settings(classes: 'w-4.5 h-4.5'),
              isSelected: index == 5,
              onClick: () => _changeIndex(context, 5),
            ),
          ]),
        ],
      ),

      div(classes: 'w-full h-screen flex flex-col overflow-hidden', [
        div(
          classes:
              'w-full h-15 px-8 flex justify-between items-center bg-white border-b border-border-medium',
          [
            h3(classes: 'font-semibold', [.text('Dashboard')]),

            div(classes: 'dropdown dropdown-bottom dropdown-end', [
              div(
                classes:
                    'btn rounded-full border border-border-medium px-6 bg-white text-sm',
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
        ),

        switch (index) {
          // 0 => const Dashboard(),
          3 => const Stores(),
          _ => const Stores(),
        },
      ]),
    ]);
  }

  li navButton({
    required String name,
    required Component icon,
    bool isSelected = false,
    VoidCallback? onClick,
  }) {
    final isSelectedClasses = isSelected
        ? 'bg-primary text-primary-content cursor-default'
        : 'text-gray-500 hover:bg-neutral hover:cursor-pointer';

    return li([
      button(
        onClick: isSelected ? null : onClick,
        classes:
            'flex gap-2 h-10 w-full font-medium items-center rounded-lg pl-4 text-sm transition-all duration-300 $isSelectedClasses',
        [
          icon,
          .text(name),
        ],
      ),
    ]);
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
