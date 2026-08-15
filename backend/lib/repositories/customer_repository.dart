import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_wallet_database_repository.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling customer identity, profiles, and recently visited stores.
class CustomerRepository {
  CustomerRepository({required this.db})
      : _walletRepo = CustomerWalletDatabaseRepository(db: db);

  final ts.Database<DatabaseSchema> db;
  final CustomerWalletDatabaseRepository _walletRepo;

  /// Registers a new customer account.
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

  /// Retrieves customer record by mobile number.
  Future<CustomerRow?> getByMobileNumber(String mobileNumber) async {
    final row = await db.customers
        .where((c) => c.mobileNumber.equalsValue(mobileNumber))
        .first
        .fetch();
    return row;
  }

  /// Retrieves customer record by primary UUID.
  Future<CustomerRow?> getById(String id) async {
    final row = await db.customers.byKey(id).fetch();
    return row;
  }

  /// Records or updates the timestamp of a store visit for quick re-ordering.
  Future<void> recordStoreVisit({
    required String customerId,
    required String storeId,
  }) async {
    final existing = await db.customerRecentStores
        .byKey(customerId, storeId)
        .fetch();

    if (existing != null) {
      await db.customerRecentStores
          .byKey(customerId, storeId)
          .update(
            (r, set) => set(
              lastVisitedAt: ts.Expr.currentTimestamp,
            ),
          )
          .execute();
    } else {
      await db.customerRecentStores
          .insertValue(
            customerId: customerId,
            storeId: storeId,
          )
          .execute();
    }
  }

  /// Fetches recently visited stores for a customer.
  Future<List<StoreRow>> getRecentStores({
    required String customerId,
    int limit = 5,
  }) async {
    final recentRows = await db.customerRecentStores
        .where((r) => r.customerId.equalsValue(customerId))
        .orderBy((r) => [(r.lastVisitedAt, ts.Order.descending)])
        .limit(limit)
        .fetch();

    if (recentRows.isEmpty) return [];

    final allStores = await db.stores
        .where(
          (s) =>
              s.isActive.equalsValue(true) &
              s.isOnlineEnabled.equalsValue(true),
        )
        .fetch();

    final storeIds = recentRows.map((r) => r.storeId).toSet();
    final matchingStores = allStores
        .where((s) => storeIds.contains(s.id))
        .toList();

    final storeMap = {for (final s in matchingStores) s.id: s};
    final ordered = <StoreRow>[];
    for (final r in recentRows) {
      final s = storeMap[r.storeId];
      if (s != null) ordered.add(s);
    }

    return ordered;
  }

  /// Updates profile information (name, mobile, security PIN).
  Future<CustomerRow?> update({
    required String id,
    String? name,
    String? mobileNumber,
    String? pinHash,
  }) async {
    final row = await db.customers
        .byKey(id)
        .update(
          (c, set) => set(
            name: name != null ? ts.toExpr(name) : c.name,
            mobileNumber:
                mobileNumber != null ? ts.toExpr(mobileNumber) : c.mobileNumber,
            pinHash: pinHash != null ? ts.toExpr(pinHash) : c.pinHash,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }

  /// Updates or initializes the customer wallet balance for a specific store.
  Future<CustomerStoreWalletRow?> updateStoreWalletBalance({
    required String customerId,
    required String storeId,
    required int amountDeltaPaise,
  }) =>
      _walletRepo.updateStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
        amountDeltaPaise: amountDeltaPaise,
      );

  /// Fetches the store wallet balance in paise for a customer.
  Future<int> getStoreWalletBalance({
    required String customerId,
    required String storeId,
  }) =>
      _walletRepo.getStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
      );

  /// Inserts a new customer wallet transaction log entry.
  Future<CustomerWalletTransactionRow> createWalletTransaction({
    required String customerId,
    required String storeId,
    required int amount,
    required String type,
    String? reference,
    String status = 'completed',
  }) =>
      _walletRepo.createWalletTransaction(
        customerId: customerId,
        storeId: storeId,
        amount: amount,
        type: type,
        reference: reference,
        status: status,
      );

  /// Updates status for an asynchronous wallet transaction.
  Future<CustomerWalletTransactionRow?> updateWalletTransactionStatus({
    required String id,
    required String status,
  }) =>
      _walletRepo.updateWalletTransactionStatus(
        id: id,
        status: status,
      );

  /// Fetches all transaction records for a customer within a store.
  Future<List<CustomerWalletTransactionRow>> getWalletTransactions({
    required String customerId,
    required String storeId,
  }) =>
      _walletRepo.getWalletTransactions(
        customerId: customerId,
        storeId: storeId,
      );
}
