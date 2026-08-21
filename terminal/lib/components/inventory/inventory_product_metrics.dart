import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';

/// Price, stock quantity, base price, tax, and SKU metrics summary for mobile product card.
class InventoryProductMetrics extends StatelessWidget {
  final Product product;
  const InventoryProductMetrics({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final stock = product.stock;
    final qty = stock?.quantity ?? 0;
    final isLow =
        (stock?.stockMonitor ?? false) &&
        qty <= (stock?.lowStockThreshold ?? 0);
    final sku = product.sku;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRICE', style: _metricHeaderStyle),
                const Gap(2),
                Text(
                  '₹${product.sellingPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('STOCK', style: _metricHeaderStyle),
                const Gap(2),
                Text(
                  '$qty units',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: isLow
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Base: ₹${product.basePrice.toStringAsFixed(2)} (${product.taxRate.toStringAsFixed(0)}% Tax)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (sku != null && sku.isNotEmpty) ...[
              const Gap(8),
              Text(
                'SKU: $sku',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  static const _metricHeaderStyle = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: Color(0xFF64748B),
  );
}
