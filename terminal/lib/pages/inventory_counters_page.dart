import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/components.dart';
import 'package:mix/mix.dart';

/// Read-only inventory counters overview page using Forui.
class InventoryCountersPage extends StatelessWidget {
  const InventoryCountersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Store Counters'),
        prefixes: const [
          TerminalBackButton(),
        ],
      ),
      child: Center(
        child: StyledText(
          'Manage counters via the Merchant Portal',
          style: TextStyler().fontSize(14).color(const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}
