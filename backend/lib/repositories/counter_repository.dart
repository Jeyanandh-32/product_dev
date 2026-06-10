import 'package:backend/models/counter/counter_dto.dart';
import 'package:postgres/postgres.dart';

class CounterRepository {
  CounterRepository({required Session session}) : _session = session;

  final Session _session;

  Future<CounterDto> create({
    required String name,
    required String merchantId,
    required String storeId,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO counters(name, merchant_id, store_id)
      VALUES(@name, @merchantId, @storeId) RETURNING *
      '''),
      parameters: {
        'name': name,
        'merchantId': merchantId,
        'storeId': storeId,
      },
    );

    return CounterDto.fromJson(result.first.toColumnMap());
  }

  Future<List<CounterDto>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final result = await _session.execute(
      Sql.named(
        '''
        SELECT * FROM counters WHERE merchant_id = @merchantId
        ${storeId != null ? 'AND store_id = @storeId' : ''}
      ''',
      ),
      parameters: {
        'merchantId': merchantId,
        if (storeId != null) 'storeId': storeId,
      },
    );

    if (result.isEmpty) return [];

    final counterDtos = result
        .map(
          (element) => CounterDto.fromJson(element.toColumnMap()),
        )
        .toList();

    return counterDtos;
  }

  Future<CounterDto?> getById(String id) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM counters WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final counterDto = CounterDto.fromJson(result.first.toColumnMap());

    return counterDto;
  }

  Future<CounterDto?> update({
    required String id,
    String? name,
    bool? isActive,
  }) async {
    final result = await _session.execute(
      Sql.named('''
        UPDATE counters SET name = COALESCE(@name, name),
        is_active = COALESCE(@isActive, is_active),
        updated_at = NOW() WHERE id = @id RETURNING *
      '''),
      parameters: {
        'id': id,
        'name': name,
        'isActive': isActive,
      },
    );

    if (result.isEmpty) return null;

    final counterDto = CounterDto.fromJson(result.first.toColumnMap());

    return counterDto;
  }
}
