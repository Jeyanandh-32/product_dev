import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class CustomerRepository {
  CustomerRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  Future<CustomerRow> create({
    required String name,
    required String mobileNumber,
    required String pinHash,
  }) async {
    final row = await db.customers
        .insertValue(
          name: name,
          mobileNumber: mobileNumber,
          pinHash: pinHash,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<CustomerRow?> getByMobileNumber(String mobileNumber) async {
    final row = await db.customers
        .where((c) => c.mobileNumber.equalsValue(mobileNumber))
        .first
        .fetch();
    return row;
  }

  Future<CustomerRow?> getById(String id) async {
    final row = await db.customers.byKey(id).fetch();
    return row;
  }
}
