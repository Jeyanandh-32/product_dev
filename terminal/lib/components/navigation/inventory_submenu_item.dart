import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean inventory submenu that renders as a side-flyout on desktop
/// and as an inline expandable accordion on mobile to prevent overlay collision.
class InventorySubmenuItem extends StatefulWidget with FItemMixin {
  final FPopoverController parentController;

  const InventorySubmenuItem({super.key, required this.parentController});

  @override
  State<InventorySubmenuItem> createState() => _InventorySubmenuItemState();
}

class _InventorySubmenuItemState extends State<InventorySubmenuItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    final active = activeTerminalPageSignal.value;
    _isExpanded = active == TerminalNavPage.inventoryProducts ||
        active == TerminalNavPage.inventoryCategories ||
        active == TerminalNavPage.inventoryCounters;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isBottleReturnEnabled =
        bottleReturnConfigSignal.value?.isEnabled ?? false;

    if (isDesktop) {
      return FSubmenuItem(
        prefix: const Icon(FLucideIcons.boxes, size: 14),
        title: const Text('Inventory'),
        submenu: [
          FItemGroup(
            children: [
              FItem(
                prefix: const Icon(FLucideIcons.package, size: 14),
                title: const Text('Products'),
                onPress: () {
                  widget.parentController.toggle();
                  activeTerminalPageSignal.value = TerminalNavPage.inventoryProducts;
                },
              ),
              FItem(
                prefix: const Icon(FLucideIcons.folder, size: 14),
                title: const Text('Categories'),
                onPress: () {
                  widget.parentController.toggle();
                  activeTerminalPageSignal.value = TerminalNavPage.inventoryCategories;
                },
              ),
              FItem(
                prefix: const Icon(FLucideIcons.hash, size: 14),
                title: const Text('Counters'),
                onPress: () {
                  widget.parentController.toggle();
                  activeTerminalPageSignal.value = TerminalNavPage.inventoryCounters;
                },
              ),
              if (isBottleReturnEnabled)
                FItem(
                  prefix: const Icon(FLucideIcons.recycle, size: 14),
                  title: const Text('Bottle Returns'),
                  onPress: () {
                    widget.parentController.toggle();
                    ReturnableProductsModal.show(context);
                  },
                ),
            ],
          ),
        ],
      );
    }

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
                FItem(
                  prefix: const Icon(FLucideIcons.package, size: 13),
                  title: const Text('Products', style: TextStyle(fontSize: 13.5)),
                  onPress: () {
                    widget.parentController.toggle();
                    activeTerminalPageSignal.value = TerminalNavPage.inventoryProducts;
                  },
                ),
                FItem(
                  prefix: const Icon(FLucideIcons.folder, size: 13),
                  title: const Text('Categories', style: TextStyle(fontSize: 13.5)),
                  onPress: () {
                    widget.parentController.toggle();
                    activeTerminalPageSignal.value = TerminalNavPage.inventoryCategories;
                  },
                ),
                FItem(
                  prefix: const Icon(FLucideIcons.hash, size: 13),
                  title: const Text('Counters', style: TextStyle(fontSize: 13.5)),
                  onPress: () {
                    widget.parentController.toggle();
                    activeTerminalPageSignal.value = TerminalNavPage.inventoryCounters;
                  },
                ),
                if (isBottleReturnEnabled)
                  FItem(
                    prefix: const Icon(FLucideIcons.recycle, size: 13),
                    title: const Text('Bottle Returns', style: TextStyle(fontSize: 13.5)),
                    onPress: () {
                      widget.parentController.toggle();
                      ReturnableProductsModal.show(context);
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
