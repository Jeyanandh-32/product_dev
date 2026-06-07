import 'package:backend/models/merchant_dto.dart';
import 'package:postgres/postgres.dart';

class MerchantRepository {
  MerchantRepository({required Session session}) : _session = session;

  final Session _session;

  Future<MerchantDto> create({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String passwordHash,
  }) async {
    final result = await _session.execute(
      Sql.named('''
      INSERT INTO merchants(name, business_name, whatsapp_number, email, password_hash)
      VALUES(@name, @businessName, @whatsappNumber, @email, @passwordHash)
      RETURNING *
    '''),
      parameters: {
        'name': name,
        'businessName': businessName,
        'whatsappNumber': whatsappNumber,
        'email': email,
        'passwordHash': passwordHash,
      },
    );

    return MerchantDto.fromJson(result.first.toColumnMap());
  }

  Future<List<MerchantDto>> getAll() async {
    final result = await _session.execute(
      '''
        SELECT * FROM merchants
      ''',
    );

    if (result.isEmpty) return [];

    final merchantDtos = result
        .map(
          (element) => MerchantDto.fromJson(element.toColumnMap()),
        )
        .toList();

    return merchantDtos;
  }

  Future<MerchantDto?> getByEmail(String email) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM merchants WHERE email = @email
      '''),
      parameters: {'email': email},
    );

    if (result.isEmpty) return null;

    final merchantDto = MerchantDto.fromJson(result.first.toColumnMap());

    return merchantDto;
  }

  Future<MerchantDto?> getById(String id) async {
    final result = await _session.execute(
      Sql.named('''
        SELECT * FROM merchants WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final merchantDto = MerchantDto.fromJson(result.first.toColumnMap());

    return merchantDto;
  }
}
