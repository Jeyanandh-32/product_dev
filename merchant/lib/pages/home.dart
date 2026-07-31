import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/drawer.dart';
import 'package:merchant/components/header.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/tabs/account.dart';
import 'package:merchant/tabs/dashboard.dart';
import 'package:merchant/tabs/inventory.dart';
import 'package:merchant/tabs/reports.dart';
import 'package:merchant/tabs/settings.dart';
import 'package:merchant/tabs/stores.dart';

class Home extends SignalComponent {
  const Home({super.key});

  @override
  SignalState<Home> createState() => _HomeState();
}

class _HomeState extends SignalState<Home> {
  @override
  Component buildSignal(BuildContext context) {
    final index = indexSignal.value;
    final isNavOpen = navOpenSignal.value;
    final tabs = [
      const Dashboard(),
      const Inventory(),
      const Reports(),
      const Stores(),
      const Account(),
      const Settings(),
    ];

    return div(classes: 'h-screen w-full bg-neutral flex', [
      if (isNavOpen)
        div(
          classes: 'fixed inset-0 bg-black/40 z-40 lg:hidden',
          events: {
            'click': (e) => navOpenSignal.value = false,
          },
          [],
        ),

      const Drawer(),

      div(
        classes: 'w-full lg:pl-64 h-screen flex flex-col overflow-hidden',
        [
          const Header(),
          tabs[index],
        ],
      ),
    ]);
  }
}
