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

/// Main POS cashier catalog and order terminal screen.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    refreshProductsSignal();
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isDesktop = screenWidth >= 1024;
            final isTablet = screenWidth >= 640 && !isDesktop;

            final crossAxisCount = isDesktop
                ? (screenWidth >= 1400 ? 4 : 3)
                : (isTablet ? 3 : 2);

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
                            right: isDesktop ? 20 : 12,
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
                                child: SignalBuilder(
                                  builder: (context) {
                                    final filteredProducts =
                                        filteredProductsSignal.value;
                                    final cart = cartSignal.value;
                                    final bottomPad =
                                        (!isDesktop && cart.items.isNotEmpty)
                                            ? 88.0
                                            : 16.0;

                                    return ExcludeSemantics(
                                      child: ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(
                                          context,
                                        ).copyWith(scrollbars: false),
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: bottomPad,
                                            ),
                                            child: DynamicHeightGridView(
                                              crossAxisSpacing:
                                                  isDesktop ? 12 : 8,
                                              mainAxisSpacing:
                                                  isDesktop ? 12 : 8,
                                              physics:
                                                  const BouncingScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics(),
                                              ),
                                              builder: (context, index) {
                                                final product =
                                                    filteredProducts[index];
                                                return ProductCard(
                                                  key: ValueKey(product.id),
                                                  product: product,
                                                  isMobile: !isDesktop,
                                                );
                                              },
                                              itemCount:
                                                  filteredProducts.length,
                                              crossAxisCount: crossAxisCount,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
      },
    );
  }
}
