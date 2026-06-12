import 'package:backend/models/category/category_dto.dart';
import 'package:postgres/postgres.dart';

class CategoryRepository {
  CategoryRepository({required Session session}) : _session = session;

  final Session _session;

  Future<CategoryDto> create({
    required String name,
    required String merchantId,
    required String storeId,
    String? description,
    String? imageUrl,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO categories(name, merchant_id, store_id, description, image_url)
      VALUES(@name, @merchantId, @storeId, @description, @imageUrl) RETURNING *
      '''),
      parameters: {
        'name': name,
        'merchantId': merchantId,
        'storeId': storeId,
        'description': description,
        'imageUrl': imageUrl,
      },
    );

    return CategoryDto.fromJson(result.first.toColumnMap());
  }

  Future<List<CategoryDto>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final result = await _session.execute(
      Sql.named(
        '''
        SELECT * FROM categories WHERE merchant_id = @merchantId
        ${storeId != null ? 'AND store_id = @storeId' : ''}
      ''',
      ),
      parameters: {
        'merchantId': merchantId,
        if (storeId != null) 'storeId': storeId,
      },
    );

    if (result.isEmpty) return [];

    final categoryDtos = result
        .map(
          (element) => CategoryDto.fromJson(element.toColumnMap()),
        )
        .toList();

    return categoryDtos;
  }

  Future<CategoryDto?> getById(String id) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM categories WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final categoryDto = CategoryDto.fromJson(result.first.toColumnMap());

    return categoryDto;
  }

  Future<CategoryDto?> update({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    bool descriptionPresent = false,
    String? imageUrl,
    bool imageUrlPresent = false,
  }) async {
    final result = await _session.execute(
      Sql.named('''
        UPDATE categories SET name = COALESCE(@name, name),
        is_active = COALESCE(@isActive, is_active),
        description = CASE
          WHEN @descriptionPresent THEN @description
          ELSE description
        END,
        image_url = CASE
          WHEN @imageUrlPresent THEN @imageUrl
          ELSE image_url
        END,
        updated_at = NOW() WHERE id = @id RETURNING *
      '''),
      parameters: {
        'id': id,
        'name': name,
        'isActive': isActive,
        'description': description,
        'descriptionPresent': descriptionPresent,
        'imageUrl': imageUrl,
        'imageUrlPresent': imageUrlPresent,
      },
    );

    if (result.isEmpty) return null;

    final categoryDto = CategoryDto.fromJson(result.first.toColumnMap());

    return categoryDto;
  }
}
