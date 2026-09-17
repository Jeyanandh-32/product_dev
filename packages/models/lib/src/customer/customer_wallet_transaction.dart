import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/customer/wallet_transaction_type.dart';

part 'customer_wallet_transaction.freezed.dart';
part 'customer_wallet_transaction.g.dart';

/// Represents a transaction entry modifying a customer's stored wallet balance.
@freezed
abstract class CustomerWalletTransaction with _$CustomerWalletTransaction {
  /// Creates a [CustomerWalletTransaction] instance.
  const factory CustomerWalletTransaction({
    required String id,
    required String customerId,
    required double amount,
    required WalletTransactionType type,
    String? reference,
    required String status,
    @Default(0.0) double platformFee,
    @Default(0.0) double gatewayCharges,
    required DateTime createdAt,
  }) = _CustomerWalletTransaction;

  /// Creates a [CustomerWalletTransaction] from a JSON map.
  factory CustomerWalletTransaction.fromJson(Map<String, Object?> json) =>
      _$CustomerWalletTransactionFromJson(json);
}
