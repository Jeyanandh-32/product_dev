import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart' show RoundedRectangleBorder, showModalBottomSheet;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// POS order history page with 2-column order card grid, pagination, and details sidebar.
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
    if (ordersSignal.value.isLoading) refreshOrdersSignal();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: isDesktop ? 20 : 12,
              right: isDesktop ? 12 : 8,
              top: 12,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const OrdersSourceTabs(),
                const Gap(12),
                const Row(
                  children: [
                    Expanded(child: OrdersSearchBar()),
                    Gap(8),
                    OrdersRefreshButton(),
                  ],
                ),
                const Gap(10),
                const OrdersDateFilterRow(),
                Gap(isDesktop ? 12 : 10),
                Expanded(child: _buildOrdersGrid(isDesktop)),
                const OrdersPagination(),
              ],
            ),
          ),
        ),
        if (isDesktop) const RepaintBoundary(child: OrderDetailsSidebar()),
      ],
    );
  }

  Widget _buildOrdersGrid(bool isDesktop) {
    return SignalBuilder(
      builder: (context) {
        if (ordersSignal.value.isLoading) {
          return const Center(child: Loading(message: 'Fetching orders...'));
        }

        final pagedOrders = pagedOrdersSignal.value;
        if (pagedOrders.isEmpty && filteredOrdersSignal.value.isEmpty) {
          return const OrdersEmptyState();
        }

        return TerminalCatalogScrollbar(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              top: 2,
              right: isDesktop ? 14 : 10,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: DynamicHeightGridView(
                controller: _scrollController,
                crossAxisCount: isDesktop ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: pagedOrders.length,
                builder: (context, index) {
                  final order = pagedOrders[index];
                  return OrderCardItem(
                    order: order,
                    onTap: () => _onOrderTap(context, order, isDesktop),
                  );
                },
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => const FractionallySizedBox(
          heightFactor: 0.88,
          child: OrderDetailsSidebar(isDrawerMode: true),
        ),
      );
      selectedOrderSignal.value = null;
    }
  }
}
