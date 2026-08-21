import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/counters/inventory_counters.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Full-featured, responsive read-only POS Inventory Counters overview screen.
class InventoryCountersPage extends StatefulWidget {
  const InventoryCountersPage({super.key});

  @override
  State<InventoryCountersPage> createState() => _InventoryCountersPageState();
}

class _InventoryCountersPageState extends State<InventoryCountersPage> {
  @override
  void initState() {
    super.initState();
    if (countersSignal.value.value == null) refreshCountersSignal();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return SignalBuilder(
      builder: (context) {
        final countersAsync = countersSignal.value;
        if (countersAsync.isLoading && countersAsync.value == null) {
          return const Center(child: Loading(message: 'Loading counters...'));
        }

        final allCounters = countersAsync.value ?? [];
        final pagedCounters = pagedCountersSignal.value;
        final allProducts = productsSignal.value.value ?? [];

        return Padding(
          padding: EdgeInsets.all(isMobile ? 10 : 16),
          child: Material(
            color: TerminalColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: TerminalColors.border, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(14),
                  child: InventoryCountersToolbar(),
                ),
                const Divider(height: 1, color: TerminalColors.border),
                Expanded(
                  child: pagedCounters.isEmpty
                      ? InventoryEmptyCounters(
                          isFiltered: allCounters.isNotEmpty,
                        )
                      : (isMobile
                          ? _buildMobileList(pagedCounters, allProducts)
                          : _buildTable(pagedCounters, allProducts)),
                ),
                const Divider(height: 1, color: TerminalColors.border),
                const InventoryCountersPaginationToolbar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(List<Counter> counters, List<Product> allProducts) {
    return InventoryCountersDataTable(
      counters: counters,
      allProducts: allProducts,
    );
  }

  Widget _buildMobileList(List<Counter> counters, List<Product> allProducts) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: counters.length,
      separatorBuilder: (_, _) => const Gap(10),
      itemBuilder: (context, index) {
        final counter = counters[index];
        final count = allProducts.where((p) => p.counter?.id == counter.id).length;
        return InventoryCounterCardMobile(
          counter: counter,
          productCount: count,
        );
      },
    );
  }
}
