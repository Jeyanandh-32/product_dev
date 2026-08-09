import 'package:backend/config/database.dart';
import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:models/models.dart';

class ProductService {
  const ProductService({
    required this._productRepo,
    required this._stockRepo,
  });

  final ProductRepository _productRepo;
  final StockRepository _stockRepo;

  Future<Product> create({
    required String merchantId,
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final name = body['name'] as String;
    final categoryId = body['categoryId'] as String;
    final counterId = body['counterId'] as String;
    final basePrice = ((body['basePrice'] as num).toDouble() * 100).round();
    final sellingPrice = ((body['sellingPrice'] as num).toDouble() * 100)
        .round();
    final sku = readOptionalString(body, 'sku');
    final barcode = readOptionalString(body, 'barcode');
    final description = readOptionalString(body, 'description');
    final imageUrl = readOptionalString(body, 'imageUrl');
    final taxRate = (body['taxRate'] as num?)?.toDouble() ?? 0.0;

    return Database.db.transact(() async {
      final productRow = await _productRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        name: name.trim(),
        categoryId: categoryId,
        counterId: counterId,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        sku: sku,
        barcode: barcode,
        description: description,
        imageUrl: imageUrl,
        taxRate: taxRate,
      );

      final stockRow = await _stockRepo.create(
        productId: productRow.id,
        storeId: storeId,
      );

      return productRow.toProduct(stockRow: stockRow);
    });
  }
}
