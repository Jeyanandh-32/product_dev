import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme.dart';

/// Premium dropdown popover select field for terminal modals matching table filter design.
class ModalSelectField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<({String label, T? value})> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final String? hint;

  const ModalSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.hint,
  });

  @override
  State<ModalSelectField<T>> createState() => _ModalSelectFieldState<T>();
}

class _ModalSelectFieldState<T> extends State<ModalSelectField<T>> with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;
  late T? _selectedValue = widget.value;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void didUpdateWidget(ModalSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _selectedValue = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayLabel = widget.isRequired ? '${widget.label}*' : widget.label;
    final current = _selectedValue ?? widget.value;
    final selectedItem = widget.items.where((i) => i.value == current).firstOrNull;
    final displayText = selectedItem?.label ?? widget.hint ?? 'Select an option';
    final hasValue = selectedItem != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(displayLabel, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: widget.isRequired ? const Color(0xFF0F172A) : const Color(0xFF334155))),
        const Gap(7),
        FTheme(
          data: TerminalTheme.light(false),
          child: FPopover(
            control: .managed(controller: _controller),
            popoverAnchor: Alignment.topLeft,
            childAnchor: Alignment.bottomLeft,
            popoverBuilder: (context, controller) => _buildMenu(controller),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: _controller.toggle,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 42,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(10), border: Border.all(color: _isHovered ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(displayText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5, fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400, color: hasValue ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)))),
                      const Gap(8),
                      const Icon(FLucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(FPopoverController controller) {
    final current = _selectedValue ?? widget.value;

    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 280, maxHeight: 240),
      decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4))]),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.items.map((item) {
            final isSelected = item.value == current;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () {
                    setState(() => _selectedValue = item.value);
                    widget.onChanged(item.value);
                    controller.hide();
                  },
                  style: BoxStyler().paddingX(12).paddingY(8).borderRadiusAll(const Radius.circular(8)).color(isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF)).onHovered(isSelected ? BoxStyler() : BoxStyler().color(const Color(0xFFF8FAFC))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item.label, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155)), overflow: TextOverflow.ellipsis)),
                      if (isSelected) ...[const Gap(8), const Icon(FLucideIcons.check, size: 14, color: Color(0xFF0F172A))],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
