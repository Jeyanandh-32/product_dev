import 'dart:math';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_pinned_header.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_scrollable_header.dart';
import 'package:terminal/components/inventory/categories/inventory_category_pinned_row.dart';
import 'package:terminal/components/inventory/categories/inventory_category_scrollable_row.dart';

/// Full DaisyUI-styled table view for categories with pinned name and equal width distribution.
class InventoryCategoriesDataTable extends StatefulWidget {
  final List<Category> categories;
  final List<Product> allProducts;
  final void Function(Category category) onEdit;

  const InventoryCategoriesDataTable({
    super.key,
    required this.categories,
    required this.allProducts,
    required this.onEdit,
  });

  @override
  State<InventoryCategoriesDataTable> createState() => _InventoryCategoriesDataTableState();
}

class _InventoryCategoriesDataTableState extends State<InventoryCategoriesDataTable> {
  final ScrollController _leftController = ScrollController();
  final ScrollController _rightController = ScrollController();
  final ValueNotifier<int?> _hoveredIndex = ValueNotifier<int?>(null);
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _leftController.addListener(_syncLeftToRight);
    _rightController.addListener(_syncRightToLeft);
  }

  void _syncLeftToRight() {
    if (_isSyncing) return;
    _isSyncing = true;
    if (_rightController.hasClients && _rightController.offset != _leftController.offset) {
      _rightController.jumpTo(_leftController.offset);
    }
    _isSyncing = false;
  }

  void _syncRightToLeft() {
    if (_isSyncing) return;
    _isSyncing = true;
    if (_leftController.hasClients && _leftController.offset != _rightController.offset) {
      _leftController.jumpTo(_rightController.offset);
    }
    _isSyncing = false;
  }

  @override
  void dispose() {
    _leftController.removeListener(_syncLeftToRight);
    _rightController.removeListener(_syncRightToLeft);
    _leftController.dispose();
    _rightController.dispose();
    _hoveredIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fixedLeftWidth = 170.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final colWidth = max(160.0, (constraints.maxWidth - fixedLeftWidth) / 4);
        final pinnedWidth = fixedLeftWidth + colWidth;
        final scrollableWidth = colWidth * 3;

        return ValueListenableBuilder<int?>(
          valueListenable: _hoveredIndex,
          builder: (context, hoveredIndex, _) {
            return Row(
              children: [
                SizedBox(
                  width: pinnedWidth,
                  child: Column(
                    children: [
                      const InventoryCategoriesPinnedHeader(),
                      Expanded(
                        child: ListView.builder(
                          controller: _leftController,
                          itemCount: widget.categories.length,
                          itemBuilder: (context, index) {
                            final category = widget.categories[index];
                            return InventoryCategoryPinnedRow(
                              category: category,
                              isEven: index.isEven,
                              isHovered: hoveredIndex == index,
                              onEdit: () => widget.onEdit(category),
                              onHoverChanged: (hovered) => _hoveredIndex.value = hovered ? index : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: scrollableWidth,
                      child: Column(
                        children: [
                          const InventoryCategoriesScrollableHeader(),
                          Expanded(
                            child: ListView.builder(
                              controller: _rightController,
                              itemCount: widget.categories.length,
                              itemBuilder: (context, index) {
                                final category = widget.categories[index];
                                final count = widget.allProducts.where((p) => p.category?.id == category.id).length;
                                return InventoryCategoryScrollableRow(
                                  category: category,
                                  productsCount: count,
                                  isEven: index.isEven,
                                  isHovered: hoveredIndex == index,
                                  onHoverChanged: (hovered) => _hoveredIndex.value = hovered ? index : null,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
