import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/product/category_filter_pill.dart';
import 'package:terminal/signals/categories_signal.dart';

/// Clean pill-style category filters with image avatars matching the customer web store.
class CategoryFilterList extends SignalWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesState = categoriesSignal.value;
    final selectedCategory = selectedCategorySignal.value;

    return categoriesState.map(
      loading: () => SizedBox(
        height: 38,
        child: Center(
          child: FCircularProgress(
            style: FCircularProgressStyle(
              iconStyle: const IconThemeData(
                size: 24,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
      ),
      error: (err, stack) =>
          SizedBox(height: 38, child: Center(child: Text('Error: $err'))),
      data: (categories) {
        final isAllSelected = selectedCategory == null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CategoryFilterPill(
                pillKey: const ValueKey('category-filter-all'),
                label: 'All Products',
                avatarText: '✨',
                isSelected: isAllSelected,
                onTap: () => selectedCategorySignal.value = null,
              ),
              const Gap(8),
              ...categories.map((category) {
                final isSelected = category.id == selectedCategory?.id;
                final initial = category.name.trim().isNotEmpty
                    ? category.name.trim().substring(0, 1).toUpperCase()
                    : '📦';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryFilterPill(
                    label: category.name,
                    avatarText: initial,
                    imageUrl: category.imageUrl,
                    isSelected: isSelected,
                    onTap: () {
                      selectedCategorySignal.value =
                          isSelected ? null : category;
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
