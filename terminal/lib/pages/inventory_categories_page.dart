import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/components.dart';

/// Inventory categories overview page using the shared terminal app bar.
class InventoryCategoriesPage extends StatelessWidget {
  const InventoryCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      childPad: false,
      header: TerminalAppBar(),
      child: SizedBox.shrink(),
    );
  }
}
