import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme.dart';

/// Popover dropdown menu for selecting entries per page in pagination toolbars.
class PaginationEntriesMenu extends StatelessWidget {
  /// Creates an entries-per-page popover selector.
  const PaginationEntriesMenu({
    super.key,
    required this.currentEntries,
    required this.controller,
    required this.onEntriesSelected,
    this.options = const [10, 25, 50, 100],
  });

  /// Currently selected entries per page.
  final int currentEntries;

  /// Popover controller managing menu open/close state.
  final FPopoverController controller;

  /// Callback when a new entries per page value is chosen.
  final ValueChanged<int> onEntriesSelected;

  /// Selectable page size options.
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: TerminalTheme.light(false),
      child: FPopover(
        control: .managed(controller: controller),
        popoverAnchor: Alignment.topLeft,
        childAnchor: Alignment.bottomLeft,
        popoverBuilder: (_, popoverCtrl) => Container(
          width: 130,
          decoration: BoxDecoration(
            color: TerminalColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TerminalColors.border),
            boxShadow: const [
              BoxShadow(
                color: TerminalColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((size) {
              final isCurrent = size == currentEntries;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () {
                    onEntriesSelected(size);
                    popoverCtrl.hide();
                  },
                  style: BoxStyler()
                      .paddingX(12)
                      .paddingY(7)
                      .color(
                        isCurrent
                            ? TerminalColors.secondaryBackground
                            : TerminalColors.surface,
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Show $size',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isCurrent
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: TerminalColors.textPrimary,
                        ),
                      ),
                      if (isCurrent)
                        const Icon(
                          FLucideIcons.check,
                          size: 13,
                          color: TerminalColors.textPrimary,
                        ),
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
            onPress: controller.toggle,
            style: BoxStyler()
                .height(32)
                .color(TerminalColors.pageBackground)
                .borderRadiusAll(const Radius.circular(8))
                .borderAll(color: TerminalColors.border)
                .paddingX(10)
                .alignment(Alignment.center),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Show $currentEntries',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TerminalColors.textPrimary,
                  ),
                ),
                const Gap(4),
                const Icon(
                  FLucideIcons.chevronDown,
                  size: 12,
                  color: TerminalColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
