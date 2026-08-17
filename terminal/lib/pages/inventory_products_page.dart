import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/components.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/products_signal.dart';

/// Read-only inventory products overview page using Forui.
class InventoryProductsPage extends SignalWidget {
  const InventoryProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = productsSignal.value.value ?? [];

    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Inventory Products'),
        prefixes: const [
          TerminalBackButton(),
        ],
      ),
      child: products.isEmpty
          ? Center(
              child: StyledText(
                'No products in catalog',
                style: TextStyler().fontSize(14).color(const Color(0xFF6B7280)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                final product = products[index];
                return Box(
                  style: BoxStyler()
                      .paddingAll(14)
                      .color(const Color(0xFFFFFFFF))
                      .borderRadiusAll(const Radius.circular(12))
                      .borderAll(color: const Color(0xFFE5E7EB)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            product.name,
                            style: TextStyler()
                                .fontSize(14)
                                .fontWeight(.w700)
                                .color(const Color(0xFF000000)),
                          ),
                          if (product.sku != null) ...[
                            const Gap(2),
                            StyledText(
                              'SKU: ${product.sku}',
                              style: TextStyler()
                                  .fontSize(12)
                                  .color(const Color(0xFF6B7280)),
                            ),
                          ],
                        ],
                      ),
                      StyledText(
                        '₹${product.sellingPrice.toStringAsFixed(2)}',
                        style: TextStyler()
                            .fontSize(14)
                            .fontWeight(.w800)
                            .color(const Color(0xFF000000)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
