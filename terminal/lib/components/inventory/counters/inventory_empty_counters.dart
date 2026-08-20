import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';

/// Clean, informative read-only empty state for inventory counters table and list.
class InventoryEmptyCounters extends StatelessWidget {
  final bool isFiltered;

  const InventoryEmptyCounters({
    super.key,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isFiltered ? FLucideIcons.searchX : FLucideIcons.store,
                size: 28,
                color: isFiltered ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const Gap(16),
            Text(
              isFiltered ? 'No Matching Counters' : 'No Counters in Inventory',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              textAlign: TextAlign.center,
            ),
            const Gap(6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                isFiltered
                    ? 'No counters match the selected search keyword or active status filter.'
                    : 'Counters are configured and managed by the store merchant in the Merchant Dashboard.',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            if (isFiltered) ...[
              const Gap(20),
              UnconstrainedBox(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: _resetFilters,
                    style: BoxStyler()
                        .color(const Color(0xFFFFFFFF))
                        .borderAll(color: const Color(0xFFE2E8F0))
                        .paddingX(20)
                        .height(40)
                        .borderRadiusAll(const Radius.circular(10))
                        .alignment(Alignment.center)
                        .onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
                    child: const Text(
                      'Reset Filters',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    counterSearchSignal.value = '';
    counterStatusFilterSignal.value = null;
    counterPageSignal.value = 1;
  }
}
