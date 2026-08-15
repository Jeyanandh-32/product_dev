import 'package:models/models.dart';

typedef DashboardTopProduct = ({
  String rank,
  String name,
  String category,
  String units,
  String revenue,
});

class DashboardDataParser {
  const DashboardDataParser._();

  static List<DashboardTopProduct> parseTopProducts(List<dynamic>? rawTop) {
    if (rawTop == null) return const [];
    final topList = <DashboardTopProduct>[];
    for (var i = 0; i < rawTop.length; i++) {
      final map = rawTop[i] as Map<String, dynamic>;
      final totalRevPaise = (map['totalRevenue'] as num?)?.toDouble() ?? 0.0;
      final qtySold = map['quantitySold'] as int? ?? 0;
      topList.add((
        rank: '${i + 1}',
        name: map['name'] as String? ?? '',
        category: map['category'] as String? ?? 'General',
        units: '$qtySold sold',
        revenue: '₹ ${(totalRevPaise / 100.0).toStringAsFixed(2)}',
      ));
    }
    return topList;
  }

  static List<Product> parseLowStockProducts(
    List<dynamic>? rawLow,
    String storeId,
  ) {
    if (rawLow == null) return const [];
    return rawLow.map((json) {
      final map = json as Map<String, dynamic>;
      final pricePaise = (map['sellingPrice'] as num?)?.toDouble() ?? 0.0;
      final qty = map['quantity'] as int? ?? 0;
      final thresh = map['lowStockThreshold'] as int? ?? 5;
      final now = DateTime.now();
      return Product(
        id: map['id'] as String? ?? '',
        merchantId: '',
        name: map['name'] as String? ?? '',
        basePrice: pricePaise / 100.0,
        sellingPrice: pricePaise / 100.0,
        taxRate: 0.0,
        isActive: true,
        category: Category(
          id: '',
          merchantId: '',
          storeId: storeId,
          name: map['category'] as String? ?? 'General',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        stock: Stock(
          id: map['id'] as String? ?? '',
          productId: map['id'] as String? ?? '',
          storeId: storeId,
          quantity: qty,
          lowStockThreshold: thresh,
          stockMonitor: true,
          createdAt: now,
          updatedAt: now,
        ),
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
  }
}
