import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_details_header_badges.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Senior-friendly header for the Order Details sidebar with bill info, customer info, and status badges.
class OrderDetailsHeader extends StatelessWidget {
  final Order order;
  final VoidCallback? onClose;

  const OrderDetailsHeader({super.key, required this.order, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  StyledText(
                    'Bill #${order.billNo}',
                    style: TextStyler()
                        .fontSize(20)
                        .fontWeight(.w900)
                        .color(const Color(0xFF000000)),
                  ),
                  const Gap(10),
                  Flexible(
                    child: Box(
                      style: BoxStyler()
                          .color(const Color(0xFFF8FAFC))
                          .borderAll(color: const Color(0xFFE2E8F0))
                          .paddingX(9)
                          .paddingY(4)
                          .borderRadiusAll(const Radius.circular(6)),
                      child: StyledText(
                        order.orderReference,
                        style: TextStyler()
                            .fontSize(12)
                            .fontWeight(.w800)
                            .color(const Color(0xFF334155)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            _closeButton(),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            const Icon(
              FLucideIcons.calendar,
              size: 14,
              color: Color(0xFF64748B),
            ),
            const Gap(6),
            StyledText(
              _formatDate(order.createdAt),
              style: TextStyler()
                  .fontSize(12.5)
                  .fontWeight(.w700)
                  .color(const Color(0xFF64748B)),
            ),
          ],
        ),
        if (order.customer case final customer?) ...[
          const Gap(8),
          _customerRow(customer),
        ],
        const Gap(10),
        OrderDetailsHeaderBadges(order: order),
      ],
    );
  }

  Widget _closeButton() => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: PressableBox(
      onPress: onClose ?? () => selectedOrderSignal.value = null,
      style: BoxStyler()
          .width(34)
          .height(34)
          .color(const Color(0xFFF1F5F9))
          .borderRadiusAll(const Radius.circular(999))
          .alignment(Alignment.center)
          .onHovered(BoxStyler().color(const Color(0xFF000000))),
      child: StyledIcon(
        icon: FLucideIcons.x,
        style: IconStyler()
            .size(16)
            .color(const Color(0xFF0F172A))
            .onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
      ),
    ),
  );

  Widget _customerRow(Customer customer) => Row(
    children: [
      const Icon(FLucideIcons.user, size: 14, color: Color(0xFF64748B)),
      const Gap(6),
      StyledText(
        customer.name,
        style: TextStyler()
            .fontSize(13.5)
            .fontWeight(.w800)
            .color(const Color(0xFF0F172A)),
      ),
      const Gap(8),
      StyledText(
        '•',
        style: TextStyler().fontSize(12).color(const Color(0xFF94A3B8)),
      ),
      const Gap(8),
      StyledText(
        customer.mobileNumber,
        style: TextStyler()
            .fontSize(13)
            .fontWeight(.w600)
            .color(const Color(0xFF64748B)),
      ),
    ],
  );

  String _formatDate(DateTime dt) {
    final hr = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    final m = dt.minute.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$d/$mo/${dt.year}, $hr:$m $p';
  }
}
