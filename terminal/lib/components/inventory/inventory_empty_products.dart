import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean, informative empty state for inventory products table and list.
class InventoryEmptyProducts extends StatelessWidget {
  final bool isFiltered;
  final bool hasCategories;
  final VoidCallback onAddProduct;
  final VoidCallback onAddCategory;

  const InventoryEmptyProducts({
    super.key,
    required this.isFiltered,
    this.hasCategories = true,
    required this.onAddProduct,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    final showCategoryGuide = !isFiltered && !hasCategories;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isFiltered
                    ? FLucideIcons.searchX
                    : (showCategoryGuide
                          ? FLucideIcons.folderPlus
                          : FLucideIcons.packageOpen),
                size: 28,
                color: isFiltered
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF475569),
              ),
            ),
            const Gap(16),
            Text(
              isFiltered
                  ? 'No Matching Products'
                  : (showCategoryGuide
                        ? 'Create your first category'
                        : 'No Products in Inventory'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                isFiltered
                    ? 'No products match the selected search keyword and active filter criteria.'
                    : (showCategoryGuide
                          ? 'Every product belongs to a category. Set up your first category to start adding products.'
                          : 'Get started by adding your first product to manage catalog, pricing, and stock.'),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(20),
            UnconstrainedBox(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: isFiltered
                      ? _resetFilters
                      : (showCategoryGuide ? onAddCategory : onAddProduct),
                  style: BoxStyler()
                      .color(
                        isFiltered
                            ? const Color(0xFFFFFFFF)
                            : TerminalColors.primary,
                      )
                      .borderAll(
                        color: isFiltered
                            ? const Color(0xFFE2E8F0)
                            : TerminalColors.primary,
                      )
                      .paddingX(20)
                      .height(40)
                      .borderRadiusAll(const Radius.circular(10))
                      .alignment(Alignment.center)
                      .onHovered(
                        isFiltered
                            ? BoxStyler().color(const Color(0xFFF8FAFC))
                            : BoxStyler().color(TerminalColors.primaryHover),
                      ),
                  child: Text(
                    isFiltered
                        ? 'Reset Filters'
                        : (showCategoryGuide
                              ? 'Create First Category'
                              : 'Add Product'),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isFiltered
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    inventorySearchSignal.value = '';
    inventoryCategoryFilterSignal.value = null;
    inventoryCounterFilterSignal.value = null;
    inventoryStatusFilterSignal.value = null;
    inventoryStockMonitorFilterSignal.value = null;
    inventoryStockHealthFilterSignal.value = StockHealthFilter.all;
    inventoryPageSignal.value = 1;
  }
}
