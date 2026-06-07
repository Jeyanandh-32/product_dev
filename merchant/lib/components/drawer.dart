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
    _toggleDrawer(context);
  }

  void _toggleDrawer(BuildContext context) =>
      context.read(navOpenProvider.notifier).state = !context.read(
        navOpenProvider,
      );

  @override
  Component build(BuildContext context) {
    final index = context.watch(indexProvider);
    final isNavOpen = context.watch(navOpenProvider);

    return div(
      classes:
          'fixed z-50 ${isNavOpen ? 'left-0' : '-left-100'} transition-all duration-300 md:left-0 flex w-[60%] sm:w-[30%] md:w-[15%] h-full bg-white border-r border-border-medium flex-col items-center $classes',
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
            icon: LayoutGrid(classes: 'w-4.5 h-4.5'),
            isSelected: index == 0,
            onClick: () => _changeIndex(context, 0, 'Dashboard'),
          ),
          navButton(
            name: 'Inventory',
            icon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            isSelected: index == 1,
            onClick: () => _changeIndex(context, 1, 'Inventory'),
          ),
          navButton(
            name: 'Reports',
            icon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
            isSelected: index == 2,
            onClick: () => _changeIndex(context, 2, 'Reports'),
          ),
          navButton(
            name: 'Stores',
            icon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: index == 3,
            onClick: () => _changeIndex(context, 3, 'Stores'),
          ),
          navButton(
            name: 'Account',
            icon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: index == 4,
            onClick: () => _changeIndex(context, 4, 'Account'),
          ),
          navButton(
            name: 'Settings',
            icon: Settings(classes: 'w-4.5 h-4.5'),
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
}
