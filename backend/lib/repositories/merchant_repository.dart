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

  Future<MerchantRow?> update({
    required String id,
    String? name,
    String? businessName,
    String? whatsappNumber,
    String? email,
    String? passwordHash,
  }) async {
    final row = await _db.merchants
        .byKey(id)
        .update(
          (m, set) => set(
            name: name != null ? ts.toExpr(name) : m.name,
            businessName: businessName != null
                ? ts.toExpr(businessName)
                : m.businessName,
            whatsappNumber: whatsappNumber != null
                ? ts.toExpr(whatsappNumber)
                : m.whatsappNumber,
            email: email != null ? ts.toExpr(email) : m.email,
            passwordHash: passwordHash != null
                ? ts.toExpr(passwordHash)
                : m.passwordHash,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }
}
