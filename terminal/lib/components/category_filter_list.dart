import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/categories_signal.dart';

class CategoryFilterList extends SignalWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final categoriesState = categoriesSignal.value;
    final selectedCategory = selectedCategorySignal.value;

    return categoriesState.map(
      loading: () => const SizedBox(
        height: 38,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) =>
          SizedBox(height: 38, child: Center(child: Text('Error: $err'))),
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        if (selectedCategory == null ||
            !categories.any((c) => c.id == selectedCategory.id)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selectedCategorySignal.value = categories.first;
          });
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RowBox(
            style: FlexBoxStyler().spacing(8).mainAxisAlignment(.start),
            children: List.generate(categories.length, (index) {
              final category = categories[index];
              final isSelected = category.id == selectedCategory?.id;
              return PressableBox(
                style: BoxStyler()
                    .color(isSelected ? theme.colorScheme.accent : Colors.white)
                    .textStyle(
                      TextStyler()
                          .color(
                            isSelected ? Colors.white : Colors.grey.shade800,
                          )
                          .fontSize(14)
                          .fontWeight(.w600),
                    )
                    .paddingY(8)
                    .paddingX(20)
                    .borderAll(
                      color: isSelected
                          ? theme.colorScheme.accent
                          : Colors.grey.shade200,
                    )
                    .borderRadiusAll(.circular(16)),
                onPress: () => selectedCategorySignal.value = category,
                child: StyledText(category.name),
              );
            }),
          ),
        );
      },
    );
  }
}
