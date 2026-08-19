import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/theme.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean docked pagination toolbar for Inventory matching terminal aesthetic.
class InventoryPaginationToolbar extends StatefulWidget {
  const InventoryPaginationToolbar({super.key});

  @override
  State<InventoryPaginationToolbar> createState() => _InventoryPaginationToolbarState();
}

class _InventoryPaginationToolbarState extends State<InventoryPaginationToolbar> with SingleTickerProviderStateMixin {
  late final FPopoverController _entriesController;

  @override
  void initState() {
    super.initState();
    _entriesController = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _entriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final total = filteredInventoryProductsSignal.value.length;
        final page = inventoryPageSignal.value;
        final entries = inventoryEntriesSignal.value;
        final totalPages = inventoryTotalPagesSignal.value;
        final isMobile = context.isMobile;
        final start = total == 0 ? 0 : ((page - 1) * entries) + 1;
        final end = (page * entries).clamp(0, total);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEntriesMenu(entries),
                  if (!isMobile) ...[
                    const Gap(10),
                    Text('Showing $start–$end of $total', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavButton(FLucideIcons.chevronLeft, page > 1, () => inventoryPageSignal.value = page - 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$page / $totalPages', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  ),
                  _buildNavButton(FLucideIcons.chevronRight, page < totalPages, () => inventoryPageSignal.value = page + 1),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEntriesMenu(int entries) => FTheme(
        data: TerminalTheme.light(false),
        child: FPopover(
          control: .managed(controller: _entriesController),
          popoverAnchor: Alignment.topLeft,
          childAnchor: Alignment.bottomLeft,
          popoverBuilder: (_, controller) => Container(
            width: 130,
            decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))]),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [10, 25, 50, 100].map((size) {
                final isCurrent = size == entries;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: () {
                      inventoryEntriesSignal.value = size;
                      inventoryPageSignal.value = 1;
                      controller.hide();
                    },
                    style: BoxStyler().paddingX(12).paddingY(7).color(isCurrent ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Show $size', style: TextStyle(fontSize: 12.5, fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600, color: const Color(0xFF0F172A))),
                        if (isCurrent) const Icon(FLucideIcons.check, size: 13, color: Color(0xFF0F172A)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: _entriesController.toggle,
              style: BoxStyler().height(32).color(const Color(0xFFF8FAFC)).borderRadiusAll(const Radius.circular(8)).borderAll(color: const Color(0xFFE2E8F0)).paddingX(10).alignment(Alignment.center),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Show $entries', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const Gap(4),
                  const Icon(FLucideIcons.chevronDown, size: 12, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildNavButton(IconData icon, bool isEnabled, VoidCallback onTap) => MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: PressableBox(
          onPress: isEnabled ? onTap : null,
          style: BoxStyler().width(32).height(32).borderRadiusAll(const Radius.circular(8)).borderAll(color: isEnabled ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9)).color(isEnabled ? const Color(0xFFFFFFFF) : const Color(0xFFF8FAFC)).alignment(Alignment.center),
          child: Icon(icon, size: 15, color: isEnabled ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1)),
        ),
      );
}
