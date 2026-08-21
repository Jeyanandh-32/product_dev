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
import 'package:terminal/theme/terminal_colors.dart';
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
      final isMobile = context.isMobile;
      final crossAxisCount = context.productGridColumns;

      return Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: isMobile ? 1 : 6,
                child: allProducts.isEmpty
                    ? const BillingEmptyCatalog()
                    : Padding(
                        padding: EdgeInsets.only(left: isMobile ? 12 : 20, right: isMobile ? 8 : 12, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const CategoryFilterList(),
                            const Gap(12),
                            const ProductSearchBar(),
                            Gap(isMobile ? 8 : 10),
                            Expanded(child: _buildProductGrid(isMobile, crossAxisCount)),
                          ],
                        ),
                      ),
              ),
              if (!isMobile)
                const Expanded(
                  flex: 4,
                  child: RepaintBoundary(child: Cart()),
                ),
            ],
          ),
          if (isMobile) const MobileCartFloatingButton(),
        ],
      );
    });
  }

  Widget _buildProductGrid(bool isMobile, int crossAxisCount) {
    return SignalBuilder(builder: (context) {
      final filteredProducts = filteredProductsSignal.value;
      final cart = cartSignal.value;
      final bottomPad = (isMobile && cart.items.isNotEmpty) ? 88.0 : 16.0;

      if (filteredProducts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FLucideIcons.searchX, size: 36, color: TerminalColors.textMuted),
              Gap(12),
              Text('No matching products found', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: TerminalColors.textPrimary)),
              Gap(4),
              Text('Try changing your category filter or search keyword.', style: TextStyle(fontSize: 12.5, color: TerminalColors.textSecondary)),
            ],
          ),
        );
      }

      return TerminalCatalogScrollbar(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(top: 2, right: isMobile ? 10 : 14, bottom: bottomPad),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: CustomScrollView(
              controller: _scrollController,
              physics: isMobile ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) : const ClampingScrollPhysics(),
              slivers: [
                SliverDynamicHeightGridView(
                  crossAxisSpacing: isMobile ? 8 : 12,
                  mainAxisSpacing: isMobile ? 8 : 12,
                  builder: (context, index) => ProductCard(key: ValueKey(filteredProducts[index].id), product: filteredProducts[index], isMobile: isMobile),
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
