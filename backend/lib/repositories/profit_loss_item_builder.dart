import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Item builder and summary totals aggregator for Profit & Loss reporting.
class ProfitLossItemBuilder {
  const ProfitLossItemBuilder._();

  /// Builds individual ProfitLossItem objects for products with recorded sales or wastage.
  static List<ProfitLossItem> buildItems({
    required List<ProductRow> products,
    required Map<String, String> categoryMap,
    required Map<String, String> counterMap,
    required Map<String, int> soldQuantityMap,
    required Map<String, double> collectedPriceMap,
    required Map<String, double> wastageLossMap,
  }) {
    final reportItems = <ProfitLossItem>[];

    for (final p in products) {
      final soldQty = soldQuantityMap[p.id] ?? 0;
      final wastageLoss = wastageLossMap[p.id] ?? 0.0;
      if (soldQty <= 0 && wastageLoss <= 0) continue;

      final collectedPrice = collectedPriceMap[p.id] ?? 0.0;
      final costPrice = (p.basePrice / 100.0) * soldQty;
      final profit = collectedPrice - costPrice - wastageLoss;
      final totalBase = costPrice + wastageLoss;
      final percentage = totalBase > 0 ? (profit / totalBase) * 100.0 : 0.0;

      final categoryName = p.categoryId != null
          ? (categoryMap[p.categoryId!] ?? 'Unassigned')
          : 'Unassigned';
      final counterName = p.counterId != null
          ? (counterMap[p.counterId!] ?? 'Unassigned')
          : 'Unassigned';

      reportItems.add(
        ProfitLossItem(
          productId: p.id,
          productName: p.name,
          categoryName: categoryName,
          counterName: counterName,
          soldQuantity: soldQty,
          costPrice: costPrice,
          collectedPrice: collectedPrice,
          profit: profit,
          profitLossPercentage: percentage,
        ),
      );
    }

    return reportItems;
  }
}
