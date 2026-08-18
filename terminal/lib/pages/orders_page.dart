import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
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
    return SignalBuilder(
      builder: (context) {
        if (ordersSignal.value.isLoading) {
          return const FScaffold(childPad: false, child: Loading());
        }

        final isDesktop = context.isDesktop;

        return FScaffold(
          childPad: false,
          header: const TerminalAppBar(),
          child: Row(
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
                      const Gap(12),
                      Row(
                        children: [
                          const Expanded(child: OrdersSearchBar()),
                          const Gap(8),
                          _buildRefreshButton(),
                        ],
                      ),
                      const Gap(10),
                      const OrdersDateFilterRow(),
                      const Gap(12),
                      Expanded(child: _buildOrdersGrid(isDesktop)),
                      const OrdersPagination(),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const RepaintBoundary(child: OrderDetailsSidebar()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRefreshButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: refreshOrdersSignal,
        style: BoxStyler()
            .width(44)
            .height(44)
            .color(const Color(0xFFFFFFFF))
            .borderRadiusAll(const Radius.circular(999))
            .borderAll(color: const Color(0xFFE2E8F0))
            .shadowOnly(color: const Color(0x08000000), offset: const Offset(0, 1), blurRadius: 3)
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(const Color(0xFF000000))),
        child: StyledIcon(
          icon: FLucideIcons.rotateCw,
          style: IconStyler().size(16.5).color(const Color(0xFF0F172A)).onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
        ),
      ),
    );
  }

  Widget _buildOrdersGrid(bool isDesktop) {
    return SignalBuilder(
      builder: (context) {
        final pagedOrders = pagedOrdersSignal.value;
        if (pagedOrders.isEmpty && filteredOrdersSignal.value.isEmpty) {
          return const OrdersEmptyState();
        }

        return TerminalCatalogScrollbar(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(right: isDesktop ? 14 : 10),
            child: DynamicHeightGridView(
              controller: _scrollController,
              crossAxisCount: isDesktop ? 2 : 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: pagedOrders.length,
              builder: (context, index) {
                final order = pagedOrders[index];
                return OrderCardItem(
                  order: order,
                  onTap: () => selectedOrderSignal.value = order,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
