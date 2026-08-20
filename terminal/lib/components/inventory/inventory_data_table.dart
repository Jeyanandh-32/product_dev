import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/products/inventory_product_table_row.dart';
import 'package:terminal/components/inventory/products/inventory_products_table_header.dart';

/// Full DaisyUI-styled table view for products (table-zebra table-pin-rows table-pin-cols).
class InventoryDataTable extends StatelessWidget {
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
  Widget build(BuildContext context) {
    const tableWidth = 2100.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: tableWidth,
        child: Column(
          children: [
            const InventoryProductsTableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InventoryProductTableRow(
                    product: product,
                    isEven: index.isEven,
                    onEdit: () => onEdit(product),
                    onUpdateStock: () => onUpdateStock(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
