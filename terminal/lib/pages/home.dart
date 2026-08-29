import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/billing/billing_catalog_view.dart';
import 'package:terminal/components/common/subscription_banner.dart';
import 'package:terminal/components/navigation/terminal_app_bar.dart';
import 'package:terminal/pages/account_page.dart';
import 'package:terminal/pages/inventory_categories_page.dart';
import 'package:terminal/pages/inventory_counters_page.dart';
import 'package:terminal/pages/inventory_products_page.dart';
import 'package:terminal/pages/orders_page.dart';
import 'package:terminal/signals/account_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';

/// Main POS cashier terminal shell hosting persistent app bar, subscription banner, and index-based body.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TerminalAppBar(),
          SignalBuilder(
            builder: (context) {
              final sub = terminalAccountSignal.value.value?.subscription;
              if (sub == null) return const SizedBox.shrink();
              return SubscriptionBanner(subscription: sub);
            },
          ),
        ],
      ),
      child: SignalBuilder(
        builder: (context) {
          final activePage = activeTerminalPageSignal.value;

          return IndexedStack(
            index: activePage.index,
            children: const [
              BillingCatalogView(),
              OrdersPage(),
              InventoryProductsPage(),
              InventoryCategoriesPage(),
              InventoryCountersPage(),
              AccountPage(),
            ],
          );
        },
      ),
    );
  }
}
