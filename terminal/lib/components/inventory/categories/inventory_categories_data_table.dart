import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_table_header.dart';
import 'package:terminal/components/inventory/categories/inventory_category_table_row.dart';

/// Full DaisyUI-styled table view for categories (table-zebra table-pin-rows table-pin-cols).
class InventoryCategoriesDataTable extends StatelessWidget {
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
                const InventoryCategoriesTableHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final count = allProducts.where((p) => p.category?.id == category.id).length;
                      return InventoryCategoryTableRow(
                        category: category,
                        productsCount: count,
                        isEven: index.isEven,
                        onEdit: () => onEdit(category),
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
