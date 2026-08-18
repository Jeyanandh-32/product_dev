import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Full-featured, responsive POS Orders management screen.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (ordersSignal.value.value == null) refreshOrdersSignal();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return SignalBuilder(
      builder: (context) {
        final ordersAsync = ordersSignal.value;

        return Stack(
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
                        const OrdersSourceTabs(),
                        const Gap(10),
                        const OrdersDateFilterRow(),
                        const Gap(10),
                        const OrdersSearchBar(),
                        Gap(isDesktop ? 12 : 10),
                        Expanded(child: _buildOrdersGrid(isDesktop, ordersAsync)),
                        const Gap(12),
                        const OrdersPagination(),
                        const Gap(12),
                      ],
                    ),
                  ),
                ),
                if (isDesktop) const RepaintBoundary(child: OrderDetailsSidebar()),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersGrid(bool isDesktop, AsyncState<List<Order>> ordersAsync) {
    if (ordersAsync.isLoading && ordersAsync.value == null) {
      return const Center(child: Loading(message: 'Loading orders...'));
    }

    return SignalBuilder(
      builder: (context) {
        final pagedOrders = pagedOrdersSignal.value;
        if (pagedOrders.isEmpty) return const OrdersEmptyState();

        return TerminalCatalogScrollbar(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(top: 2, right: isDesktop ? 14 : 10),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                controller: _scrollController,
                cacheExtent: 800.0,
                physics: isDesktop
                    ? const ClampingScrollPhysics()
                    : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverDynamicHeightGridView(
                    crossAxisCount: isDesktop ? 2 : 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    itemCount: pagedOrders.length,
                    builder: (context, index) {
                      final order = pagedOrders[index];
                      return OrderCardItem(order: order, onTap: () => _onOrderTap(context, order, isDesktop));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onOrderTap(BuildContext context, Order order, bool isDesktop) async {
    selectedOrderSignal.value = order;
    if (!isDesktop) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        backgroundColor: const Color(0xFFF8FAFC),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (ctx) => const FractionallySizedBox(heightFactor: 0.88, child: OrderDetailsSidebar(isDrawerMode: true)),
      );
      selectedOrderSignal.value = null;
    }
  }
}
