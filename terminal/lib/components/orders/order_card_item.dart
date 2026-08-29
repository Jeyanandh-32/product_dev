import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/order_card_badges.dart';
import 'package:terminal/components/orders/order_card_customer_info.dart';
import 'package:terminal/components/orders/order_card_footer.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// High-contrast, spacious order card item for the POS orders grid with GPU repaint isolation.
class OrderCardItem extends SignalWidget {
  const OrderCardItem({super.key, required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isSelected = selectedOrderSignal.value?.id == order.id;

    final cardStyle = BoxStyler()
        .color(const Color(0xFFFFFFFF))
        .paddingAll(isDesktop ? 18 : 14)
        .borderRadiusAll(const Radius.circular(16))
        .borderAll(
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
          width: 2.0,
        )
        .shadowOnly(
          color: isSelected ? const Color(0x14000000) : const Color(0x06000000),
          offset: const Offset(0, 2),
          blurRadius: isSelected ? 8 : 4,
        );

    final customer = order.customer;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: PressableBox(
          onPress: onTap,
          style: cardStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledText(
                          '#${order.billNo}',
                          style: TextStyler().fontSize(20).fontWeight(.w900).color(const Color(0xFF000000)),
                        ),
                        const Gap(6),
                        Box(
                          style: BoxStyler()
                              .color(const Color(0xFFF8FAFC))
                              .borderAll(color: const Color(0xFFE2E8F0))
                              .paddingX(6)
                              .paddingY(2)
                              .borderRadiusAll(const Radius.circular(5)),
                          child: Text(
                            order.orderReference,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  OrderCardBadges(order: order),
                ],
              ),
              if (customer != null) ...[
                const Gap(14),
                OrderCardCustomerInfo(customer: customer),
              ],
              Gap(customer != null ? 14 : 16),
              OrderCardFooter(order: order),
            ],
          ),
        ),
      ),
    );
  }
}
