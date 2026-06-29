import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
      return Scaffold(body: Loading());
    }

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts =
        products.value?.where((product) {
          return product.category?.id == selectedCategory?.id;
        }).toList() ??
        [];

    final List<List<dynamic>> chunkedRows = [];
    for (var i = 0; i < filteredProducts.length; i += 3) {
      final end = (i + 3 < filteredProducts.length)
          ? i + 3
          : filteredProducts.length;
      chunkedRows.add(filteredProducts.sublist(i, end));
    }

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
      body: RowBox(
        children: [
          Expanded(
            child: ColumnBox(
              style: FlexBoxStyler()
                  .paddingAll(16)
                  .crossAxisAlignment(CrossAxisAlignment.start),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RowBox(
                    style: FlexBoxStyler()
                        .spacing(8)
                        .paddingY(4)
                        .mainAxisAlignment(MainAxisAlignment.start),
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
                const Gap(16),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? Center(
                          child: StyledText(
                            'No products available in this category.',
                            style: TextStyler()
                                .fontSize(16)
                                .color(Colors.grey.shade600),
                          ),
                        )
                      : SingleChildScrollView(
                          child: ColumnBox(
                            style: FlexBoxStyler().spacing(12),
                            children: chunkedRows.map((rowItems) {
                              return RowBox(
                                style: FlexBoxStyler().spacing(12),
                                children: List.generate(3, (index) {
                                  if (index < rowItems.length) {
                                    final product = rowItems[index];
                                    return Expanded(
                                      child: PressableBox(
                                        onPress: () {},
                                        style: BoxStyler()
                                            .color(Colors.white)
                                            .borderRadiusAll(
                                              const Radius.circular(8),
                                            )
                                            .paddingAll(12)
                                            .shadowOnly(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              offset: const Offset(0, 1),
                                              blurRadius: 2,
                                            )
                                            .onHovered(
                                              BoxStyler().color(
                                                Colors.grey.shade50,
                                              ),
                                            )
                                            .onPressed(
                                              BoxStyler().color(
                                                Colors.grey.shade100,
                                              ),
                                            ),
                                        child: ColumnBox(
                                          style: FlexBoxStyler()
                                              .crossAxisAlignment(
                                                CrossAxisAlignment.start,
                                              ),
                                          children: [
                                            if (product.imageUrl != null)
                                              AspectRatio(
                                                aspectRatio: 1.0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    product.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.grey.shade100,
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          LucideIcons.image,
                                                          color: Colors.grey.shade400,
                                                          size: 32,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 8),
                                            Text(
                                              product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Gap(4),
                                            StyledText(
                                              '${product.stock?.quantity ?? 0} - left',
                                              style: TextStyler()
                                                  .color(
                                                    theme.colorScheme.accent,
                                                  )
                                                  .fontSize(16)
                                                  .fontWeight(.w500),
                                            ),
                                            const Gap(4),
                                            StyledText(
                                              '₹${product.sellingPrice}',
                                              style: TextStyler()
                                                  .fontSize(16)
                                                  .fontWeight(.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Expanded(child: SizedBox());
                                  }
                                }),
                              );
                            }).toList(),
                          ),
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
