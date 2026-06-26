import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/drawer.dart';
import 'package:merchant/components/header.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/tabs/account.dart';
import 'package:merchant/tabs/dashboard.dart';
import 'package:merchant/tabs/inventory.dart';
import 'package:merchant/tabs/reports.dart';
import 'package:merchant/tabs/settings.dart';
import 'package:merchant/tabs/stores.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    final index = context.watch(indexProvider);
    final isNavOpen = context.watch(navOpenProvider);
    final tabs = [
      Dashboard(),
      Inventory(),
      Reports(),
      Stores(),
      Account(),
      Settings(),
    ];

    return div(classes: 'h-screen w-full bg-neutral flex', [
      if (isNavOpen)
        div(
          classes: 'fixed inset-0 bg-black/40 z-40 lg:hidden',
          events: {
            'click': (e) =>
                context.read(navOpenProvider.notifier).state = false,
          },
          [],
        ),

      Drawer(),

      div(
        classes: 'w-full lg:pl-64 h-screen flex flex-col overflow-hidden',
        [
          Header(),
          tabs[index],
        ],
      ),
    ]);
  }
}
