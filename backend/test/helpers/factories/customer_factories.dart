import 'package:backend/database/schema.dart';

/// Test factory for [CustomerRow].
CustomerRow createCustomerRow({
  String id = 'cust-1',
  String name = 'John Doe',
  String mobileNumber = '9876543210',
  String pinHash = 'pin_hash',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructCustomerRow(
    id: id,
    name: name,
    mobileNumber: mobileNumber,
    pinHash: pinHash,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [CustomerRecentStoresRow].
CustomerRecentStoresRow createCustomerRecentStoresRow({
  String customerId = 'cust-1',
  String storeId = 'store-1',
  DateTime? lastVisitedAt,
}) {
  return constructCustomerRecentStoresRow(
    customerId: customerId,
    storeId: storeId,
    lastVisitedAt: lastVisitedAt ?? DateTime.now(),
  );
}

/// Test factory for [CustomerStoreWalletRow].
CustomerStoreWalletRow createCustomerStoreWalletRow({
  String customerId = 'cust-1',
  String storeId = 'store-1',
  int walletBalance = 5000,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructCustomerStoreWalletRow(
    customerId: customerId,
    storeId: storeId,
    walletBalance: walletBalance,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [CustomerWalletTransactionRow].
CustomerWalletTransactionRow createCustomerWalletTransactionRow({
  String id = 'tx-1',
  String customerId = 'cust-1',
  String storeId = 'store-1',
  int amount = 5000,
  String type = 'top_up',
  String? reference = 'REF123',
  String status = 'completed',
  DateTime? createdAt,
}) {
  return constructCustomerWalletTransactionRow(
    id: id,
    customerId: customerId,
    storeId: storeId,
    amount: amount,
    type: type,
    reference: reference,
    status: status,
    createdAt: createdAt ?? DateTime.now(),
  );
}
