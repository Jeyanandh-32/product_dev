import 'package:backend/models/terminal/terminal_dto.dart';
import 'package:postgres/postgres.dart';

class TerminalRepository {
  TerminalRepository({required Session session}) : _session = session;

  final Session _session;

  Future<TerminalDto> create({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required String passwordHash,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO terminals(code, merchant_id, store_id, name, password_hash)
      VALUES(@code , @merchantId, @storeId, @name, @passwordHash) RETURNING *
      '''),
      parameters: {
        'code': code,
        'merchantId': merchantId,
        'storeId': storeId,
        'name': name,
        'passwordHash': passwordHash,
      },
    );

    return TerminalDto.fromJson(result.first.toColumnMap());
  }

  Future<List<TerminalDto>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final result = await _session.execute(
      Sql.named(
        '''
        SELECT * FROM terminals WHERE merchant_id = @merchantId
        ${storeId != null ? 'AND store_id = @storeId' : ''}
      ''',
      ),
      parameters: {
        'merchantId': merchantId,
        if (storeId != null) 'storeId': storeId,
      },
    );

    if (result.isEmpty) return [];

    final terminalDtos = result
        .map(
          (element) => TerminalDto.fromJson(element.toColumnMap()),
        )
        .toList();

    return terminalDtos;
  }

  Future<TerminalDto?> getByCode(String code) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM terminals WHERE code = @code
      '''),
      parameters: {'code': code},
    );

    if (result.isEmpty) return null;

    final terminalDto = TerminalDto.fromJson(result.first.toColumnMap());

    return terminalDto;
  }

  Future<TerminalDto?> update({
    required String code,
    String? name,
    String? passwordHash,
    bool? isActive,
  }) async {
    final result = await _session.execute(
      Sql.named('''
        UPDATE terminals SET name = COALESCE(@name, name),
        password_hash = COALESCE(@passwordHash, password_hash),
        is_active = COALESCE(@isActive, is_active),
        updated_at = NOW() WHERE code = @code RETURNING *
      '''),
      parameters: {
        'code': code,
        'name': name,
        'passwordHash': passwordHash,
        'isActive': isActive,
      },
    );

    if (result.isEmpty) return null;

    final terminalDto = TerminalDto.fromJson(result.first.toColumnMap());

    return terminalDto;
  }
}
