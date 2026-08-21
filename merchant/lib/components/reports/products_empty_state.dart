import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';

/// Guided empty state component for products catalog when empty.
class ProductsEmptyState extends StatelessComponent {
  const ProductsEmptyState({super.key, required this.hasCategories});

  final bool hasCategories;

  @override
  Component build(BuildContext context) {
    if (!hasCategories) {
      return div(
        classes: 'flex-1 flex flex-col items-center justify-center p-8 text-center max-w-md mx-auto my-auto gap-4',
        [
          div(
            classes: 'w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-1',
            [FolderPlus(classes: 'w-8 h-8 text-primary')],
          ),
          h3(classes: 'text-lg font-bold text-base-content', [.text('Create your first category')]),
          p(
            classes: 'text-sm text-gray-500 -mt-2',
            [.text('Every product belongs to a category. Set up your first category to start adding products.')],
          ),
          button(
            classes: 'btn btn-primary rounded-xl px-6 gap-2 mt-2 shadow-xs cursor-pointer',
            onClick: () {
              editingCategorySignal.value = null;
              activeModalSignal.value = ActiveModal.addCategory;
            },
            [Plus(classes: 'w-4 h-4'), .text('Create First Category')],
          ),
        ],
      );
    }

    return div(
      classes: 'flex-1 flex flex-col items-center justify-center p-8 text-center max-w-md mx-auto my-auto gap-4',
      [
        div(
          classes: 'w-16 h-16 rounded-2xl bg-base-200 flex items-center justify-center text-gray-400 mb-1',
          [Package(classes: 'w-8 h-8 text-gray-400')],
        ),
        h3(classes: 'text-lg font-bold text-base-content', [.text('No products added yet')]),
        p(
          classes: 'text-sm text-gray-500 -mt-2',
          [.text('Start building your store catalog by adding your first product.')],
        ),
        button(
          classes: 'btn btn-primary rounded-xl px-6 gap-2 mt-2 shadow-xs cursor-pointer',
          onClick: () {
            editingProductSignal.value = null;
            activeModalSignal.value = ActiveModal.addProduct;
          },
          [Plus(classes: 'w-4 h-4'), .text('Add Product')],
        ),
      ],
    );
  }
}
