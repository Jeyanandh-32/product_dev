import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_details_empty_state.dart';
import 'package:terminal/components/orders/order_details_header.dart';
import 'package:terminal/components/orders/order_details_item_row.dart';
import 'package:terminal/components/orders/order_details_summary_card.dart';
import 'package:terminal/components/product/scroll_down_indicator_pill.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// POS order details sidebar matching the exact layout, aesthetics, and summary card of [Cart].
class OrderDetailsSidebar extends StatefulWidget {
  final bool isDrawerMode;

  const OrderDetailsSidebar({super.key, this.isDrawerMode = false});

  @override
  State<OrderDetailsSidebar> createState() => _OrderDetailsSidebarState();
}

class _OrderDetailsSidebarState extends State<OrderDetailsSidebar> {
  final ScrollController _itemsScrollController = ScrollController();
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _itemsScrollController.addListener(_updateScrollIndicator);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateScrollIndicator(),
    );
  }

  @override
  void dispose() {
    _itemsScrollController.removeListener(_updateScrollIndicator);
    _itemsScrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicator() {
    if (!_itemsScrollController.hasClients) return;
    final canScroll = _itemsScrollController.position.extentAfter > 12;
    if (canScroll != _canScrollDown) setState(() => _canScrollDown = canScroll);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDrawerMode = widget.isDrawerMode;
    final sidebarWidth = isDrawerMode
        ? double.infinity
        : context.screenWidth < context.breakpoints.xl
        ? 370.0
        : context.screenWidth * .38;

    final sidebarStyle = FlexBoxStyler()
        .paddingX(isDrawerMode ? 16 : 20)
        .paddingTop(isDrawerMode ? 12 : 20)
        .paddingBottom(isDrawerMode ? 24 : 20)
        .color(isDrawerMode ? const Color(0xFFF8FAFC) : const Color(0xFFFFFFFF))
        .width(sidebarWidth)
        .borderLeft(
          color: isDrawerMode ? const Color(0x00000000) : theme.colors.border,
        );

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isDrawerMode ? 24 : 0),
      ),
      child: SignalBuilder(
        builder: (context) {
          final order = selectedOrderSignal.value;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _updateScrollIndicator(),
          );

          return ColumnBox(
            style: sidebarStyle,
            children: [
              if (isDrawerMode)
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              if (order == null) ...[
                RowBox(
                  style: FlexBoxStyler()
                      .mainAxisAlignment(MainAxisAlignment.spaceBetween)
                      .crossAxisAlignment(CrossAxisAlignment.center),
                  children: [
                    StyledText(
                      'Order Details',
                      style: TextStyler()
                          .fontSize(20)
                          .fontWeight(.w900)
                          .color(TerminalColors.textPrimary),
                    ),
                  ],
                ),
                const Gap(16),
                const Expanded(child: OrderDetailsEmptyState()),
              ] else ...[
                OrderDetailsHeader(
                  order: order,
                  onClose: () {
                    selectedOrderSignal.value = null;
                    if (isDrawerMode) Navigator.of(context).maybePop();
                  },
                ),
                const Gap(12),
                Expanded(child: _buildItemsList(order)),
                OrderDetailsSummaryCard(order: order),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemsList(Order order) {
    return Stack(
      children: [
        TerminalCatalogScrollbar(
          controller: _itemsScrollController,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.separated(
              controller: _itemsScrollController,
              padding: const EdgeInsets.only(top: 6, right: 14, bottom: 20),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) =>
                  OrderDetailsItemRow(item: order.items[index], index: index),
            ),
          ),
        ),
        ScrollDownIndicatorPill(
          visible: _canScrollDown,
          controller: _itemsScrollController,
        ),
      ],
    );
  }
}
