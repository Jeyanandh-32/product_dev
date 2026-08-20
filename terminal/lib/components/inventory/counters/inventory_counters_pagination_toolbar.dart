import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/theme.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean docked pagination toolbar for Inventory Counters.
class InventoryCountersPaginationToolbar extends StatefulWidget {
  const InventoryCountersPaginationToolbar({super.key});

  @override
  State<InventoryCountersPaginationToolbar> createState() => _InventoryCountersPaginationToolbarState();
}

class _InventoryCountersPaginationToolbarState extends State<InventoryCountersPaginationToolbar> with SingleTickerProviderStateMixin {
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
    return SignalBuilder(builder: (context) {
      final total = filteredCountersSignal.value.length;
      final page = counterPageSignal.value;
      final entries = counterEntriesSignal.value;
      final totalPages = counterTotalPagesSignal.value;
      final isMobile = context.isMobile;
      final start = total == 0 ? 0 : ((page - 1) * entries) + 1;
      final end = (page * entries).clamp(0, total);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              _buildEntriesMenu(entries),
              if (!isMobile) ...[const Gap(10), Text('Showing $start–$end of $total', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))],
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              _buildNavButton(FLucideIcons.chevronLeft, page > 1, () => counterPageSignal.value = page - 1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$page / $totalPages', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)))),
              _buildNavButton(FLucideIcons.chevronRight, page < totalPages, () => counterPageSignal.value = page + 1),
            ]),
          ],
        ),
      );
    });
  }

  Widget _buildEntriesMenu(int currentEntries) {
    return FTheme(
      data: TerminalTheme.light(false),
      child: FPopover(
        control: .managed(controller: _entriesController),
        popoverAnchor: Alignment.bottomLeft,
        childAnchor: Alignment.topLeft,
        popoverBuilder: (context, controller) => Container(
          width: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 4))]),
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [10, 25, 50, 100].map((size) {
              final isSelected = size == currentEntries;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () {
                    counterEntriesSignal.value = size;
                    counterPageSignal.value = 1;
                    controller.hide();
                  },
                  style: BoxStyler().width(double.infinity).height(32).borderRadiusAll(const Radius.circular(8)).color(isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF)).paddingX(8).alignment(Alignment.centerLeft).onHovered(BoxStyler().color(isSelected ? const Color(0xFFE2E8F0) : const Color(0xFFF8FAFC))),
                  child: Text('$size items', style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF000000) : const Color(0xFF334155))),
                ),
              );
            }).toList(),
          ),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: () => _entriesController.toggle(),
            style: BoxStyler().height(30).paddingX(8).borderRadiusAll(const Radius.circular(8)).borderAll(color: const Color(0xFFE2E8F0)).color(const Color(0xFFFFFFFF)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$currentEntries / page', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const Gap(4),
                const Icon(FLucideIcons.chevronDown, size: 12, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, bool enabled, VoidCallback onTap) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: PressableBox(
        onPress: enabled ? onTap : () {},
        style: BoxStyler().width(28).height(28).borderRadiusAll(const Radius.circular(6)).color(enabled ? const Color(0xFFF1F5F9) : const Color(0xFFFAFAFA)).borderAll(color: enabled ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9)).alignment(Alignment.center).onHovered(enabled ? BoxStyler().color(const Color(0xFFE2E8F0)) : BoxStyler()),
        child: Icon(icon, size: 14, color: enabled ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1)),
      ),
    );
  }
}
