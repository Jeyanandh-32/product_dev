import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Dropdown menu container for [ModalSelectField].
class ModalSelectMenu<T> extends StatelessWidget {
  final List<({String label, T? value})> items;
  final T? currentValue;
  final ValueChanged<T?> onSelect;
  final VoidCallback onDismiss;

  const ModalSelectMenu({
    super.key,
    required this.items,
    required this.currentValue,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 280, maxHeight: 240),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            final isSelected = item.value == currentValue;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () {
                    onSelect(item.value);
                    onDismiss();
                  },
                  style: BoxStyler()
                      .paddingX(12)
                      .paddingY(8)
                      .borderRadiusAll(const Radius.circular(8))
                      .color(isSelected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF))
                      .onHovered(isSelected ? BoxStyler() : BoxStyler().color(const Color(0xFFF8FAFC))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected) ...[
                        const Gap(8),
                        const Icon(FLucideIcons.check, size: 14, color: Color(0xFF0F172A)),
                      ],
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
