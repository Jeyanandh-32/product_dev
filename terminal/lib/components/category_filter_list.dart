import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/categories_signal.dart';

/// Clean pill-style category filters with letter badge avatars matching the customer web store.
class CategoryFilterList extends SignalWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesState = categoriesSignal.value;
    final selectedCategory = selectedCategorySignal.value;

    return categoriesState.map(
      loading: () => const SizedBox(
        height: 38,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (err, stack) =>
          SizedBox(height: 38, child: Center(child: Text('Error: $err'))),
      data: (categories) {
        final isAllSelected = selectedCategory == null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RowBox(
            style: FlexBoxStyler().spacing(8).mainAxisAlignment(.start),
            children: [
              // 'All Products' Filter Pill Option
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  key: const ValueKey('category-filter-all'),
                  style: BoxStyler()
                      .color(isAllSelected ? Colors.black : Colors.white)
                      .paddingY(5)
                      .paddingLeft(6)
                      .paddingRight(16)
                      .borderAll(
                        color: isAllSelected
                            ? Colors.black
                            : Colors.grey.shade200,
                      )
                      .borderRadiusAll(Radius.circular(999))
                      .shadowOnly(
                        color: Colors.black.withValues(alpha: isAllSelected ? 0.04 : 0.02),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                  onPress: () => selectedCategorySignal.value = null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAllSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '✨',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isAllSelected ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

              ...List.generate(categories.length, (index) {
                final category = categories[index];
                final isSelected = category.id == selectedCategory?.id;
                final initial = category.name.trim().isNotEmpty
                    ? category.name.trim().substring(0, 1).toUpperCase()
                    : '📦';

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    key: ValueKey('category-filter-${category.id}'),
                    style: BoxStyler()
                        .color(isSelected ? Colors.black : Colors.white)
                        .paddingY(5)
                        .paddingLeft(6)
                        .paddingRight(16)
                        .borderAll(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade200,
                        )
                        .borderRadiusAll(Radius.circular(999))
                        .shadowOnly(
                          color: Colors.black.withValues(alpha: isSelected ? 0.04 : 0.02),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                    onPress: () => selectedCategorySignal.value = category,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.grey.shade100,
                          ),
                          alignment: Alignment.center,
                          child: category.imageUrl != null &&
                                  category.imageUrl!.trim().isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: Image.network(
                                    category.imageUrl!,
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Text(
                                      initial,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  initial,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
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
