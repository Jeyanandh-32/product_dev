import 'package:backend/models/store/store_dto.dart';
import 'package:postgres/postgres.dart';

class StoreRepository {
  StoreRepository({required Session session}) : _session = session;

  final Session _session;

  Future<StoreDto> create({
    required String merchantId,
    required String name,
    String? storeType,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO stores(merchant_id, name, store_type) VALUES(@merchantId, @name, @storeType) RETURNING *
      '''),
      parameters: {
        'merchantId': merchantId,
        'name': name,
        'storeType': storeType,
      },
    );

    return StoreDto.fromJson(result.first.toColumnMap());
  }

  Future<List<StoreDto>> getAll({required String merchantId}) async {
    final result = await _session.execute(
      Sql.named(
        '''
        SELECT * FROM stores WHERE merchant_id = @id
      ''',
      ),
      parameters: {'id': merchantId},
    );

    if (result.isEmpty) return [];

    final storeDtos = result
        .map(
          (element) => StoreDto.fromJson(element.toColumnMap()),
        )
        .toList();

    return storeDtos;
  }

  Future<StoreDto?> getById(String id) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM stores WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final storeDto = StoreDto.fromJson(result.first.toColumnMap());

    return storeDto;
  }

  Future<StoreDto?> update({
    required String id,
    String? name,
    String? storeType,
    bool? isActive,
  }) async {
    final result = await _session.execute(
      Sql.named('''
        UPDATE stores SET name = COALESCE(@name, name),
        store_type = COALESCE(@storeType, store_type),
        is_active = COALESCE(@isActive, is_active),
        updated_at = NOW() WHERE id = @id RETURNING *
      '''),
      parameters: {
        'id': id,
        'name': name,
        'storeType': storeType,
        'isActive': isActive,
      },
    );

    if (result.isEmpty) return null;

    final storeDto = StoreDto.fromJson(result.first.toColumnMap());

    return storeDto;
  }
}
