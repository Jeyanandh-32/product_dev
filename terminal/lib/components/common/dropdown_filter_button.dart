import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/common/dropdown_filter_variant.dart';
import 'package:terminal/theme.dart';

/// Trigger button for the dropdown popover filter.
class DropdownFilterButton extends StatelessWidget {
  /// Creates a styled trigger button for dropdown filters.
  const DropdownFilterButton({
    super.key,
    required this.displayLabel,
    required this.isFiltered,
    required this.variant,
    required this.onTap,
    required this.onClear,
    this.height,
  });

  /// Text displayed on the button.
  final String displayLabel;

  /// Whether the filter is actively filtering (non-null value).
  final bool isFiltered;

  /// Presentation variant (standard or pill).
  final DropdownFilterVariant variant;

  /// Callback when the button is tapped to open/close menu.
  final VoidCallback onTap;

  /// Callback to reset the filter value.
  final VoidCallback onClear;

  /// Custom button height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isPill = variant == DropdownFilterVariant.pill;
    final bgColor = isPill
        ? (isFiltered ? TerminalColors.textPrimary : TerminalColors.surface)
        : (isFiltered
            ? TerminalColors.secondaryBackground
            : TerminalColors.surface);
    final fgColor = (isPill && isFiltered)
        ? TerminalColors.textWhite
        : TerminalColors.textPrimary;
    final borderColor =
        isFiltered ? TerminalColors.textPrimary : TerminalColors.border;
    final btnHeight = height ?? (isPill ? 38.0 : 34.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .height(btnHeight)
            .color(bgColor)
            .paddingX(isPill ? 14 : 10)
            .borderRadiusAll(Radius.circular(isPill ? 999 : 8))
            .borderAll(color: borderColor)
            .alignment(Alignment.center)
            .onHovered(
              isFiltered && isPill
                  ? BoxStyler()
                  : BoxStyler().color(TerminalColors.pageBackground),
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                displayLabel,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isPill ? 13.5 : 12,
                  fontWeight: isFiltered ? FontWeight.w800 : FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ),
            const Gap(4),
            Icon(
              FLucideIcons.chevronDown,
              size: isPill ? 14 : 13,
              color: isPill && isFiltered
                  ? fgColor
                  : TerminalColors.textSecondary,
            ),
            if (isPill && isFiltered) ...[
              const Gap(6),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClear,
                  child: Icon(FLucideIcons.x, size: 13.5, color: fgColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
