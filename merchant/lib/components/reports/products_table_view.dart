import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/product_table_row.dart';
import 'package:merchant/components/reports/products_table_header.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:models/models.dart';

/// Scrollable table view of products with filtering, sorting, and action triggers.
class ProductsTableView extends StatelessComponent {
  final List<Product> products;
  final SortState<ProductSortKey> sortState;
  final ValueChanged<ProductSortKey> onSort;
  final bool? statusFilter;
  final bool? stockMonitorFilter;

  const ProductsTableView({
    super.key,
    required this.products,
    required this.sortState,
    required this.onSort,
    this.statusFilter,
    this.stockMonitorFilter,
  });

  @override
  Component build(BuildContext context) {
    final filtered = products.where((prod) {
      if (statusFilter != null && prod.isActive != statusFilter) {
        return false;
      }
      if (stockMonitorFilter != null &&
          prod.stock?.stockMonitor != stockMonitorFilter) {
        return false;
      }
      return true;
    }).toList();

    final sortedProducts = sortItems<Product, ProductSortKey>(
      items: filtered,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        ProductSortKey.name => item.name.toLowerCase(),
        ProductSortKey.sku => (item.sku ?? '').toLowerCase(),
        ProductSortKey.barcode => (item.barcode ?? '').toLowerCase(),
        ProductSortKey.status => item.isActive ? 1 : 0,
        ProductSortKey.stock => item.stock?.quantity ?? 0,
        ProductSortKey.lowStock => item.stock?.lowStockThreshold ?? 0,
        ProductSortKey.basePrice => item.basePrice,
        ProductSortKey.sellingPrice => item.sellingPrice,
        ProductSortKey.taxRate => item.taxRate,
        ProductSortKey.category => (item.category?.name ?? '').toLowerCase(),
        ProductSortKey.counter => (item.counter?.name ?? '').toLowerCase(),
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          ProductsTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final product in sortedProducts)
              ProductTableRow(
                product: product,
                onEdit: () {
                  editingProductSignal.value = product;
                  activeModalSignal.value = ActiveModal.editProduct;
                },
                onUpdateStock: () {
                  editingProductSignal.value = product;
                  activeModalSignal.value = ActiveModal.updateStock;
                },
              ),
          ]),
        ],
      ),
    ]);
  }
}
