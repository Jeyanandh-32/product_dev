import 'package:backend/models/product/product_dto.dart';
import 'package:postgres/postgres.dart';

class ProductRepository {
  ProductRepository({required Session session}) : _session = session;

  final Session _session;

  Future<ProductDto> create({
    required String merchantId,
    required String storeId,
    required String name,
    required String categoryId,
    required String counterId,
    required int basePrice,
    required int sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO products(merchant_id, store_id, name, sku, barcode, description, image_url,
      category_id, counter_id, tax_rate, base_price, selling_price)
      VALUES(@merchantId, @storeId, @name, @sku, @barcode, @description, @imageUrl, @categoryId,
      @counterId, @taxRate, @basePrice, @sellingPrice) RETURNING *
      '''),
      parameters: {
        'merchantId': merchantId,
        'storeId': storeId,
        'name': name,
        'sku': sku,
        'barcode': barcode,
        'description': description,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
        'counterId': counterId,
        'taxRate': taxRate,
        'basePrice': basePrice,
        'sellingPrice': sellingPrice,
      },
    );

    return ProductDto.fromJson(result.first.toColumnMap());
  }

  Future<ProductDto?> update({
    required String id,
    String? name,
    String? categoryId,
    String? counterId,
    bool? isActive,
    int? basePrice,
    int? sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    bool skuPresent = false,
    bool barcodePresent = false,
    bool descriptionPresent = false,
    bool imageUrlPresent = false,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      UPDATE products SET name = COALESCE(@name, name),
      is_active = COALESCE(@isActive, is_active),
      category_id = COALESCE(@categoryId, category_id),
      counter_id = COALESCE(@counterId, counter_id),
      base_price = COALESCE(@basePrice, base_price),
      selling_price = COALESCE(@sellingPrice, selling_price),
      tax_rate = COALESCE(@taxRate, tax_rate),
      sku = CASE WHEN @skuPresent THEN @sku ELSE sku END,
      barcode = CASE WHEN @barcodePresent THEN @barcode ELSE barcode END,
      description = CASE WHEN @descriptionPresent THEN @description ELSE description END,
      image_url = CASE WHEN @imageUrlPresent THEN @imageUrl ELSE image_url END
      WHERE id = @id RETURNING *
      '''),
      parameters: {
        'id': id,
        'name': name,
        'isActive': isActive,
        'sku': sku,
        'skuPresent': skuPresent,
        'barcode': barcode,
        'barcodePresent': barcodePresent,
        'description': description,
        'descriptionPresent': descriptionPresent,
        'imageUrl': imageUrl,
        'imageUrlPresent': imageUrlPresent,
        'categoryId': categoryId,
        'counterId': counterId,
        'taxRate': taxRate,
        'basePrice': basePrice,
        'sellingPrice': sellingPrice,
      },
    );

    if (result.isEmpty) return null;

    return ProductDto.fromJson(result.first.toColumnMap());
  }

  Future<List<ProductDto>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final result = await _session.execute(
      Sql.named(
        '''
        SELECT 
          p.*,
          s.id AS stock_id,
          s.product_id AS stock_product_id,
          s.store_id AS stock_store_id,
          s.quantity AS stock_quantity,
          s.low_stock_threshold AS stock_low_stock_threshold,
          s.created_at AS stock_created_at,
          s.updated_at AS stock_updated_at,
          c.name AS category_name,
          cnt.name AS counter_name
        FROM products p
        LEFT JOIN stocks s ON p.id = s.product_id
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN counters cnt ON p.counter_id = cnt.id
        WHERE p.merchant_id = @merchantId
        ${storeId != null ? 'AND p.store_id = @storeId' : ''}
      ''',
      ),
      parameters: {
        'merchantId': merchantId,
        if (storeId != null) 'storeId': storeId,
      },
    );

    if (result.isEmpty) return [];

    return result.map((element) {
      final columns = element.toColumnMap();
      Map<String, Object?>? stockMap;
      if (columns['stock_id'] != null) {
        stockMap = {
          'id': columns['stock_id'],
          'product_id': columns['stock_product_id'],
          'store_id': columns['stock_store_id'],
          'quantity': columns['stock_quantity'],
          'low_stock_threshold': columns['stock_low_stock_threshold'],
          'created_at': columns['stock_created_at'],
          'updated_at': columns['stock_updated_at'],
        };
      }
      final productMap = Map<String, Object?>.from(columns)
        ..['stock'] = stockMap;
      return ProductDto.fromJson(productMap);
    }).toList();
  }

  Future<ProductDto?> getById(String id) async {
    final result = await _session.execute(
      Sql.named('''
      SELECT 
        p.*,
        s.id AS stock_id,
        s.product_id AS stock_product_id,
        s.store_id AS stock_store_id,
        s.quantity AS stock_quantity,
        s.low_stock_threshold AS stock_low_stock_threshold,
        s.created_at AS stock_created_at,
        s.updated_at AS stock_updated_at,
        c.name AS category_name,
        cnt.name AS counter_name
      FROM products p
      LEFT JOIN stocks s ON p.id = s.product_id
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN counters cnt ON p.counter_id = cnt.id
      WHERE p.id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final columns = result.first.toColumnMap();
    Map<String, Object?>? stockMap;
    if (columns['stock_id'] != null) {
      stockMap = {
        'id': columns['stock_id'],
        'product_id': columns['stock_product_id'],
        'store_id': columns['stock_store_id'],
        'quantity': columns['stock_quantity'],
        'low_stock_threshold': columns['stock_low_stock_threshold'],
        'created_at': columns['stock_created_at'],
        'updated_at': columns['stock_updated_at'],
      };
    }
    final productMap = Map<String, Object?>.from(columns)
      ..['stock'] = stockMap;
    return ProductDto.fromJson(productMap);
  }
}
