import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_clear_all_button.dart';
import 'package:terminal/components/cart/cart_empty_state.dart';
import 'package:terminal/components/cart/cart_item_row.dart';
import 'package:terminal/components/cart/cart_summary.dart';
import 'package:terminal/components/product/scroll_down_indicator_pill.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

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
    final isDrawerMode = widget.isDrawerMode;

    final cartStyle = FlexBoxStyler()
        .paddingX(isDrawerMode ? 16 : 20)
        .paddingTop(isDrawerMode ? 16 : 20)
        .paddingBottom(isDrawerMode ? 24 : 20)
        .color(isDrawerMode ? TerminalColors.pageBackground : TerminalColors.surface)
        .borderLeft(color: isDrawerMode ? TerminalColors.transparent : TerminalColors.border);

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
                  StyledText('Current Order', style: TextStyler().fontSize(20).fontWeight(.w900).color(TerminalColors.textBlack)),
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
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 24, right: 14),
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemRow(item: cart.items[index]),
            ),
          ),
        ),
        ScrollDownIndicatorPill(visible: _canScrollDown, controller: _scrollController),
      ],
    );
  }
}
