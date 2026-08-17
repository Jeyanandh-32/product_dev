import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

/// Clean inventory submenu group for the terminal navigation dropdown.
class InventorySubmenuItem extends StatelessWidget with FItemMixin {
  final FPopoverController parentController;

  const InventorySubmenuItem({super.key, required this.parentController});

  @override
  Widget build(BuildContext context) {
    return FSubmenuItem(
      prefix: const Icon(FLucideIcons.layers, size: 16),
      title: const Text('Inventory'),
      submenu: [
        FItemGroup(
          children: [
            FItem(
              prefix: const Icon(FLucideIcons.package, size: 16),
              title: const Text('Products'),
              onPress: () {
                parentController.toggle();
                GoRouter.maybeOf(context)?.push('/inventory/products');
              },
            ),
            FItem(
              prefix: const Icon(FLucideIcons.folder, size: 16),
              title: const Text('Categories'),
              onPress: () {
                parentController.toggle();
                GoRouter.maybeOf(context)?.push('/inventory/categories');
              },
            ),
            FItem(
              prefix: const Icon(FLucideIcons.hash, size: 16),
              title: const Text('Counters'),
              onPress: () {
                parentController.toggle();
                GoRouter.maybeOf(context)?.push('/inventory/counters');
              },
            ),
          ],
        ),
      ],
    );
  }
}
