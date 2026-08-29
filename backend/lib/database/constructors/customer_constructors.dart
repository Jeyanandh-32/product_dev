part of '../schema.dart';

/// Constructs a [CustomerRow] instance.
CustomerRow constructCustomerRow({
  required String id,
  required String name,
  required String mobileNumber,
  required String pinHash,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$CustomerRow._(id, name, mobileNumber, pinHash, createdAt, updatedAt);

/// Constructs a [CustomerRecentStoresRow] instance.
CustomerRecentStoresRow constructCustomerRecentStoresRow({
  required String customerId,
  required String storeId,
  required DateTime lastVisitedAt,
}) => _$CustomerRecentStoresRow._(customerId, storeId, lastVisitedAt);

/// Constructs a [CustomerStoreWalletRow] instance.
CustomerStoreWalletRow constructCustomerStoreWalletRow({
  required String customerId,
  required String storeId,
  required int walletBalance,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$CustomerStoreWalletRow._(customerId, storeId, walletBalance, createdAt, updatedAt);

/// Constructs a [CustomerWalletTransactionRow] instance.
CustomerWalletTransactionRow constructCustomerWalletTransactionRow({
  required String id,
  required String customerId,
  required String storeId,
  required int amount,
  required String type,
  required String status,
  required DateTime createdAt,
  String? reference,
}) => _$CustomerWalletTransactionRow._(id, customerId, storeId, amount, type, reference, status, createdAt);
