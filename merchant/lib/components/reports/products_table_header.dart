import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sortable keys for merchant product catalog data table.
enum ProductSortKey {
  name,
  sku,
  barcode,
  status,
  stock,
  lowStock,
  basePrice,
  sellingPrice,
  taxRate,
  category,
  counter,
}

/// Table header for merchant product catalog table.
class ProductsTableHeader extends StatelessComponent {
  final SortState<ProductSortKey> sortState;
  final ValueChanged<ProductSortKey> onSort;

  const ProductsTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        td([.text('Action')]),
        td([.text('Image')]),
        SortableHeader<ProductSortKey>(
          title: 'Product Name',
          sortKey: ProductSortKey.name,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<ProductSortKey>(
          title: 'SKU',
          sortKey: ProductSortKey.sku,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Barcode',
          sortKey: ProductSortKey.barcode,
          currentSort: sortState,
          onSort: onSort,
        ),
        td([.text('Status')]),
        SortableHeader<ProductSortKey>(
          title: 'Stock',
          sortKey: ProductSortKey.stock,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Low Stock',
          sortKey: ProductSortKey.lowStock,
          currentSort: sortState,
          onSort: onSort,
        ),
        td([.text('Stock Monitor')]),
        SortableHeader<ProductSortKey>(
          title: 'Base Price (₹)',
          sortKey: ProductSortKey.basePrice,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Selling Price (₹)',
          sortKey: ProductSortKey.sellingPrice,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Tax Rate (%)',
          sortKey: ProductSortKey.taxRate,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Category',
          sortKey: ProductSortKey.category,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProductSortKey>(
          title: 'Counter',
          sortKey: ProductSortKey.counter,
          currentSort: sortState,
          onSort: onSort,
        ),
        th([]),
      ]),
    ]);
  }
}
