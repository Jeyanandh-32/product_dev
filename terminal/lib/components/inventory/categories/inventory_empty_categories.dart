import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean, informative empty state for inventory categories table and list.
class InventoryEmptyCategories extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onAddCategory;

  const InventoryEmptyCategories({
    super.key,
    required this.isFiltered,
    required this.onAddCategory,
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
                isFiltered ? FLucideIcons.searchX : FLucideIcons.folderOpen,
                size: 28,
                color: isFiltered
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF475569),
              ),
            ),
            const Gap(16),
            Text(
              isFiltered
                  ? 'No Matching Categories'
                  : 'No Categories in Inventory',
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
                    ? 'No categories match the selected search keyword or active status filter.'
                    : 'Get started by creating categories to organize products in your POS catalog.',
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
                  onPress: isFiltered ? _resetFilters : onAddCategory,
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
                    isFiltered ? 'Reset Filters' : 'Add Category',
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
    categorySearchSignal.value = '';
    categoryStatusFilterSignal.value = null;
    categoryPageSignal.value = 1;
  }
}
