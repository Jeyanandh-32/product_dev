import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean empty state for the orders list when no orders are found.
class OrdersEmptyState extends StatelessWidget {
  final String message;

  const OrdersEmptyState({super.key, this.message = 'No orders found'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Box(
              style: BoxStyler()
                  .width(64)
                  .height(64)
                  .borderRadiusAll(const Radius.circular(999))
                  .color(const Color(0xFFF1F5F9))
                  .alignment(Alignment.center),
              child: const Icon(
                FLucideIcons.receipt,
                size: 28,
                color: Color(0xFF94A3B8),
              ),
            ),
            const Gap(16),
            StyledText(
              message,
              style: TextStyler()
                  .fontSize(15)
                  .fontWeight(.w800)
                  .color(TerminalColors.textPrimary),
            ),
            const Gap(4),
            StyledText(
              'Orders matching your filters will appear here',
              style: TextStyler().fontSize(12.5).color(const Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
