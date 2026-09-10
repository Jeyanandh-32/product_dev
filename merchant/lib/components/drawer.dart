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
  bool? _isInventoryExpanded;
  bool? _isReportsExpanded;
  String? _lastLocation;

  void _navigateTo(BuildContext context, String path) {
    final router = Router.of(context);
    final currentLocation = router.matchList.uri.toString();
    final wasOpen = navOpenSignal.value;
    navOpenSignal.value = false;

    if (currentLocation == path) return;

    if (wasOpen) {
      Future.delayed(const Duration(milliseconds: 180), () {
        if (mounted) router.push(path);
      });
    } else {
      router.push(path);
    }
  }

  void _toggleInventory(bool currentlyOpen) =>
      setState(() => _isInventoryExpanded = !currentlyOpen);

  void _toggleReports(bool currentlyOpen) =>
      setState(() => _isReportsExpanded = !currentlyOpen);

  @override
  Component buildSignal(BuildContext context) {
    final location = Router.of(context).matchList.uri.toString();
    if (_lastLocation != location) {
      _lastLocation = location;
      _isInventoryExpanded = null;
      _isReportsExpanded = null;
    }

    final activeTab = NavTab.values.firstWhere(
      (t) => location.startsWith(t.path),
      orElse: () => .dashboard,
    );
    final isNavOpen = navOpenSignal.value;

    final isInventory = activeTab == .inventory;
    final isReports = activeTab == .reports;
    final isInventoryOpen = _isInventoryExpanded ?? isInventory;
    final isReportsOpen = _isReportsExpanded ?? isReports;

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
          'fixed inset-y-0 left-0 z-50 w-64 h-full bg-white border-r border-border-medium flex flex-col items-center transform transition-transform duration-300 ease-in-out lg:translate-x-0 ${isNavOpen ? 'translate-x-0' : '-translate-x-full'} ${component.classes ?? ''}',
      [
        const DrawerBrandHeader(),
        ul(classes: 'mt-3 flex-1 w-full px-3.5 space-y-1 overflow-y-auto', [
          DrawerNavButtons.navButton(
            name: 'Dashboard',
            prefixIcon: LayoutGrid(classes: 'w-4.5 h-4.5'),
            isSelected: activeTab == .dashboard,
            onClick: () => _navigateTo(context, '/'),
          ),
          DrawerNavButtons.navButton(
            name: 'Inventory',
            prefixIcon: ShoppingCart(classes: 'w-4.5 h-4.5'),
            suffixIcon: DrawerNavButtons.chevron(isOpen: isInventoryOpen),
            isSelected: isInventory,
            isExpandable: true,
            onClick: () => _toggleInventory(isInventoryOpen),
          ),
          if (isInventoryOpen)
            DrawerInventorySubNav(
              activeInv: activeInv,
              onNavigate: (targetRoute) => _navigateTo(context, targetRoute),
            ),
          DrawerNavButtons.navButton(
            name: 'Reports',
            prefixIcon: ChartNoAxesCombined(classes: 'w-4.5 h-4.5'),
            suffixIcon: DrawerNavButtons.chevron(isOpen: isReportsOpen),
            isSelected: isReports,
            isExpandable: true,
            onClick: () => _toggleReports(isReportsOpen),
          ),
          if (isReportsOpen)
            DrawerReportsSubNav(
              activeRep: activeRep,
              onNavigate: (targetRoute) => _navigateTo(context, targetRoute),
            ),
          DrawerNavButtons.navButton(
            name: 'Stores',
            prefixIcon: Store(classes: 'w-4.5 h-4.5'),
            isSelected: activeTab == .stores,
            onClick: () => _navigateTo(context, '/stores'),
          ),
          DrawerNavButtons.navButton(
            name: 'Account',
            prefixIcon: UserRound(classes: 'w-4.5 h-4.5'),
            isSelected: activeTab == .account,
            onClick: () => _navigateTo(context, '/account'),
          ),
        ]),
        const DrawerLogoutFooter(),
      ],
    );
  }
}
