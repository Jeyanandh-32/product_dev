import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/drawer.dart';
import 'package:merchant/components/header.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';

class Home extends SignalComponent {
  const Home({super.key, required this.child});

  final Component child;

  @override
  SignalState<Home> createState() => _HomeState();
}

class _HomeState extends SignalState<Home> {
  @override
  void initState() {
    super.initState();
    refreshStoresSignal();
  }

  @override
  Component buildSignal(BuildContext context) {
    final isNavOpen = navOpenSignal.value;

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
          component.child,
        ],
      ),
    ]);
  }
}
