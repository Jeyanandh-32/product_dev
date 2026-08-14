import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/customer/wallet_transaction_type.dart';

part 'customer_wallet_transaction.freezed.dart';
part 'customer_wallet_transaction.g.dart';

@freezed
abstract class CustomerWalletTransaction with _$CustomerWalletTransaction {
  const factory CustomerWalletTransaction({
    required String id,
    required String customerId,
    required double amount,
    required WalletTransactionType type,
    String? reference,
    required String status,
    required DateTime createdAt,
  }) = _CustomerWalletTransaction;

  factory CustomerWalletTransaction.fromJson(Map<String, Object?> json) =>
      _$CustomerWalletTransactionFromJson(json);
}
