import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme.dart';

/// Reusable dropdown popover filter button for table filters.
class InventoryDropdownFilter<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<({String label, T? value})> items;
  final ValueChanged<T?> onSelected;

  const InventoryDropdownFilter({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  @override
  State<InventoryDropdownFilter<T>> createState() => _InventoryDropdownFilterState<T>();
}

class _InventoryDropdownFilterState<T> extends State<InventoryDropdownFilter<T>> with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => widget.items.first,
    );

    final isFiltered = widget.value != null;
    final displayLabel = widget.value == null ? widget.label : '${widget.label}: ${selectedItem.label}';

    return FTheme(
      data: TerminalTheme.light(false),
      child: FPopover(
        control: .managed(controller: _controller),
        popoverAnchor: Alignment.topLeft,
        childAnchor: Alignment.bottomLeft,
        popoverBuilder: (context, controller) => Container(
          width: 170,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
          ),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((item) {
              final isSelected = item.value == widget.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: () {
                      widget.onSelected(item.value);
                      controller.hide();
                    },
                    style: BoxStyler()
                        .paddingX(12)
                        .paddingY(7)
                        .borderRadiusAll(const Radius.circular(8))
                        .color(isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF))
                        .onHovered(isSelected ? BoxStyler() : BoxStyler().color(const Color(0xFFF8FAFC))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                          ),
                        ),
                        if (isSelected) const Icon(FLucideIcons.check, size: 13, color: Color(0xFF0F172A)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _controller.toggle,
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: isFiltered ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: isFiltered ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      displayLabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isFiltered ? FontWeight.w800 : FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const Gap(4),
                  const Icon(FLucideIcons.chevronDown, size: 13, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
