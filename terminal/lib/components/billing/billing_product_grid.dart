import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/product/product_card.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Responsive catalog product grid with scrollbar and empty state.
class BillingProductGrid extends StatelessWidget {
  final ScrollController scrollController;
  final bool isMobile;
  final int crossAxisCount;

  const BillingProductGrid({
    super.key,
    required this.scrollController,
    required this.isMobile,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final filteredProducts = filteredProductsSignal.value;
        final cart = cartSignal.value;
        final bottomPad = (isMobile && cart.items.isNotEmpty) ? 88.0 : 16.0;

        if (filteredProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FLucideIcons.searchX,
                  size: 36,
                  color: TerminalColors.textMuted,
                ),
                Gap(12),
                Text(
                  'No matching products found',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: TerminalColors.textPrimary,
                  ),
                ),
                Gap(4),
                Text(
                  'Try changing your category filter or search keyword.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: TerminalColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return TerminalCatalogScrollbar(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              top: 2,
              right: isMobile ? 10 : 14,
              bottom: bottomPad,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                controller: scrollController,
                physics: isMobile
                    ? const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      )
                    : const ClampingScrollPhysics(),
                slivers: [
                  SliverDynamicHeightGridView(
                    crossAxisSpacing: isMobile ? 8 : 12,
                    mainAxisSpacing: isMobile ? 8 : 12,
                    builder: (context, index) => ProductCard(
                      key: ValueKey(filteredProducts[index].id),
                      product: filteredProducts[index],
                      isMobile: isMobile,
                    ),
                    itemCount: filteredProducts.length,
                    crossAxisCount: crossAxisCount,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
