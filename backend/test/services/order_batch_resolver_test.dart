import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_batch_resolver.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/schema_factories.dart';

class _MockProductRepository extends Mock implements ProductRepository {}
class _MockStockRepository extends Mock implements StockRepository {}

void main() {
  late _MockProductRepository productRepo;
  late _MockStockRepository stockRepo;

  const storeId = 'store-test';
  const productId = 'prod-test';

  setUp(() {
    productRepo = _MockProductRepository();
    stockRepo = _MockStockRepository();
  });

  group('OrderBatchResolver', () {
    test('resolves active products and categories successfully', () async {
      final product = createProductRow(id: productId, storeId: storeId);
      final category = createCategoryRow(id: 'cat-test', storeId: storeId);

      when(() => productRepo.getById(productId)).thenAnswer(
        (_) async => (product, null, category, null),
      );
      when(() => stockRepo.getByProductAndStore(storeId: storeId, productId: productId))
          .thenAnswer((_) async => null);

      final result = await OrderBatchResolver.resolve(
        productRepo: productRepo,
        stockRepo: stockRepo,
        storeId: storeId,
        productsInput: [{'productId': productId, 'quantity': 2, 'discount': 0.0}],
      );

      expect(result.length, 1);
      expect(result.first.sellingPrice, 5000);
      expect(result.first.quantity, 2);
    });

    test('throws when product is not found', () async {
      when(() => productRepo.getById(productId)).thenAnswer((_) async => null);

      expect(
        () => OrderBatchResolver.resolve(
          productRepo: productRepo,
          stockRepo: stockRepo,
          storeId: storeId,
          productsInput: [{'productId': productId, 'quantity': 1}],
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('not found'))),
      );
    });

    test('throws when product is inactive', () async {
      final product = createProductRow(id: productId, storeId: storeId, isActive: false);
      when(() => productRepo.getById(productId)).thenAnswer(
        (_) async => (product, null, null, null),
      );

      expect(
        () => OrderBatchResolver.resolve(
          productRepo: productRepo,
          stockRepo: stockRepo,
          storeId: storeId,
          productsInput: [{'productId': productId, 'quantity': 1}],
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('is inactive and cannot be ordered'))),
      );
    });

    test('throws when product category is inactive', () async {
      final product = createProductRow(id: productId, storeId: storeId);
      final category = createCategoryRow(id: 'cat-test', storeId: storeId, isActive: false);

      when(() => productRepo.getById(productId)).thenAnswer(
        (_) async => (product, null, category, null),
      );

      expect(
        () => OrderBatchResolver.resolve(
          productRepo: productRepo,
          stockRepo: stockRepo,
          storeId: storeId,
          productsInput: [{'productId': productId, 'quantity': 1}],
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('is inactive and cannot be ordered'))),
      );
    });

    test('throws when stock is insufficient', () async {
      final product = createProductRow(id: productId, storeId: storeId);
      final stock = createStockRow(productId: productId, storeId: storeId, quantity: 2);

      when(() => productRepo.getById(productId)).thenAnswer(
        (_) async => (product, stock, null, null),
      );
      when(() => stockRepo.getByProductAndStore(storeId: storeId, productId: productId))
          .thenAnswer((_) async => stock);

      expect(
        () => OrderBatchResolver.resolve(
          productRepo: productRepo,
          stockRepo: stockRepo,
          storeId: storeId,
          productsInput: [{'productId': productId, 'quantity': 5}],
        ),
        throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('Insufficient stock'))),
      );
    });
  });
}
