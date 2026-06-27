import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/providers/categories_provider.dart';
import 'package:terminal/providers/products_provider.dart';
import 'package:terminal/providers/ui_providers.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final categories = ref.watch(categoriesProvider);
    final products = ref.watch(productsProvider);

    if (categories.isLoading || products.isLoading) {
      return Scaffold(body: Loading());
    }

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts = products.value?.where((product) {
          return product.category?.id == selectedCategory?.id;
        }).toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: StyledText(
          'Branding',
          style: TextStyler()
              .fontSize(40)
              .fontFamily(GoogleFonts.arizonia().fontFamily!)
              .color(theme.colorScheme.primary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.colorScheme.border, height: 1.0),
        ),
      ),
      body: RowBox(
        children: [
          Expanded(
            child: ColumnBox(
              style: FlexBoxStyler().paddingAll(16),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RowBox(
                    style: FlexBoxStyler().spacing(8).paddingY(4),
                    children: List.generate(categories.value!.length, (index) {
                      final category = categories.value![index];
                      final isSelected = category.id == selectedCategory?.id;
                      return ShadButton(
                        backgroundColor: isSelected
                            ? theme.colorScheme.primary
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                        onPressed: () => ref
                            .read(selectedCategoryProvider.notifier)
                            .select(category),
                        child: StyledText(
                          category.name,
                          style: TextStyler().fontSize(16).fontWeight(.w500),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return PressableBox(
                        onPress: () {},
                        style: BoxStyler()
                            .color(Colors.white)
                            .borderRadiusAll(const Radius.circular(8))
                            .paddingAll(12)
                            .shadowOnly(
                              color: Colors.black.withValues(alpha: 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            )
                            .onHovered(BoxStyler().color(Colors.grey.shade50))
                            .onPressed(BoxStyler().color(Colors.grey.shade100)),
                        child: Center(
                          child: StyledText(
                            product.name,
                            style: TextStyler().fontSize(16).fontWeight(.w500),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ColumnBox(
              style: FlexBoxStyler()
                  .color(Colors.white)
                  .borderLeft(color: theme.colorScheme.border),
            ),
          ),
        ],
      ),
    );
  }
}
