import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/category_card.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_category_modal.dart';
import 'package:merchant/providers/categories_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Categories extends StatelessComponent {
  const Categories({super.key});

  @override
  Component build(BuildContext context) {
    final categories = context.watch(categoriesProvider);
    final activeModal = context.watch(activeModalProvider);
    final editingCategory = context.watch(editingCategoryProvider);

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs',
      [
        if (activeModal == ActiveModal.addCategory)
          const AddEditCategoryModal(),
        if (activeModal == ActiveModal.editCategory)
          AddEditCategoryModal(category: editingCategory),

        div(
          classes:
              'w-full border-b border-border-medium flex items-center justify-between p-4 gap-2',
          [
            Searchbar(
              placeholder: 'Search Categories...',
              classes: 'flex-1 sm:flex-none sm:w-64',
            ),
            AddButton(
              name: 'Add Category',
              onClick: () {
                context.read(editingCategoryProvider.notifier).state = null;
                context.read(activeModalProvider.notifier).state =
                    ActiveModal.addCategory;
              },
            ),
          ],
        ),

        if (categories.isLoading)
          Loading(text: 'Loading categories...', fullScreen: false)
        else if (categories.hasValue &&
            categories.value != null &&
            categories.value!.isEmpty)
          CenteredMessage(message: 'No Categories were added.')
        else
          div(
            classes:
                'flex-1 min-h-0 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 m-4 pr-2 gap-4 overflow-y-auto auto-rows-max',
            [
              for (final category in categories.value!)
                CategoryCard(
                  category: category,
                  onEdit: () {
                    context.read(editingCategoryProvider.notifier).state =
                        category;
                    context.read(activeModalProvider.notifier).state =
                        ActiveModal.editCategory;
                  },
                ),
            ],
          ),
      ],
    );
  }
}
