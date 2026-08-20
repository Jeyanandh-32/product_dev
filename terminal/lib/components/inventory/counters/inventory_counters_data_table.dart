import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/counters/inventory_counter_table_row.dart';
import 'package:terminal/components/inventory/counters/inventory_counters_table_header.dart';

/// Full DaisyUI-styled table view for counters (table-zebra table-pin-rows table-pin-cols).
class InventoryCountersDataTable extends StatelessWidget {
  final List<Counter> counters;
  final List<Product> allProducts;

  const InventoryCountersDataTable({
    super.key,
    required this.counters,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth = constraints.maxWidth < 800 ? 800.0 : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: minWidth,
            child: Column(
              children: [
                const InventoryCountersTableHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: counters.length,
                    itemBuilder: (context, index) {
                      final counter = counters[index];
                      final count = allProducts.where((p) => p.counter?.id == counter.id).length;
                      return InventoryCounterTableRow(
                        counter: counter,
                        productsCount: count,
                        isEven: index.isEven,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
