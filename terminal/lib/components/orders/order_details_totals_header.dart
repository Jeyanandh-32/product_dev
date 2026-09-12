import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_breakdown_popover.dart';
import 'package:terminal/theme.dart';

/// Header for order totals section with 'Order Summary' title and floating 'Details' popover button.
class OrderDetailsTotalsHeader extends StatefulWidget {
  final Order order;

  const OrderDetailsTotalsHeader({super.key, required this.order});

  @override
  State<OrderDetailsTotalsHeader> createState() =>
      _OrderDetailsTotalsHeaderState();
}

class _OrderDetailsTotalsHeaderState extends State<OrderDetailsTotalsHeader>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Order Summary',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: TerminalColors.textPrimary,
            ),
          ),
        ),
        const Gap(8),
        FTheme(
          data: TerminalTheme.light(false),
          child: FPopover(
            control: .managed(controller: _controller),
            popoverAnchor: Alignment.bottomRight,
            childAnchor: Alignment.topRight,
            popoverBuilder: (context, controller) => OrderBreakdownPopover(
              order: widget.order,
              onClose: _controller.toggle,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: _controller.toggle,
                style: BoxStyler()
                    .paddingX(10)
                    .paddingY(5)
                    .borderRadiusAll(const Radius.circular(8))
                    .color(const Color(0xFFF1F5F9))
                    .borderAll(color: const Color(0xFFE2E8F0))
                    .alignment(Alignment.center)
                    .onHovered(BoxStyler().color(TerminalColors.primary)),
                child: Row(
                  children: [
                    StyledText(
                      'Details',
                      style: TextStyler()
                          .fontSize(12.5)
                          .fontWeight(.w800)
                          .color(const Color(0xFF0F172A))
                          .onHovered(
                            TextStyler().color(const Color(0xFFFFFFFF)),
                          ),
                    ),
                    const Gap(4),
                    StyledIcon(
                      icon: FLucideIcons.chevronUp,
                      style: IconStyler()
                          .size(13.5)
                          .color(const Color(0xFF0F172A))
                          .onHovered(
                            IconStyler().color(const Color(0xFFFFFFFF)),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
