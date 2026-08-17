import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/components/navigation/dropdown_trigger_pill.dart';
import 'package:terminal/components/navigation/inventory_submenu_item.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Clean navigation popover menu for switching between POS pages.
class TerminalNavigationDropdown extends StatefulWidget {
  const TerminalNavigationDropdown({super.key});

  @override
  State<TerminalNavigationDropdown> createState() =>
      _TerminalNavigationDropdownState();
}

class _TerminalNavigationDropdownState
    extends State<TerminalNavigationDropdown>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terminal = authSignal.value.value;
    final label = terminal != null ? 'Device: ${terminal.code}' : 'Menu';

    return FPopoverMenu(
      control: .managed(controller: _controller),
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      menu: [
        FItemGroup(
          children: [
            FItem(
              prefix: const Icon(FLucideIcons.shoppingBag, size: 16),
              title: const Text('POS Register'),
              onPress: () {
                _controller.toggle();
                GoRouter.maybeOf(context)?.go('/');
              },
            ),
            FItem(
              prefix: const Icon(FLucideIcons.receipt, size: 16),
              title: const Text('Order History'),
              onPress: () {
                _controller.toggle();
                GoRouter.maybeOf(context)?.push('/orders');
              },
            ),
            InventorySubmenuItem(parentController: _controller),
            FItem(
              prefix: const Icon(FLucideIcons.circleUser, size: 16),
              title: const Text('Device Account'),
              onPress: () {
                _controller.toggle();
                GoRouter.maybeOf(context)?.push('/account');
              },
            ),
          ],
        ),
      ],
      child: DropdownTriggerPill(label: label, controller: _controller),
    );
  }
}
