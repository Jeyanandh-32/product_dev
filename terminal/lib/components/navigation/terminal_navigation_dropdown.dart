import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/navigation/dropdown_trigger_pill.dart';
import 'package:terminal/components/navigation/inventory_submenu_item.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/theme.dart';

/// Clean compact navigation popover menu for switching between POS pages.
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
    return SignalBuilder(
      builder: (context) {
        final activePage = activeTerminalPageSignal.value;

        return FTheme(
          data: TerminalTheme.light(false),
          child: FPopoverMenu(
            control: .managed(controller: _controller),
            menuAnchor: Alignment.topRight,
            childAnchor: Alignment.bottomRight,
            menu: [
              FItemGroup(
                children: [
                  FItem(
                    prefix: const Icon(FLucideIcons.calculator, size: 14),
                    title: const Text('Billing'),
                    onPress: () {
                      _controller.toggle();
                      activeTerminalPageSignal.value = TerminalNavPage.billing;
                    },
                  ),
                  FItem(
                    prefix: const Icon(FLucideIcons.receipt, size: 14),
                    title: const Text('Orders'),
                    onPress: () {
                      _controller.toggle();
                      activeTerminalPageSignal.value = TerminalNavPage.orders;
                    },
                  ),
                  InventorySubmenuItem(parentController: _controller),
                  FItem(
                    prefix: const Icon(FLucideIcons.circleUser, size: 14),
                    title: const Text('Account'),
                    onPress: () {
                      _controller.toggle();
                      activeTerminalPageSignal.value = TerminalNavPage.account;
                    },
                  ),
                ],
              ),
            ],
            child: DropdownTriggerPill(label: activePage.label, controller: _controller),
          ),
        );
      },
    );
  }
}
