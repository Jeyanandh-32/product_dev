import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';
import 'package:terminal/components/navigation/inventory_mobile_submenu.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean inventory submenu that renders as a side-flyout on desktop/web
/// and delegates to [InventoryMobileSubmenu] on mobile viewports.
class InventorySubmenuItem extends StatelessWidget with FItemMixin {
  /// The parent navigation dropdown controller.
  final FPopoverController parentController;

  /// Creates an inventory submenu item.
  const InventorySubmenuItem({super.key, required this.parentController});

  FItem _navItem(IconData icon, String title, VoidCallback onPress) {
    return FItem(
      prefix: Icon(icon, size: 14),
      title: Text(title),
      onPress: () {
        parentController.toggle();
        onPress();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!context.isDesktop) {
      return InventoryMobileSubmenu(parentController: parentController);
    }

    final isBottleReturn = bottleReturnConfigSignal.value?.isEnabled ?? false;

    return FSubmenuItem(
      prefix: const Icon(FLucideIcons.boxes, size: 14),
      title: const Text('Inventory'),
      submenuAnchor: AlignmentDirectional.topStart,
      itemAnchor: AlignmentDirectional.topEnd,
      submenuSpacing: FPortalSpacing.zero,
      submenuOverflow: FPortalOverflow.flip,
      submenu: [
        FItemGroup(
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
      ],
    );
  }
}
