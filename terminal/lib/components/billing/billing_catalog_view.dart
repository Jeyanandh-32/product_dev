import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/billing/billing_empty_catalog.dart';
import 'package:terminal/components/cart/cart.dart';
import 'package:terminal/components/cart/mobile_cart_floating_button.dart';
import 'package:terminal/components/product/category_filter_list.dart';
import 'package:terminal/components/product/product_card.dart';
import 'package:terminal/components/product/product_search_bar.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Main POS cashier catalog and cart view.
class BillingCatalogView extends StatefulWidget {
  const BillingCatalogView({super.key});

  @override
  State<BillingCatalogView> createState() => _BillingCatalogViewState();
}

class _BillingCatalogViewState extends State<BillingCatalogView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshProductsSignal();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(builder: (context) {
      final categories = categoriesSignal.value;
      final products = productsSignal.value;
      if (categories.isLoading || products.isLoading) {
        return const Center(child: Loading(message: 'Loading products...'));
      }
      final allProducts = products.value ?? [];
      final isDesktop = context.isDesktop;
      final crossAxisCount = context.productGridColumns;

      return Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: allProducts.isEmpty
                    ? const BillingEmptyCatalog()
                    : Padding(
                        padding: EdgeInsets.only(left: isDesktop ? 20 : 12, right: isDesktop ? 12 : 8, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const CategoryFilterList(),
                            const Gap(12),
                            const ProductSearchBar(),
                            Gap(isDesktop ? 10 : 8),
                            Expanded(child: _buildProductGrid(isDesktop, crossAxisCount)),
                          ],
                        ),
                      ),
              ),
              if (isDesktop) const RepaintBoundary(child: Cart()),
            ],
          ),
          if (!isDesktop) const MobileCartFloatingButton(),
        ],
      );
    });
  }

  Widget _buildProductGrid(bool isDesktop, int crossAxisCount) {
    return SignalBuilder(builder: (context) {
      final filteredProducts = filteredProductsSignal.value;
      final cart = cartSignal.value;
      final bottomPad = (!isDesktop && cart.items.isNotEmpty) ? 88.0 : 16.0;

      if (filteredProducts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FLucideIcons.searchX, size: 36, color: Color(0xFF94A3B8)),
              Gap(12),
              Text('No matching products found', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              Gap(4),
              Text('Try changing your category filter or search keyword.', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
            ],
          ),
        );
      }

      return TerminalCatalogScrollbar(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(top: 2, right: isDesktop ? 14 : 10, bottom: bottomPad),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: CustomScrollView(
              controller: _scrollController,
              physics: isDesktop ? const ClampingScrollPhysics() : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverDynamicHeightGridView(
                  crossAxisSpacing: isDesktop ? 12 : 8,
                  mainAxisSpacing: isDesktop ? 12 : 8,
                  builder: (context, index) => ProductCard(key: ValueKey(filteredProducts[index].id), product: filteredProducts[index], isMobile: !isDesktop),
                  itemCount: filteredProducts.length,
                  crossAxisCount: crossAxisCount,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
