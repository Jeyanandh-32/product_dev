import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/navigation_signal.dart';

/// Clean, centered empty state when the store catalog has zero products.
class BillingEmptyCatalog extends StatelessWidget {
  const BillingEmptyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(FLucideIcons.packageOpen, size: 28, color: Color(0xFF475569)),
            ),
            const Gap(16),
            const Text(
              'No Products in Catalog',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              textAlign: TextAlign.center,
            ),
            const Gap(6),
            const Text(
              'Add products from the Inventory tab to start adding items to the cart and billing.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            UnconstrainedBox(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () => activeTerminalPageSignal.value = TerminalNavPage.inventoryProducts,
                  style: BoxStyler()
                      .color(const Color(0xFF000000))
                      .paddingX(20)
                      .height(40)
                      .borderRadiusAll(const Radius.circular(10))
                      .alignment(Alignment.center)
                      .onHovered(BoxStyler().color(const Color(0xFF1E293B))),
                  child: const Text(
                    'Go to Inventory',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
