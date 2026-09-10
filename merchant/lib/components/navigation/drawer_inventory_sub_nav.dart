import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/navigation/drawer_nav_buttons.dart';
import 'package:merchant/models/nav_tab.dart';

/// Inventory sub-navigation list for the merchant sidebar drawer.
class DrawerInventorySubNav extends StatelessComponent {
  final SubTab? activeInv;
  final ValueChanged<String> onNavigate;

  const DrawerInventorySubNav({
    super.key,
    required this.activeInv,
    required this.onNavigate,
  });

  @override
  Component build(BuildContext context) {
    return ul(
      classes: 'flex flex-col items-center w-full pr-2 pl-6 space-y-1',
      [
        DrawerNavButtons.navSubButton(
          name: 'Products',
          isSelected: activeInv == SubTab.products,
          onClick: () => onNavigate('/inventory/products'),
        ),
        DrawerNavButtons.navSubButton(
          name: 'Category',
          isSelected: activeInv == SubTab.categories,
          onClick: () => onNavigate('/inventory/categories'),
        ),
        DrawerNavButtons.navSubButton(
          name: 'Counters',
          isSelected: activeInv == SubTab.counters,
          onClick: () => onNavigate('/inventory/counters'),
        ),
      ],
    );
  }
}
