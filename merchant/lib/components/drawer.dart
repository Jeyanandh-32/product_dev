import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/navigation/drawer_brand_header.dart';
import 'package:merchant/components/navigation/drawer_inventory_sub_nav.dart';
import 'package:merchant/components/navigation/drawer_logout_footer.dart';
import 'package:merchant/components/navigation/drawer_nav_buttons.dart';
import 'package:merchant/components/navigation/drawer_reports_sub_nav.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/models/nav_tab.dart';
import 'package:merchant/signals/navigation_signal.dart';

/// Merchant main navigation sidebar drawer.
class Drawer extends SignalComponent {
  const Drawer({super.key, this.classes});

  final String? classes;

  @override
  SignalState<Drawer> createState() => _DrawerState();
}

class _DrawerState extends SignalState<Drawer> {
  static Component _navChevron({required bool isOpen}) {
    const iconClass = 'w-4 h-4 ml-auto mr-3 text-slate-400';
    return isOpen
        ? ChevronDown(classes: iconClass)
        : ChevronRight(classes: iconClass);
  }

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

    final activeInv = isInventory
        ? SubTab.values.firstWhere(
            (sub) => location.contains(sub.name),
            orElse: () => .products,
          )
        : null;
    final activeRep = isReports
        ? SubTab.values.firstWhere(
            (sub) => location.contains(sub.name) || location.contains(sub.slug),
            orElse: () => .orders,
          )
        : null;

    return div(
      classes:
          'fixed z-50 ${isNavOpen ? 'left-0' : '-left-full'} transition-all duration-300 lg:left-0 flex w-64 h-full bg-white border-r border-border-medium flex-col items-center ${component.classes ?? ''}',
      [
        const DrawerBrandHeader(),
        ul(classes: 'mt-3 flex-1 w-full px-3.5 space-y-1 overflow-y-auto', [
          DrawerNavButtons.navButton(
            name: 'Dashboard',
            prefixIcon: LayoutGrid(classes: 'w-4.5 h-4.5'),
            isSelected: isDashboard,
            onClick: () => _navigateTo(context, '/'),
          ),
          DrawerNavButtons.navButton(
            name: 'Inventory',
            prefixIcon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            suffixIcon: _navChevron(isOpen: isInventory),
            isSelected: isInventory,
            onClick: () => _navigateTo(context, '/inventory/products'),
          ),
          if (isInventory)
            DrawerInventorySubNav(
              activeInv: activeInv,
              onNavigate: (targetRoute) => _navigateTo(context, targetRoute),
            ),
          DrawerNavButtons.navButton(
            name: 'Reports',
            prefixIcon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
            suffixIcon: _navChevron(isOpen: isReports),
            isSelected: isReports,
            onClick: () => _navigateTo(context, '/reports/orders'),
          ),
          if (isReports)
            DrawerReportsSubNav(
              activeRep: activeRep,
              onNavigate: (targetRoute) => _navigateTo(context, targetRoute),
            ),
          DrawerNavButtons.navButton(
            name: 'Stores',
            prefixIcon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: isStores,
            onClick: () => _navigateTo(context, '/stores'),
          ),
          DrawerNavButtons.navButton(
            name: 'Account',
            prefixIcon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: isAccount,
            onClick: () => _navigateTo(context, '/account'),
          ),
        ]),
        const DrawerLogoutFooter(),
      ],
    );
  }
}
