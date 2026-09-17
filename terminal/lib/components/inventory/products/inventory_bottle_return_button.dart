import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';

/// Button triggering the bottle return configuration modal in the inventory toolbar.
class InventoryBottleReturnButton extends StatelessWidget {
  final bool isCompact;

  const InventoryBottleReturnButton({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final base = BoxStyler()
        .height(36)
        .color(const Color(0xFFF0FDF4))
        .borderAll(color: const Color(0xFFBBF7D0))
        .borderRadiusAll(const Radius.circular(999))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(const Color(0xFFDCFCE7)));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: 'Bottle Returns',
        child: PressableBox(
          onPress: () => ReturnableProductsModal.show(context),
          style: isCompact ? base.width(36) : base.paddingX(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FLucideIcons.recycle,
                size: 15,
                color: Color(0xFF16A34A),
              ),
              if (!isCompact) ...[
                const Gap(6),
                const Text(
                  'Bottle Returns',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
