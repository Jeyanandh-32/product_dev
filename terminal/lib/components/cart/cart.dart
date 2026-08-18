import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_clear_all_button.dart';
import 'package:terminal/components/cart/cart_empty_state.dart';
import 'package:terminal/components/cart/cart_item_row.dart';
import 'package:terminal/components/cart/cart_summary.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// POS cart sidebar / drawer component with scrollbar and high-readability scroll down indicator.
class Cart extends StatefulWidget {
  final bool isDrawerMode;

  const Cart({super.key, this.isDrawerMode = false});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollIndicator);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollIndicator());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicator);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicator() {
    if (!_scrollController.hasClients) return;
    final canScroll = _scrollController.position.extentAfter > 12;
    if (canScroll != _canScrollDown) setState(() => _canScrollDown = canScroll);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDrawerMode = widget.isDrawerMode;
    final cartWidth = isDrawerMode
        ? double.infinity
        : context.screenWidth < context.breakpoints.xl
            ? 370.0
            : context.screenWidth * .38;

    final cartStyle = FlexBoxStyler()
        .paddingX(isDrawerMode ? 16 : 20)
        .paddingTop(isDrawerMode ? 16 : 20)
        .paddingBottom(isDrawerMode ? 24 : 20)
        .color(isDrawerMode ? const Color(0xFFF8FAFC) : const Color(0xFFFFFFFF))
        .width(cartWidth)
        .borderLeft(color: isDrawerMode ? const Color(0x00000000) : theme.colors.border);

    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollIndicator());

        return ColumnBox(
          style: cartStyle,
          children: [
            if (!isDrawerMode) ...[
              RowBox(
                style: FlexBoxStyler().mainAxisAlignment(MainAxisAlignment.spaceBetween).crossAxisAlignment(CrossAxisAlignment.center),
                children: [
                  StyledText('Current Order', style: TextStyler().fontSize(20).fontWeight(.w900).color(const Color(0xFF000000))),
                  if (cart.items.isNotEmpty) const CartClearAllButton(),
                ],
              ),
              const Gap(16),
            ],
            Expanded(
              child: cart.items.isEmpty ? const CartEmptyState() : _buildScrollableItemList(cart),
            ),
            const CartSummary(),
          ],
        );
      },
    );
  }

  Widget _buildScrollableItemList(CartState cart) {
    return Stack(
      children: [
        TerminalCatalogScrollbar(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(top: widget.isDrawerMode ? 6 : 0, bottom: 24, right: 8),
            itemCount: cart.items.length,
            itemBuilder: (context, index) => CartItemRow(item: cart.items[index]),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: _canScrollDown ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_canScrollDown,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _scrollController.animateTo(_scrollController.offset + 140, duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF334155), width: 1.2),
                        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3))],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FLucideIcons.chevronDown, size: 15, color: Color(0xFFFFFFFF)),
                          Gap(6),
                          Text('More items below', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFFFFFFFF))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
