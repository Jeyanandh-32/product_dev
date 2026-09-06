import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';

/// Clean inline expandable accordion submenu for mobile / compact viewports.
class InventoryMobileSubmenu extends StatefulWidget {
  /// The parent navigation dropdown controller.
  final FPopoverController parentController;

  /// Creates a mobile accordion inventory submenu.
  const InventoryMobileSubmenu({super.key, required this.parentController});

  @override
  State<InventoryMobileSubmenu> createState() => _InventoryMobileSubmenuState();
}

class _InventoryMobileSubmenuState extends State<InventoryMobileSubmenu> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final active = activeTerminalPageSignal.value;
    _isExpanded =
        active == TerminalNavPage.inventoryProducts ||
        active == TerminalNavPage.inventoryCategories ||
        active == TerminalNavPage.inventoryCounters;
  }

  FItem _navItem(
    IconData icon,
    String title,
    VoidCallback onPress, {
    double size = 13,
  }) {
    return FItem(
      prefix: Icon(icon, size: size),
      title: Text(title, style: const TextStyle(fontSize: 13.5)),
      onPress: () {
        widget.parentController.toggle();
        onPress();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBottleReturn = bottleReturnConfigSignal.value?.isEnabled ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FItem(
          prefix: const Icon(FLucideIcons.boxes, size: 14),
          title: const Text('Inventory'),
          suffix: Icon(
            _isExpanded ? FLucideIcons.chevronDown : FLucideIcons.chevronRight,
            size: 14,
          ),
          onPress: () => setState(() => _isExpanded = !_isExpanded),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _navItem(
                  FLucideIcons.package,
                  'Products',
                  () => activeTerminalPageSignal.value =
                      TerminalNavPage.inventoryProducts,
                ),
                _navItem(
                  FLucideIcons.folder,
                  'Categories',
                  () => activeTerminalPageSignal.value =
                      TerminalNavPage.inventoryCategories,
                ),
                _navItem(
                  FLucideIcons.hash,
                  'Counters',
                  () => activeTerminalPageSignal.value =
                      TerminalNavPage.inventoryCounters,
                ),
                if (isBottleReturn)
                  _navItem(
                    FLucideIcons.recycle,
                    'Bottle Returns',
                    () => ReturnableProductsModal.show(context),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
