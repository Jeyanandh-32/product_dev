import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/modals/add_edit_category_modal.dart';
import 'package:merchant/components/modals/add_edit_product_modal.dart';
import 'package:merchant/components/modals/update_stock_modal.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';

/// Modal container host rendering active modal overlays for product management.
class ProductsModalsHost extends StatelessComponent {
  const ProductsModalsHost({super.key});

  @override
  Component build(BuildContext context) {
    final activeModal = activeModalSignal.value;
    final editingProduct = editingProductSignal.value;

    return div([
      if (activeModal == ActiveModal.addCategory)
        AddEditCategoryModal(category: editingCategorySignal.value),
      if (activeModal == ActiveModal.addProduct ||
          activeModal == ActiveModal.editProduct)
        AddEditProductModal(product: editingProduct),
      if (activeModal == ActiveModal.updateStock && editingProduct != null)
        UpdateStockModal(product: editingProduct),
    ]);
  }
}
