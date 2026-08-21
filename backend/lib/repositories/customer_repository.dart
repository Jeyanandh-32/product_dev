import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_recent_stores_repository.dart';
import 'package:backend/repositories/customer_wallet_database_repository.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling customer identity, profiles, and recently visited stores.
class CustomerRepository {
  CustomerRepository({required this.db})
      : _walletRepo = CustomerWalletDatabaseRepository(db: db),
        _recentStoresRepo = CustomerRecentStoresRepository(db: db);

  final ts.Database<DatabaseSchema> db;
  final CustomerWalletDatabaseRepository _walletRepo;
  final CustomerRecentStoresRepository _recentStoresRepo;

  /// Registers a new customer account.
  Future<CustomerRow> create({
    required String name,
    required String mobileNumber,
    required String pinHash,
  }) => db.customers
      .insertValue(name: name, mobileNumber: mobileNumber, pinHash: pinHash)
      .returnInserted()
      .executeAndFetch();

  /// Retrieves customer record by mobile number.
  Future<CustomerRow?> getByMobileNumber(String mobileNumber) =>
      db.customers.where((c) => c.mobileNumber.equalsValue(mobileNumber)).first.fetch();

  /// Retrieves customer record by primary UUID.
  Future<CustomerRow?> getById(String id) => db.customers.byKey(id).fetch();

  /// Batch retrieves customers by IDs.
  Future<List<CustomerRow>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    return db.customers.where((c) {
      var expr = c.id.equals(ts.toExpr(ids.first));
      for (var i = 1; i < ids.length; i++) {
        expr = expr.or(c.id.equals(ts.toExpr(ids[i])));
      }
      return expr;
    }).fetch();
  }

  /// Records or updates the timestamp of a store visit for quick re-ordering.
  Future<void> recordStoreVisit({required String customerId, required String storeId}) =>
      _recentStoresRepo.recordVisit(customerId: customerId, storeId: storeId);

  /// Fetches recently visited stores for a customer.
  Future<List<StoreRow>> getRecentStores({required String customerId, int limit = 5}) =>
      _recentStoresRepo.getRecentStores(customerId: customerId, limit: limit);

  /// Updates profile information (name, mobile, security PIN).
  Future<CustomerRow?> update({required String id, String? name, String? mobileNumber, String? pinHash}) =>
      db.customers
          .byKey(id)
          .update(
            (c, set) => set(
              name: name != null ? ts.toExpr(name) : c.name,
              mobileNumber: mobileNumber != null ? ts.toExpr(mobileNumber) : c.mobileNumber,
              pinHash: pinHash != null ? ts.toExpr(pinHash) : c.pinHash,
              updatedAt: ts.Expr.currentTimestamp,
            ),
          )
          .returnUpdated()
          .executeAndFetch();

  /// Updates or initializes the customer wallet balance for a specific store.
  Future<CustomerStoreWalletRow?> updateStoreWalletBalance({required String customerId, required String storeId, required int amountDeltaPaise}) =>
      _walletRepo.updateStoreWalletBalance(customerId: customerId, storeId: storeId, amountDeltaPaise: amountDeltaPaise);

  /// Fetches the store wallet balance in paise for a customer.
  Future<int> getStoreWalletBalance({required String customerId, required String storeId}) =>
      _walletRepo.getStoreWalletBalance(customerId: customerId, storeId: storeId);

  /// Inserts a new customer wallet transaction log entry.
  Future<CustomerWalletTransactionRow> createWalletTransaction({
    required String customerId,
    required String storeId,
    required int amount,
    required String type,
    String? reference,
    String status = 'completed',
  }) => _walletRepo.createWalletTransaction(
    customerId: customerId,
    storeId: storeId,
    amount: amount,
    type: type,
    reference: reference,
    status: status,
  );

  /// Updates status for an asynchronous wallet transaction.
  Future<CustomerWalletTransactionRow?> updateWalletTransactionStatus({required String id, required String status}) =>
      _walletRepo.updateWalletTransactionStatus(id: id, status: status);

  /// Fetches all transaction records for a customer within a store.
  Future<List<CustomerWalletTransactionRow>> getWalletTransactions({required String customerId, required String storeId}) =>
      _walletRepo.getWalletTransactions(customerId: customerId, storeId: storeId);
}
