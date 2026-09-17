import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_details_item_row.dart';
import 'package:terminal/components/product/scroll_down_indicator_pill.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';

/// Scrollable list of order item rows with scrollbar and scroll-down indicator.
class OrderDetailsItemsList extends StatefulWidget {
  final Order order;

  const OrderDetailsItemsList({super.key, required this.order});

  @override
  State<OrderDetailsItemsList> createState() => _OrderDetailsItemsListState();
}

class _OrderDetailsItemsListState extends State<OrderDetailsItemsList> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollIndicator);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateScrollIndicator(),
    );
  }

  @override
  void didUpdateWidget(OrderDetailsItemsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateScrollIndicator(),
    );
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
    return Stack(
      children: [
        TerminalCatalogScrollbar(
          controller: _scrollController,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 6, right: 14, bottom: 20),
              itemCount: widget.order.items.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) => OrderDetailsItemRow(
                item: widget.order.items[index],
                index: index,
              ),
            ),
          ),
        ),
        ScrollDownIndicatorPill(
          visible: _canScrollDown,
          controller: _scrollController,
        ),
      ],
    );
  }
}
