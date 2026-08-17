import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Main POS cashier catalog and order terminal screen using responsive context extensions.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return SignalBuilder(
      builder: (context) {
        final categories = categoriesSignal.value;
        final products = productsSignal.value;

        if (categories.isLoading || products.isLoading) {
          return const FScaffold(childPad: false, child: Loading());
        }

        final isDesktop = context.isDesktop;
        final crossAxisCount = context.productGridColumns;

        return FScaffold(
          childPad: false,
          header: const TerminalAppBar(),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: isDesktop ? 20 : 12,
                        right: isDesktop ? 12 : 8,
                        top: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const CategoryFilterList(),
                          const Gap(12),
                          const ProductSearchBar(),
                          const Gap(10),
                          Expanded(
                            child: _buildProductGrid(isDesktop, crossAxisCount),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isDesktop) const RepaintBoundary(child: Cart()),
                ],
              ),
              if (!isDesktop) const MobileCartFloatingButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(bool isDesktop, int crossAxisCount) {
    return SignalBuilder(
      builder: (context) {
        final filteredProducts = filteredProductsSignal.value;
        final cart = cartSignal.value;
        final bottomPad = (!isDesktop && cart.items.isNotEmpty) ? 88.0 : 16.0;

        return TerminalCatalogScrollbar(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              right: isDesktop ? 14 : 10,
              bottom: bottomPad,
            ),
            child: DynamicHeightGridView(
              controller: _scrollController,
              crossAxisSpacing: isDesktop ? 12 : 8,
              mainAxisSpacing: isDesktop ? 12 : 8,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              builder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  isMobile: !isDesktop,
                );
              },
              itemCount: filteredProducts.length,
              crossAxisCount: crossAxisCount,
            ),
          ),
        );
      },
    );
  }
}
