import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/providers/categories_provider.dart';
import 'package:terminal/providers/ui_providers.dart';

class CategoryFilterList extends ConsumerWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      loading: () => const SizedBox(
        height: 38,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) =>
          SizedBox(height: 38, child: Center(child: Text('Error: $err'))),
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();
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
                onPress: () => ref
                    .read(selectedCategoryProvider.notifier)
                    .select(category),
                child: StyledText(category.name),
              );
            }),
          ),
        );
      },
    );
  }
}
