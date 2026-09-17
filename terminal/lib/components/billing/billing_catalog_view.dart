import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/billing/billing_empty_catalog.dart';
import 'package:terminal/components/billing/billing_product_grid.dart';
import 'package:terminal/components/cart/cart.dart';
import 'package:terminal/components/cart/mobile_cart_floating_button.dart';
import 'package:terminal/components/product/category_filter_list.dart';
import 'package:terminal/components/product/product_search_bar.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
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
  late final void Function() _disposeNavEffect;
  late final void Function() _disposeCartSanitizeEffect;
  TerminalNavPage? _lastPage;

  @override
  void initState() {
    super.initState();
    _lastPage = activeTerminalPageSignal.value;
    _disposeNavEffect = effect(() {
      final current = activeTerminalPageSignal.value;
      if (current == TerminalNavPage.billing && _lastPage != null && _lastPage != TerminalNavPage.billing) {
        refreshProductsSignal();
        refreshCategoriesSignal();
      }
      _lastPage = current;
    });
    _disposeCartSanitizeEffect = effect(() {
      final prods = productsSignal.value.value;
      final cats = categoriesSignal.value.value;
      if (prods != null && cats != null) {
        CartController.sanitizeCart(availableProducts: prods, availableCategories: cats);
      }
    });
  }

  @override
  void dispose() {
    _disposeNavEffect();
    _disposeCartSanitizeEffect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final categories = categoriesSignal.value;
        final products = productsSignal.value;
        if (categories.isLoading || products.isLoading) {
          return const Center(child: Loading(message: 'Loading products...'));
        }
        final allProducts = products.value ?? [];
        final allCategories = categories.value ?? [];
        final activeCategoryIds = {for (final c in allCategories) if (c.isActive) c.id};
        final hasActiveProducts = allProducts.any(
          (p) => p.isActive && (p.category == null || activeCategoryIds.contains(p.category?.id)),
        );
        final isMobile = context.isMobile;
        final crossAxisCount = context.productGridColumns;

        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: isMobile ? 1 : 6,
                  child: !hasActiveProducts
                      ? const BillingEmptyCatalog()
                      : Padding(
                          padding: EdgeInsets.only(
                            left: isMobile ? 12 : 20,
                            right: isMobile ? 8 : 12,
                            top: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const CategoryFilterList(),
                              const Gap(12),
                              const ProductSearchBar(),
                              Gap(isMobile ? 8 : 10),
                              Expanded(
                                child: BillingProductGrid(
                                  scrollController: _scrollController,
                                  isMobile: isMobile,
                                  crossAxisCount: crossAxisCount,
                                ),
                              ),
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
      },
    );
  }
}
