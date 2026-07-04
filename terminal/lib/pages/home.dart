import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/components/cart.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:terminal/providers/cart_provider.dart';
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: RowBox(
                      style: FlexBoxStyler()
                          .spacing(8)
                          .mainAxisAlignment(.start),
                      children: List.generate(categories.value!.length, (
                        index,
                      ) {
                        final category = categories.value![index];
                        final isSelected = category.id == selectedCategory?.id;
                        return PressableBox(
                          style: BoxStyler()
                              .color(
                                isSelected
                                    ? theme.colorScheme.accent
                                    : Colors.white,
                              )
                              .textStyle(
                                .color(
                                  isSelected
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                ).fontSize(14).fontWeight(.w600),
                              )
                              .paddingY(8)
                              .paddingX(20)
                              .borderAll(
                                color: isSelected
                                    ? theme.colorScheme.accent
                                    : Colors.grey.shade200,
                              )
                              .borderRadiusAll(.circular(16)),
                          child: StyledText(category.name),
                          onPress: () => ref
                              .watch(selectedCategoryProvider.notifier)
                              .select(category),
                        );
                      }),
                    ),
                  ),

                  Gap(16),

                  Box(
                    style: BoxStyler()
                        .color(Colors.white)
                        .borderRadiusAll(.circular(999))
                        .borderAll(color: Colors.grey.shade200)
                        .shadowOnly(
                          color: Colors.black.withValues(alpha: 0.03),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        )
                        .paddingLeft(20)
                        .paddingRight(6)
                        .paddingY(4),
                    child: RowBox(
                      style: FlexBoxStyler().crossAxisAlignment(
                        CrossAxisAlignment.center,
                      ),
                      children: [
                        Expanded(
                          child: ShadInput(
                            placeholder: StyledText(
                              'Search something sweet on your mind...',
                              style: TextStyler()
                                  .fontSize(14)
                                  .color(Colors.grey.shade400),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: ShadDecoration(
                              border: ShadBorder.none,
                              secondaryFocusedBorder: ShadBorder.none,
                            ),
                          ),
                        ),
                        Box(
                          style: BoxStyler()
                              .color(const Color(0xFFF3F4F6))
                              .shape(.circle())
                              .paddingAll(8),
                          child: Icon(
                            LucideIcons.search,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(16),

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
                            return _productCard(ref, product, theme);
                          },
                          itemCount: filteredProducts.length,
                          crossAxisCount: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Cart(),
            ],
          );
        },
      ),
    );
  }

  PressableBox _productCard(
    WidgetRef ref,
    Product product,
    ShadThemeData theme,
  ) {
    final cart = ref.watch(cartProvider);
    final isExisting =
        cart.items.indexWhere((item) => item.product.id == product.id) >= 0;

    return PressableBox(
      onPress: () => ref.read(cartProvider.notifier).addItem(product),
      style: BoxStyler()
          .color(isExisting ? theme.colorScheme.accent : Colors.white)
          .paddingAll(12)
          .borderRadiusAll(.circular(16))
          .borderAll(color: theme.colorScheme.border.withValues(alpha: .3))
          .shadowOnly(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1),
            blurRadius: 3,
          )
          .scale(1.0)
          .onPressed(BoxStyler().scale(0.95))
          .animate(.easeInOut(150.ms)),
      child: ColumnBox(
        style: FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.start),
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Box(
                style: BoxStyler().color(const Color(0xFFF1F2F3)),
                child: Image.network(
                  product.imageUrl ?? '',
                  fit: .cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      LucideIcons.image,
                      size: 32,
                 ₹     color: Colors.grey.shade400,
                    );
                  },
                ),
              ),
            ),
          ),

          Gap(12),
          StyledText(
            product.name,
            style: TextStyler()
                .fontSize(14)
                .fontWeight(.w600)
                .color(isExisting ? Colors.white : Colors.grey.shade800)
                .overflow(.ellipsis),
          ),
          Gap(6),
          StyledText(
            '₹${product.sellingPrice}.00',
            style: TextStyler()
                .fontSize(14)
                .fontWeight(.bold)
                .color(isExisting ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
