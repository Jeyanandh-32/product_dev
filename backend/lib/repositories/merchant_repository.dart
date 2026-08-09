import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class MerchantRepository {
  MerchantRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  Future<MerchantRow> create({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String passwordHash,
  }) async {
    final row = await _db.merchants
        .insertValue(
          name: name,
          businessName: businessName,
          whatsappNumber: whatsappNumber,
          email: email,
          passwordHash: passwordHash,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<List<MerchantRow>> getAll() async {
    final rows = await _db.merchants.fetch();
    return rows;
  }

  Future<MerchantRow?> getByEmail(String email) async {
    final row = await _db.merchants
        .where((m) => m.email.equalsValue(email))
        .first
        .fetch();
    return row;
  }

  Future<MerchantRow?> getById(String id) async {
    final row = await _db.merchants.byKey(id).fetch();
    return row;
  }
}
