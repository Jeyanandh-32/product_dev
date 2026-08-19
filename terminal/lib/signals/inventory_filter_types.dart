/// Sortable column keys matching merchant products data table.
enum ProductSortKey {
  name('Name'),
  sku('SKU'),
  barcode('Barcode'),
  status('Status'),
  stock('Stock'),
  lowStock('Low Stock'),
  basePrice('Base Price'),
  sellingPrice('Selling Price'),
  taxRate('Tax Rate'),
  category('Category'),
  counter('Counter');

  final String label;
  const ProductSortKey(this.label);
}

/// Directional sorting state with toggle capability.
class ProductSortState {
  final ProductSortKey? key;
  final bool isAscending;

  const ProductSortState({this.key, this.isAscending = true});

  ProductSortState toggle(ProductSortKey newKey) {
    if (key == newKey) {
      if (isAscending) {
        return ProductSortState(key: newKey, isAscending: false);
      }
      return const ProductSortState(key: null, isAscending: true);
    }
    return ProductSortState(key: newKey, isAscending: true);
  }
}

/// Stock health filter options.
enum StockHealthFilter {
  all('All Stock'),
  inStock('In Stock'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock'),
  untracked('Untracked');

  final String label;
  const StockHealthFilter(this.label);
}
