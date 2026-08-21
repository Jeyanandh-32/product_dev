import 'dart:math';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/counters/inventory_counter_pinned_row.dart';
import 'package:terminal/components/inventory/counters/inventory_counter_scrollable_row.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_pinned_header.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_scrollable_header.dart';

/// Full DaisyUI-styled table view for counters with pinned name and equal width distribution.
class InventoryCountersDataTable extends StatefulWidget {
  final List<Counter> counters;
  final List<Product> allProducts;

  const InventoryCountersDataTable({
    super.key,
    required this.counters,
    required this.allProducts,
  });

  @override
  State<InventoryCountersDataTable> createState() => _InventoryCountersDataTableState();
}

class _InventoryCountersDataTableState extends State<InventoryCountersDataTable> {
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
    const fixedLeftWidth = 104.0;

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
                      const InventoryCountersPinnedHeader(),
                      Expanded(
                        child: ListView.builder(
                          controller: _leftController,
                          itemCount: widget.counters.length,
                          itemBuilder: (context, index) {
                            final counter = widget.counters[index];
                            return InventoryCounterPinnedRow(
                              counter: counter,
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: scrollableWidth,
                      child: Column(
                        children: [
                          const InventoryCountersScrollableHeader(),
                          Expanded(
                            child: ListView.builder(
                              controller: _rightController,
                              itemCount: widget.counters.length,
                              itemBuilder: (context, index) {
                                final counter = widget.counters[index];
                                final count = widget.allProducts.where((p) => p.counter?.id == counter.id).length;
                                return InventoryCounterScrollableRow(
                                  counter: counter,
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
