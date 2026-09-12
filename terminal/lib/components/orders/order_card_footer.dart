import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Date, item count, and price footer for order cards.
class OrderCardFooter extends StatelessWidget {
  const OrderCardFooter({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final rawHour = order.createdAt.hour;
    final period = rawHour >= 12 ? 'PM' : 'AM';
    final hour12 = rawHour % 12 == 0 ? 12 : rawHour % 12;
    final min = order.createdAt.minute.toString().padLeft(2, '0');
    final day = order.createdAt.day.toString().padLeft(2, '0');
    final month = order.createdAt.month.toString().padLeft(2, '0');
    final dateTimeStr =
        '$day/$month/${order.createdAt.year}, $hour12:$min $period';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(
                FLucideIcons.calendar,
                size: 13.5,
                color: Color(0xFF64748B),
              ),
              const Gap(5),
              Expanded(
                child: Text(
                  '$dateTimeStr • ${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        StyledText(
          '₹${order.grandTotal.toStringAsFixed(2)}',
          style: TextStyler()
              .fontSize(18)
              .fontWeight(.w900)
              .color(TerminalColors.textPrimary),
        ),
      ],
    );
  }
}
