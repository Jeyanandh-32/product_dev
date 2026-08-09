import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/models/nav_tab.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';

class Drawer extends SignalComponent {
  const Drawer({super.key, this.classes});

  final String? classes;

  @override
  SignalState<Drawer> createState() => _DrawerState();
}

class _DrawerState extends SignalState<Drawer> {
  void _navigateTo(BuildContext context, String path) {
    Router.of(context).push(path);
    navOpenSignal.value = false;
  }

  @override
  Component buildSignal(BuildContext context) {
    final location = Router.of(context).matchList.uri.toString();
    final activeTab = NavTab.values.firstWhere(
      (t) => location.startsWith(t.path),
      orElse: () => .dashboard,
    );
    final isNavOpen = navOpenSignal.value;

    final isDashboard = activeTab == .dashboard;
    final isInventory = activeTab == .inventory;
    final isReports = activeTab == .reports;
    final isStores = activeTab == .stores;
    final isAccount = activeTab == .account;
    final isSettings = activeTab == .settings;

    final activeInventorySub = isInventory
        ? SubTab.values.firstWhere(
            (sub) => location.contains(sub.name),
            orElse: () => .products,
          )
        : null;
    final activeReportsSub = isReports
        ? SubTab.values.firstWhere(
            (sub) => location.contains(sub.name) || location.contains(sub.slug),
            orElse: () => .orders,
          )
        : null;

    return div(
      classes:
          'fixed z-50 ${isNavOpen ? 'left-0' : '-left-full'} transition-all duration-300 lg:left-0 flex w-64 h-full bg-white border-r border-border-medium flex-col items-center ${component.classes ?? ''}',
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
            onClick: () => _navigateTo(context, '/'),
          ),
          navButton(
            name: 'Inventory',
            prefixIcon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            suffixIcon: isInventory
                ? ChevronDown(classes: 'w-4.5 h-4.5 ml-auto mr-6')
                : ChevronRight(classes: 'w-4.5 h-4.5 ml-auto mr-6'),
            isSelected: isInventory,
            onClick: () => _navigateTo(context, '/inventory/products'),
          ),
          if (isInventory)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Products',
                  isSelected: activeInventorySub == .products,
                  onClick: () => _navigateTo(context, '/inventory/products'),
                ),
                navSubButton(
                  name: 'Category',
                  isSelected: activeInventorySub == .categories,
                  onClick: () => _navigateTo(context, '/inventory/categories'),
                ),
                navSubButton(
                  name: 'Counters',
                  isSelected: activeInventorySub == .counters,
                  onClick: () => _navigateTo(context, '/inventory/counters'),
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
            onClick: () => _navigateTo(context, '/reports/orders'),
          ),
          if (isReports)
            ul(
              classes: 'flex flex-col items-center w-full pr-4 pl-8 space-y-1',
              [
                navSubButton(
                  name: 'Orders',
                  isSelected: activeReportsSub == .orders,
                  onClick: () => _navigateTo(context, '/reports/orders'),
                ),
                navSubButton(
                  name: 'Payments',
                  isSelected: activeReportsSub == .payments,
                  onClick: () => _navigateTo(context, '/reports/payments'),
                ),
                navSubButton(
                  name: 'Profit & Loss',
                  isSelected: activeReportsSub == .profitLoss,
                  onClick: () => _navigateTo(context, '/reports/profit-loss'),
                ),
                navSubButton(
                  name: 'Stock Summary',
                  isSelected: activeReportsSub == .stockSummary,
                  onClick: () => _navigateTo(context, '/reports/stock-summary'),
                ),
              ],
            ),

          navButton(
            name: 'Stores',
            prefixIcon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: isStores,
            onClick: () => _navigateTo(context, '/stores'),
          ),
          navButton(
            name: 'Account',
            prefixIcon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: isAccount,
            onClick: () => _navigateTo(context, '/account'),
          ),
          navButton(
            name: 'Settings',
            prefixIcon: Settings(classes: 'w-4.5 h-4.5'),
            isSelected: isSettings,
            onClick: () => _navigateTo(context, '/settings'),
          ),
        ]),
        div(classes: 'w-full px-4 pb-4 mt-auto', [
          button(
            classes:
                'btn border-none flex items-center justify-center gap-2 w-full h-10 font-semibold text-sm bg-soft-red text-soft-red-content rounded-lg hover:cursor-pointer',
            onClick: () => logoutMerchant(),
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
