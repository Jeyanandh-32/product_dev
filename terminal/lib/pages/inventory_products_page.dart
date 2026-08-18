import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/components.dart';

/// Inventory products overview page using the shared terminal app bar.
class InventoryProductsPage extends StatelessWidget {
  const InventoryProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      childPad: false,
      header: TerminalAppBar(),
      child: SizedBox.shrink(),
    );
  }
}
