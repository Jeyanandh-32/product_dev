import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/components/cart.dart';
import 'package:terminal/components/category_filter_list.dart';
import 'package:terminal/components/product_card.dart';
import 'package:terminal/components/product_search_bar.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/providers/auth_provider.dart';
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
      return const Scaffold(body: Loading());
    }

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts =
        products.value?.where((product) {
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
        actions: [
          ShadButton.destructive(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            child: const StyledText('Log Out'),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 24),
      ),
      body: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          return RowBox(
            children: [
              ColumnBox(
                style: FlexBoxStyler()
                    .width(screenWidth * .60)
                    .onMobile(.width(.infinity))
                    .paddingAll(16),
                children: [
                  const CategoryFilterList(),
                  const Gap(16),
                  const ProductSearchBar(),
                  const Gap(16),
                  Expanded(
                    child: ExcludeSemantics(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: DynamicHeightGridView(
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                          builder: (context, index) {
                            final product = filteredProducts[index];
                            return ProductCard(product: product);
                          },
                          itemCount: filteredProducts.length,
                          crossAxisCount: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Cart(),
            ],
          );
        },
      ),
    );
  }
}
