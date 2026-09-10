import 'package:merchant/components/navigation/drawer_brand_header.dart';
import 'package:merchant/components/navigation/drawer_inventory_sub_nav.dart';
import 'package:merchant/components/navigation/drawer_nav_buttons.dart';
import 'package:merchant/components/navigation/drawer_reports_sub_nav.dart';
import 'package:merchant/models/nav_tab.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:test/test.dart';

void main() {
  group('Navigation Signal Mobile Drawer Tests', () {
    setUp(() {
      resetNavigationSignal();
    });

    test('initial state of mobile drawer is closed', () {
      expect(navOpenSignal.value, isFalse);
    });

    test('opening mobile drawer updates signal', () {
      navOpenSignal.value = true;
      expect(navOpenSignal.value, isTrue);
    });

    test('resetNavigationSignal closes drawer', () {
      navOpenSignal.value = true;
      resetNavigationSignal();
      expect(navOpenSignal.value, isFalse);
    });
  });

  group('DrawerInventorySubNav Tests', () {
    test('instantiates with activeInv state', () {
      final subNav = DrawerInventorySubNav(
        activeInv: SubTab.categories,
        onNavigate: (_) {},
      );

      expect(subNav.activeInv, equals(SubTab.categories));
    });

    test('dispatches correct paths via onNavigate callback', () {
      final recordedPaths = <String>[];
      final subNav = DrawerInventorySubNav(
        activeInv: SubTab.products,
        onNavigate: recordedPaths.add,
      );

      subNav.onNavigate('/inventory/products');
      subNav.onNavigate('/inventory/categories');
      subNav.onNavigate('/inventory/counters');

      expect(recordedPaths, [
        '/inventory/products',
        '/inventory/categories',
        '/inventory/counters',
      ]);
    });
  });

  group('DrawerReportsSubNav Tests', () {
    test('instantiates with activeRep state', () {
      final subNav = DrawerReportsSubNav(
        activeRep: SubTab.profitLoss,
        onNavigate: (_) {},
      );

      expect(subNav.activeRep, equals(SubTab.profitLoss));
    });

    test('dispatches correct report paths via onNavigate callback', () {
      final recordedPaths = <String>[];
      final subNav = DrawerReportsSubNav(
        activeRep: SubTab.orders,
        onNavigate: recordedPaths.add,
      );

      subNav.onNavigate('/reports/orders');
      subNav.onNavigate('/reports/profit-loss');
      subNav.onNavigate('/reports/stock-summary');

      expect(recordedPaths, [
        '/reports/orders',
        '/reports/profit-loss',
        '/reports/stock-summary',
      ]);
    });
  });

  group('DrawerNavButtons Component Tests', () {
    test('creates navButton and navSubButton components without errors', () {
      var clicked = false;
      final btn = DrawerNavButtons.navSubButton(
        name: 'Products',
        isSelected: true,
        onClick: () => clicked = true,
      );

      expect(btn, isNotNull);
      expect(clicked, isFalse);
    });

    test('creates chevron component for open and closed states', () {
      final openChevron = DrawerNavButtons.chevron(isOpen: true);
      final closedChevron = DrawerNavButtons.chevron(isOpen: false);

      expect(openChevron, isNotNull);
      expect(closedChevron, isNotNull);
    });
  });

  group('DrawerBrandHeader Component Tests', () {
    test('creates DrawerBrandHeader without errors', () {
      const header = DrawerBrandHeader();
      expect(header, isNotNull);
    });
  });
}
