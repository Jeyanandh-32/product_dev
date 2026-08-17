import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

/// Order history log page for the current POS session using Forui and Mix.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Order History'),
        prefixes: [
          FHeaderAction.back(
            onPress: () => GoRouter.maybeOf(context)?.pop(),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Box(
                style: BoxStyler()
                    .width(64)
                    .height(64)
                    .borderRadiusAll(const Radius.circular(999))
                    .color(const Color(0xFFF3F4F6))
                    .alignment(Alignment.center),
                child: const Icon(
                  FLucideIcons.receipt,
                  size: 28,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Gap(16),
              StyledText(
                'No orders placed yet',
                style: TextStyler()
                    .fontSize(16)
                    .fontWeight(.w800)
                    .color(const Color(0xFF000000)),
              ),
              const Gap(6),
              StyledText(
                'Completed orders will appear here for reprint and review',
                style: TextStyler()
                    .fontSize(13)
                    .color(const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
