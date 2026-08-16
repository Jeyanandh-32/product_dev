import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart.dart';
import 'package:terminal/components/category_filter_list.dart';
import 'package:terminal/components/mobile_cart_floating_button.dart';
import 'package:terminal/components/product_card.dart';
import 'package:terminal/components/product_search_bar.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';

/// Main POS cashier catalog and order terminal screen.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final String _arizoniaFontFamily = GoogleFonts.arizonia().fontFamily!;

  @override
  void initState() {
    super.initState();
    refreshProductsSignal();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SignalBuilder(
      builder: (context) {
        final categories = categoriesSignal.value;
        final products = productsSignal.value;

        if (categories.isLoading || products.isLoading) {
          return const Scaffold(body: Loading());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isDesktop = screenWidth >= 1024;
            final isTablet = screenWidth >= 640 && !isDesktop;

            final crossAxisCount = isDesktop
                ? (screenWidth >= 1400 ? 4 : 3)
                : (isTablet ? 3 : 2);

            return Scaffold(
              backgroundColor: theme.colors.background,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                title: StyledText(
                  'Branding',
                  style: TextStyler()
                      .fontSize(36)
                      .fontFamily(_arizoniaFontFamily)
                      .color(theme.colors.primary),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(color: theme.colors.border, height: 1.0),
                ),
                actions: const [
                  LogoutButton(),
                ],
                actionsPadding: const EdgeInsets.only(right: 16),
              ),
              body: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 20 : 12,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const CategoryFilterList(),
                              const Gap(14),
                              ProductSearchBar(
                                onChanged: (val) =>
                                    searchQuerySignal.value = val.trim().toLowerCase(),
                              ),
                              const Gap(14),
                              Expanded(
                                child: SignalBuilder(
                                  builder: (context) {
                                    final filteredProducts =
                                        filteredProductsSignal.value;

                                    return ExcludeSemantics(
                                      child: ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(
                                          context,
                                        ).copyWith(scrollbars: false),
                                        child: DynamicHeightGridView(
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

/// Logout pill button with full hover animation across background, icon, and text.
class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => logoutTerminal(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFECACA),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FLucideIcons.logOut,
                size: 14,
                color: _isHovered ? Colors.white : const Color(0xFFDC2626),
              ),
              const SizedBox(width: 6),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _isHovered ? Colors.white : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
