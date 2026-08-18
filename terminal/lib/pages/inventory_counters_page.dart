import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/components.dart';

/// Inventory counters overview page using the shared terminal app bar.
class InventoryCountersPage extends StatelessWidget {
  const InventoryCountersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      childPad: false,
      header: TerminalAppBar(),
      child: SizedBox.shrink(),
    );
  }
}
