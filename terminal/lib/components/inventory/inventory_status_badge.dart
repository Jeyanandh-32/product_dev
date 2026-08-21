import 'package:flutter/widgets.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Pill badge displaying active/inactive status using TerminalColors tokens.
class InventoryStatusBadge extends StatelessWidget {
  final bool isActive;
  const InventoryStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? TerminalColors.activeBadgeBg : TerminalColors.inactiveBadgeBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? TerminalColors.activeBadgeBorder : TerminalColors.inactiveBadgeBorder,
          width: 0.8,
        ),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        softWrap: false,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: isActive ? TerminalColors.activeBadgeText : TerminalColors.inactiveBadgeText,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Pill badge displaying stock monitor on/off state using TerminalColors tokens.
class InventoryMonitorBadge extends StatelessWidget {
  final bool isEnabled;
  const InventoryMonitorBadge({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isEnabled ? TerminalColors.activeBadgeBg : TerminalColors.inactiveBadgeBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isEnabled ? TerminalColors.activeBadgeBorder : TerminalColors.inactiveBadgeBorder,
          width: 0.8,
        ),
      ),
      child: Text(
        isEnabled ? 'ON' : 'OFF',
        softWrap: false,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: isEnabled ? TerminalColors.activeBadgeText : TerminalColors.inactiveBadgeText,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
