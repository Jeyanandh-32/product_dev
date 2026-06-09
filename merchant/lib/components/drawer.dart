import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Drawer extends StatelessComponent {
  const Drawer({super.key, this.classes});

  final String? classes;

  void _changeIndex(BuildContext context, int index, String headerTitle) {
    context.read(headerTitleProvider.notifier).state = headerTitle;
    context.read(indexProvider.notifier).state = index;
    context.read(headerSubTitleProvider.notifier).state = null;
    _toggleDrawer(context);
  }

  void _changeSubIndex(
    BuildContext context,
    int subIndex,
    String headerTitle,
    String headerSubTitle,
  ) {
    context.read(headerTitleProvider.notifier).state = headerTitle;
    context.read(subIndexProvider.notifier).state = subIndex;
    context.read(headerSubTitleProvider.notifier).state = headerSubTitle;
    _toggleDrawer(context);
  }

  void _toggleDrawer(BuildContext context) =>
      context.read(navOpenProvider.notifier).state = !context.read(
        navOpenProvider,
      );

  @override
  Component build(BuildContext context) {
    final index = context.watch(indexProvider);
    final subIndex = context.watch(subIndexProvider);
    final isNavOpen = context.watch(navOpenProvider);

    return div(
      classes:
          'fixed z-50 ${isNavOpen ? 'left-0' : '-left-full'} transition-all duration-300 lg:left-0 flex w-64 h-full bg-white border-r border-border-medium flex-col items-center $classes',
      [
        h1(
          classes:
              'font-script text-primary w-full text-center text-[40px] font-normal',
          [
            .text('Branding'),
          ],
        ),

        ul(classes: 'mt-4 flex-1 w-full px-4 space-y-1', [
          navButton(
            name: 'Dashboard',
            prefixIcon: LayoutGrid(classes: 'w-4.5 h-4.5'),
            isSelected: index == 0,
            onClick: () => _changeIndex(context, 0, 'Dashboard'),
          ),
          navButton(
            name: 'Inventory',
            prefixIcon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            suffixIcon: index == 1
                ? ChevronDown(classes: 'w-4.5 h-4.5 ml-auto mr-6')
                : ChevronRight(classes: 'w-4.5 h-4.5 ml-auto mr-6'),
            isSelected: index == 1,
            onClick: () {
              _changeIndex(context, 1, 'Inventory');
              context.read(subIndexProvider.notifier).state = 0;
              context.read(headerSubTitleProvider.notifier).state = 'Products';
            },
          ),
          if (index == 1)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Products',
                  isSelected: index == 1 && subIndex == 0,
                  onClick: () =>
                      _changeSubIndex(context, 0, 'Inventory', 'Products'),
                ),
                navSubButton(
                  name: 'Category',
                  isSelected: index == 1 && subIndex == 1,
                  onClick: () =>
                      _changeSubIndex(context, 1, 'Inventory', 'Category'),
                ),
                navSubButton(
                  name: 'Counters',
                  isSelected: index == 1 && subIndex == 2,
                  onClick: () =>
                      _changeSubIndex(context, 2, 'Inventory', 'Counters'),
                ),
              ],
            ),
          navButton(
            name: 'Reports',
            prefixIcon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
            suffixIcon: index == 2
                ? ChevronDown(classes: 'w-4.5 h-4.5 ml-auto mr-6')
                : ChevronRight(classes: 'w-4.5 h-4.5 ml-auto mr-6'),
            isSelected: index == 2,
            onClick: () {
              _changeIndex(context, 2, 'Reports');
              context.read(subIndexProvider.notifier).state = 0;
              context.read(headerSubTitleProvider.notifier).state = 'Orders';
            },
          ),
          if (index == 2)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Orders',
                  isSelected: index == 2 && subIndex == 0,
                  onClick: () =>
                      _changeSubIndex(context, 0, 'Reports', 'Orders'),
                ),
                navSubButton(
                  name: 'Payments',
                  isSelected: index == 2 && subIndex == 1,
                  onClick: () =>
                      _changeSubIndex(context, 1, 'Reports', 'Payments'),
                ),
                navSubButton(
                  name: 'Credits',
                  isSelected: index == 2 && subIndex == 2,
                  onClick: () =>
                      _changeSubIndex(context, 2, 'Reports', 'Credits'),
                ),
                navSubButton(
                  name: 'Profit & Loss',
                  isSelected: index == 2 && subIndex == 3,
                  onClick: () =>
                      _changeSubIndex(context, 3, 'Reports', 'Profit & Loss'),
                ),
                navSubButton(
                  name: 'Stock Summary',
                  isSelected: index == 2 && subIndex == 4,
                  onClick: () =>
                      _changeSubIndex(context, 4, 'Reports', 'Stock Summary'),
                ),
              ],
            ),
          navButton(
            name: 'Stores',
            prefixIcon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: index == 3,
            onClick: () => _changeIndex(context, 3, 'Stores'),
          ),
          navButton(
            name: 'Account',
            prefixIcon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: index == 4,
            onClick: () => _changeIndex(context, 4, 'Account'),
          ),
          navButton(
            name: 'Settings',
            prefixIcon: Settings(classes: 'w-4.5 h-4.5'),
            isSelected: index == 5,
            onClick: () => _changeIndex(context, 5, 'Settings'),
          ),
        ]),
        div(classes: 'w-full px-4 pb-4 mt-auto', [
          button(
            classes:
                'flex items-center justify-center gap-2 w-full h-10 font-semibold text-sm bg-soft-red text-soft-red-content rounded-lg hover:cursor-pointer',
            onClick: () => context.read(authProvider.notifier).logout(),
            [LogOut(classes: 'w-4.5 h-4.5'), .text('Log Out')],
          ),
        ]),
      ],
    );
  }

  li navSubButton({
    required String name,
    bool isSelected = false,
    VoidCallback? onClick,
  }) {
    return li(classes: 'w-full', [
      button(
        onClick: isSelected ? null : onClick,
        classes:
            'text-sm ${isSelected ? 'text-primary' : 'text-gray-500'} font-semibold hover:cursor-pointer hover:bg-neutral rounded-lg h-8 w-full flex items-center',
        [
          Dot(classes: 'w-8 h-8'),
          .text(name),
        ],
      ),
    ]);
  }

  li navButton({
    required String name,
    required Component prefixIcon,
    Component? suffixIcon,
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
          prefixIcon,
          .text(name),
          ?suffixIcon,
        ],
      ),
    ]);
  }
}
