import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory_filter_bar.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';
import 'package:terminal/components/inventory/products/inventory_product_search_field.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Top control toolbar for Inventory catalog with search box, filter pills, and add product action.
class InventoryProductsToolbar extends StatelessWidget {
  final VoidCallback onAddProduct;

  const InventoryProductsToolbar({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;
        final isMobile = constraints.maxWidth < 560;

        return SignalBuilder(
          builder: (context) {
            final categories = categoriesSignal.value.value ?? <Category>[];
            final counters = countersSignal.value.value ?? <Counter>[];
            final isBottleEnabled =
                bottleReturnConfigSignal.value?.isEnabled ?? false;
            final collapseButtons = isBottleEnabled
                ? isMobile
                : constraints.maxWidth < 420;

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(child: InventoryProductSearchField()),
                      const Gap(8),
                      if (isBottleEnabled) ...[
                        _buildBottleReturnButton(
                          context,
                          isCompact: collapseButtons,
                        ),
                        const Gap(8),
                      ],
                      _buildAddButton(isCompact: collapseButtons),
                    ],
                  ),
                  const Gap(10),
                  InventoryFilterBar(
                    categories: categories,
                    counters: counters,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: InventoryFilterBar(
                    categories: categories,
                    counters: counters,
                  ),
                ),
                const Gap(16),
                const InventoryProductSearchField(width: 220),
                if (isBottleEnabled) ...[
                  const Gap(8),
                  _buildBottleReturnButton(context),
                ],
                const Gap(8),
                _buildAddButton(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBottleReturnButton(
    BuildContext context, {
    bool isCompact = false,
  }) {
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

  Widget _buildAddButton({bool isCompact = false}) {
    final base = BoxStyler()
        .height(36)
        .color(TerminalColors.primary)
        .borderRadiusAll(const Radius.circular(999))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(TerminalColors.primaryHover));
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: 'Add Product',
        child: PressableBox(
          onPress: onAddProduct,
          style: isCompact ? base.width(36) : base.paddingX(14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FLucideIcons.plus, size: 16, color: Color(0xFFFFFFFF)),
              if (!isCompact) ...[
                const Gap(6),
                const Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFFFFF),
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
