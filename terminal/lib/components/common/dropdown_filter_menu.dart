import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Popover menu container displaying selectable filter options.
class DropdownFilterMenu<T> extends StatelessWidget {
  /// Creates a dropdown menu for selecting filter values.
  const DropdownFilterMenu({
    super.key,
    required this.items,
    required this.currentValue,
    required this.onSelected,
    required this.controller,
  });

  /// Available options to display in the menu list.
  final List<({String label, T? value})> items;

  /// Currently selected filter value.
  final T? currentValue;

  /// Callback executed when an option is selected.
  final ValueChanged<T?> onSelected;

  /// Popover controller to toggle/close the menu on selection.
  final FPopoverController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      decoration: BoxDecoration(
        color: TerminalColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TerminalColors.border),
        boxShadow: const [
          BoxShadow(
            color: TerminalColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(4),
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
                  onSelected(item.value);
                  controller.hide();
                },
                style: BoxStyler()
                    .paddingX(12)
                    .paddingY(7)
                    .borderRadiusAll(const Radius.circular(8))
                    .color(
                      isSelected
                          ? TerminalColors.secondaryBackground
                          : TerminalColors.surface,
                    )
                    .onHovered(
                      isSelected
                          ? BoxStyler()
                          : BoxStyler().color(TerminalColors.pageBackground),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: TerminalColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        FLucideIcons.check,
                        size: 13,
                        color: TerminalColors.textPrimary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
