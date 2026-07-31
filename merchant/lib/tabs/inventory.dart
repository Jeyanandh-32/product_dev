import 'package:jaspr/client.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/sub_tabs/categories.dart';
import 'package:merchant/sub_tabs/counters.dart';
import 'package:merchant/sub_tabs/products.dart';

class Inventory extends SignalComponent {
  const Inventory({super.key});

  @override
  SignalState<Inventory> createState() => _InventoryState();
}

class _InventoryState extends SignalState<Inventory> {
  @override
  Component buildSignal(BuildContext context) {
    final subIndex = subIndexSignal.value;
    final tabs = [const Products(), const Categories(), const Counters()];

    return tabs[subIndex];
  }
}
