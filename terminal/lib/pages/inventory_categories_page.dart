import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/categories/inventory_categories.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Full-featured, responsive POS Inventory Categories management screen.
class InventoryCategoriesPage extends StatefulWidget {
  const InventoryCategoriesPage({super.key});

  @override
  State<InventoryCategoriesPage> createState() => _InventoryCategoriesPageState();
}

class _InventoryCategoriesPageState extends State<InventoryCategoriesPage> {
  @override
  void initState() {
    super.initState();
    if (categoriesSignal.value.value == null) refreshCategoriesSignal();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return SignalBuilder(
      builder: (context) {
        final categoriesAsync = categoriesSignal.value;
        if (categoriesAsync.isLoading && categoriesAsync.value == null) {
          return const Center(child: Loading(message: 'Loading categories...'));
        }

        final allCategories = categoriesAsync.value ?? [];
        final pagedCategories = pagedCategoriesSignal.value;
        final allProducts = productsSignal.value.value ?? [];

        return Padding(
          padding: EdgeInsets.all(isDesktop ? 16 : 10),
          child: Material(
            color: const Color(0xFFFFFFFF),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: InventoryCategoriesToolbar(
                    onAddCategory: () => _openModal(context),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: pagedCategories.isEmpty
                      ? InventoryEmptyCategories(
                          isFiltered: allCategories.isNotEmpty,
                          onAddCategory: () => _openModal(context),
                        )
                      : (isDesktop
                          ? _buildDesktopTable(pagedCategories, allProducts)
                          : _buildMobileList(pagedCategories, allProducts)),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const InventoryCategoriesPaginationToolbar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<Category> categories, List<Product> allProducts) {
    return InventoryCategoriesDataTable(
      categories: categories,
      allProducts: allProducts,
      onEdit: (cat) => _openModal(context, category: cat),
    );
  }

  Widget _buildMobileList(List<Category> categories, List<Product> allProducts) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const Gap(10),
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = allProducts.where((p) => p.category?.id == category.id).length;
        return InventoryCategoryCardMobile(
          category: category,
          productCount: count,
          onEdit: () => _openModal(context, category: category),
        );
      },
    );
  }

  void _openModal(BuildContext context, {Category? category}) {
    showDialog<void>(
      context: context,
      builder: (_) => AddEditCategoryDialog(category: category),
    );
  }
}
