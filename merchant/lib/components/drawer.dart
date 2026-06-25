import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Router;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/providers/auth_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Drawer extends StatelessComponent {
  const Drawer({super.key, this.classes});

  final String? classes;

  void _navigate(BuildContext context, String path, {bool toggle = true}) {
    Router.of(context).push(path);
    if (toggle) {
      context.read(navOpenProvider.notifier).state = false;
    }
  }

  @override
  Component build(BuildContext context) {
    final isNavOpen = context.watch(navOpenProvider);
    final path = RouteState.maybeOf(context)?.path ?? '/';

    final isDashboard = path == '/';
    final isInventory = path.startsWith('/inventory');
    final isReports = path.startsWith('/reports');
    final isStores = path.startsWith('/stores');
    final isAccount = path.startsWith('/account');
    final isSettings = path.startsWith('/settings');

    final isCategory = path == '/inventory/categories';
    final isCounters = path == '/inventory/counters';
    final isProducts = isInventory && !isCategory && !isCounters;

    final isPayments = path == '/reports/payments';
    final isCredits = path == '/reports/credits';
    final isProfitLoss = path == '/reports/profit-loss';
    final isStockSummary = path == '/reports/stock-summary';
    final isOrders = isReports &&
        !isPayments &&
        !isCredits &&
        !isProfitLoss &&
        !isStockSummary;

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
            isSelected: isDashboard,
            onClick: () => _navigate(context, '/'),
          ),
          navButton(
            name: 'Inventory',
            prefixIcon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            suffixIcon: isInventory
                ? ChevronDown(classes: 'w-4.5 h-4.5 ml-auto mr-6')
                : ChevronRight(classes: 'w-4.5 h-4.5 ml-auto mr-6'),
            isSelected: isInventory,
            onClick: () => _navigate(context, '/inventory/products', toggle: false),
          ),
          if (isInventory)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Products',
                  isSelected: isProducts,
                  onClick: () => _navigate(context, '/inventory/products'),
                ),
                navSubButton(
                  name: 'Category',
                  isSelected: isCategory,
                  onClick: () => _navigate(context, '/inventory/categories'),
                ),
                navSubButton(
                  name: 'Counters',
                  isSelected: isCounters,
                  onClick: () => _navigate(context, '/inventory/counters'),
                ),
              ],
            ),
          navButton(
            name: 'Reports',
            prefixIcon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
            suffixIcon: isReports
                ? ChevronDown(classes: 'w-4.5 h-4.5 ml-auto mr-6')
                : ChevronRight(classes: 'w-4.5 h-4.5 ml-auto mr-6'),
            isSelected: isReports,
            onClick: () => _navigate(context, '/reports/orders', toggle: false),
          ),
          if (isReports)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Orders',
                  isSelected: isOrders,
                  onClick: () => _navigate(context, '/reports/orders'),
                ),
                navSubButton(
                  name: 'Payments',
                  isSelected: isPayments,
                  onClick: () => _navigate(context, '/reports/payments'),
                ),
                navSubButton(
                  name: 'Credits',
                  isSelected: isCredits,
                  onClick: () => _navigate(context, '/reports/credits'),
                ),
                navSubButton(
                  name: 'Profit & Loss',
                  isSelected: isProfitLoss,
                  onClick: () => _navigate(context, '/reports/profit-loss'),
                ),
                navSubButton(
                  name: 'Stock Summary',
                  isSelected: isStockSummary,
                  onClick: () => _navigate(context, '/reports/stock-summary'),
                ),
              ],
            ),
          navButton(
            name: 'Stores',
            prefixIcon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: isStores,
            onClick: () => _navigate(context, '/stores'),
          ),
          navButton(
            name: 'Account',
            prefixIcon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: isAccount,
            onClick: () => _navigate(context, '/account'),
          ),
          navButton(
            name: 'Settings',
            prefixIcon: Settings(classes: 'w-4.5 h-4.5'),
            isSelected: isSettings,
            onClick: () => _navigate(context, '/settings'),
          ),
        ]),
        div(classes: 'w-full px-4 pb-4 mt-auto', [
          button(
            classes:
                'btn border-none flex items-center justify-center gap-2 w-full h-10 font-semibold text-sm bg-soft-red text-soft-red-content rounded-lg hover:cursor-pointer',
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
            'text-sm ${isSelected ? 'text-accent' : 'text-gray-500'} font-semibold hover:cursor-pointer hover:bg-neutral rounded-lg h-8 w-full flex items-center',
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
