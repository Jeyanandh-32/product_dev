import 'dart:math';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/products/inventory_product_pinned_row.dart';
import 'package:terminal/components/inventory/products/inventory_product_scrollable_row.dart';
import 'package:terminal/components/inventory/products/inventory_products_pinned_header.dart';
import 'package:terminal/components/inventory/products/inventory_products_scrollable_header.dart';

/// Full DaisyUI-styled table view for products with pinned columns (table-pin-rows table-pin-cols).
class InventoryDataTable extends StatefulWidget {
  final List<Product> products;
  final void Function(Product product) onEdit;
  final void Function(Product product) onUpdateStock;

  const InventoryDataTable({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onUpdateStock,
  });

  @override
  State<InventoryDataTable> createState() => _InventoryDataTableState();
}

class _InventoryDataTableState extends State<InventoryDataTable> {
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
    if (_rightController.hasClients &&
        _rightController.offset != _leftController.offset) {
      _rightController.jumpTo(_leftController.offset);
    }
    _isSyncing = false;
  }

  void _syncRightToLeft() {
    if (_isSyncing) return;
    _isSyncing = true;
    if (_leftController.hasClients &&
        _leftController.offset != _rightController.offset) {
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
    const pinnedWidth = 440.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollableWidth = max(1680.0, constraints.maxWidth - pinnedWidth);

        return ValueListenableBuilder<int?>(
          valueListenable: _hoveredIndex,
          builder: (context, hoveredIndex, _) {
            return Row(
              children: [
                // Pinned Left Pane (Action, Image, Product Name)
                SizedBox(
                  width: pinnedWidth,
                  child: Column(
                    children: [
                      const InventoryProductsPinnedHeader(),
                      Expanded(
                        child: ListView.builder(
                          controller: _leftController,
                          itemCount: widget.products.length,
                          itemBuilder: (context, index) {
                            final product = widget.products[index];
                            return InventoryProductPinnedRow(
                              product: product,
                              isEven: index.isEven,
                              isHovered: hoveredIndex == index,
                              onEdit: () => widget.onEdit(product),
                              onUpdateStock: () =>
                                  widget.onUpdateStock(product),
                              onHoverChanged: (hovered) {
                                _hoveredIndex.value = hovered ? index : null;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Horizontally Scrollable Right Pane (11 Data Columns)
                Expanded(
                  child: SingleChildScrollView(
                    key: const ValueKey('inventory_products_scrollable_pane'),
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: scrollableWidth,
                      child: Column(
                        children: [
                          const InventoryProductsScrollableHeader(),
                          Expanded(
                            child: ListView.builder(
                              controller: _rightController,
                              itemCount: widget.products.length,
                              itemBuilder: (context, index) {
                                final product = widget.products[index];
                                return InventoryProductScrollableRow(
                                  product: product,
                                  isEven: index.isEven,
                                  isHovered: hoveredIndex == index,
                                  onHoverChanged: (hovered) {
                                    _hoveredIndex.value = hovered
                                        ? index
                                        : null;
                                  },
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
