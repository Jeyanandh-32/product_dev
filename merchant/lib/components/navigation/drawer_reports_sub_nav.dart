import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/navigation/drawer_nav_buttons.dart';
import 'package:merchant/models/nav_tab.dart';

/// Reports sub-navigation list for the merchant sidebar drawer.
class DrawerReportsSubNav extends StatelessComponent {
  final SubTab? activeRep;
  final ValueChanged<String> onNavigate;

  const DrawerReportsSubNav({
    super.key,
    required this.activeRep,
    required this.onNavigate,
  });

  @override
  Component build(BuildContext context) {
    return ul(
      classes: 'flex flex-col items-center w-full pr-2 pl-6 space-y-1',
      [
        DrawerNavButtons.navSubButton(
          name: 'Orders',
          isSelected: activeRep == SubTab.orders,
          onClick: () => onNavigate('/reports/orders'),
        ),
        DrawerNavButtons.navSubButton(
          name: 'Profit & Loss',
          isSelected: activeRep == SubTab.profitLoss,
          onClick: () => onNavigate('/reports/profit-loss'),
        ),
        DrawerNavButtons.navSubButton(
          name: 'Stock Summary',
          isSelected: activeRep == SubTab.stockSummary,
          onClick: () => onNavigate('/reports/stock-summary'),
        ),
      ],
    );
  }
}
