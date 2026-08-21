import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean stock quantity text display with normal weight and black color.
class InventoryStockBadge extends StatelessWidget {
  final Stock? stock;

  const InventoryStockBadge({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final qty = stock?.quantity ?? 0;
    return Text(
      '$qty',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: TerminalColors.textPrimary,
      ),
    );
  }
}
