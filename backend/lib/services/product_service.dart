import 'package:backend/config/database.dart';
import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:models/models.dart';

class ProductService {
  const ProductService({
    required this._productRepo,
    required this._stockRepo,
    required this._categoryRepo,
    required this._counterRepo,
  });

  final ProductRepository _productRepo;
  final StockRepository _stockRepo;
  final CategoryRepository _categoryRepo;
  final CounterRepository _counterRepo;

  Future<Product> create({
    required String merchantId,
    required String storeId,
    required Map<String, dynamic> body,
  }) async {
    final name = body['name'] as String;
    final categoryId = body['categoryId'] as String;
    final counterId = readOptionalString(body, 'counterId');
    final basePrice = ((body['basePrice'] as num).toDouble() * 100).round();
    final sellingPrice = ((body['sellingPrice'] as num).toDouble() * 100)
        .round();
    final sku = readOptionalString(body, 'sku')?.trim().toUpperCase();
    final barcode = readOptionalString(body, 'barcode')?.trim().toUpperCase();
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

      final categoryRow = await _categoryRepo.getById(categoryId);
      final counterRow = counterId != null
          ? await _counterRepo.getById(counterId)
          : null;

      return productRow.toProduct(
        stockRow: stockRow,
        categoryRow: categoryRow,
        counterRow: counterRow,
      );
    });
  }
}
