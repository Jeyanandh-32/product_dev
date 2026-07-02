import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class TerminalRepository {
  TerminalRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

  Future<TerminalRow> create({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required String passwordHash,
  }) async {
    final row = await _db.terminals
        .insertValue(
          code: code,
          merchantId: merchantId,
          storeId: storeId,
          name: name,
          passwordHash: passwordHash,
        )
        .returning((ts.Expr<TerminalRow> t) => (t,))
        .executeAndFetch();

    return row;
  }

  Future<List<TerminalRow>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final query = _db.terminals
        .where((t) => t.merchantId.equalsValue(merchantId));

    if (storeId != null) {
      final rows = await query
          .where((t) => t.storeId.equalsValue(storeId))
          .fetch();
      return rows;
    }

    final rows = await query.fetch();
    return rows;
  }

  Future<TerminalRow?> getByCode(String code) async {
    final row = await _db.terminals.byKey(code).fetch();
    return row;
  }

  Future<TerminalRow?> update({
    required String code,
    String? name,
    String? passwordHash,
    bool? isActive,
  }) async {
    final row = await _db.terminals
        .byKey(code)
        .update(
          (t, set) => set(
            name: name != null ? ts.toExpr(name) : t.name,
            passwordHash:
                passwordHash != null ? ts.toExpr(passwordHash) : t.passwordHash,
            isActive: isActive != null ? ts.toExpr(isActive) : t.isActive,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returning((ts.Expr<TerminalRow> t) => (t,))
        .executeAndFetch();

    return row;
  }
}
