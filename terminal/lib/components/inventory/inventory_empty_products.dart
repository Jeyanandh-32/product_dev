import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Clean, informative empty state for inventory products table and list.
class InventoryEmptyProducts extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onAddProduct;

  const InventoryEmptyProducts({
    super.key,
    required this.isFiltered,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
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
                isFiltered ? FLucideIcons.searchX : FLucideIcons.packageOpen,
                size: 28,
                color: isFiltered ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const Gap(16),
            Text(
              isFiltered ? 'No Matching Products' : 'No Products in Inventory',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              textAlign: TextAlign.center,
            ),
            const Gap(6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                isFiltered
                    ? 'No products match the selected search keyword and active filter criteria.'
                    : 'Get started by adding your first product to manage catalog, pricing, and stock.',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(20),
            UnconstrainedBox(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: isFiltered ? _resetFilters : onAddProduct,
                  style: BoxStyler()
                      .color(isFiltered ? const Color(0xFFFFFFFF) : const Color(0xFF000000))
                      .borderAll(color: isFiltered ? const Color(0xFFE2E8F0) : const Color(0xFF000000))
                      .paddingX(20)
                      .height(40)
                      .borderRadiusAll(const Radius.circular(10))
                      .alignment(Alignment.center)
                      .onHovered(
                        isFiltered
                            ? BoxStyler().color(const Color(0xFFF8FAFC))
                            : BoxStyler().color(const Color(0xFF1E293B)),
                      ),
                  child: Text(
                    isFiltered ? 'Reset Filters' : 'Add Product',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isFiltered ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF),
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
