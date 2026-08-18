import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme.dart';

/// Clean pill dropdown filter for Payment Mode, Payment Status, and Order Status.
class OrderDropdownFilter<T> extends StatefulWidget {
  final String title;
  final T? currentValue;
  final List<({String label, T? value})> items;
  final ValueChanged<T?> onSelected;

  const OrderDropdownFilter({
    super.key,
    required this.title,
    required this.currentValue,
    required this.items,
    required this.onSelected,
  });

  @override
  State<OrderDropdownFilter<T>> createState() => _OrderDropdownFilterState<T>();
}

class _OrderDropdownFilterState<T> extends State<OrderDropdownFilter<T>>
    with SingleTickerProviderStateMixin {
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
    final isSelected = widget.currentValue != null;
    final activeItem = widget.items.firstWhere(
      (item) => item.value == widget.currentValue,
      orElse: () => widget.items.first,
    );

    final label = isSelected ? '${widget.title}: ${activeItem.label}' : widget.title;
    final bgColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final fgColor = isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
    final borderColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);

    return FTheme(
      data: TerminalTheme.light(false),
      child: FPopover(
        control: .managed(controller: _controller),
        popoverAnchor: Alignment.topLeft,
        childAnchor: Alignment.bottomLeft,
        popoverBuilder: (context, controller) => _buildMenu(controller),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: _controller.toggle,
            style: BoxStyler()
                .height(38)
                .color(bgColor)
                .paddingX(14)
                .borderRadiusAll(const Radius.circular(999))
                .borderAll(color: borderColor)
                .shadowOnly(color: const Color(0x08000000), offset: const Offset(0, 1), blurRadius: 2)
                .alignment(Alignment.center)
                .onHovered(
                  isSelected
                      ? BoxStyler()
                      : BoxStyler().color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1)),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledText(label, style: TextStyler().fontSize(13.5).fontWeight(isSelected ? .w800 : .w700).color(fgColor)),
                const Gap(4),
                Icon(FLucideIcons.chevronDown, size: 14, color: fgColor),
                if (isSelected) ...[
                  const Gap(6),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onSelected(null),
                      child: Icon(FLucideIcons.x, size: 13.5, color: fgColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(FPopoverController controller) {
    return Box(
      style: BoxStyler()
          .width(180)
          .color(const Color(0xFFFFFFFF))
          .borderRadiusAll(const Radius.circular(12))
          .borderAll(color: const Color(0xFFE2E8F0))
          .paddingAll(6)
          .shadowOnly(color: const Color(0x14000000), offset: const Offset(0, 4), blurRadius: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.items.map((item) {
          final isItemActive = widget.currentValue == item.value;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: () {
                widget.onSelected(item.value);
                controller.toggle();
              },
              style: BoxStyler()
                  .color(isItemActive ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF))
                  .paddingY(8)
                  .paddingX(10)
                  .borderRadiusAll(const Radius.circular(8))
                  .alignment(Alignment.centerLeft)
                  .onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(item.label,
                      style: TextStyler().fontSize(13.5).fontWeight(isItemActive ? .w800 : .w600).color(const Color(0xFF000000))),
                  if (isItemActive) const Icon(FLucideIcons.check, size: 14, color: Color(0xFF000000)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
