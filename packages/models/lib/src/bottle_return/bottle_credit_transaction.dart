import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle_credit_transaction.freezed.dart';
part 'bottle_credit_transaction.g.dart';

/// Transaction log for customer bottle return credit and debit events.
@freezed
abstract class BottleCreditTransaction with _$BottleCreditTransaction {
  const factory BottleCreditTransaction({
    required String id,
    required String merchantId,
    required String customerPhone,
    required int amount,
    required String type,
    String? referenceOrderId,
    String? storeId,
    DateTime? createdAt,
  }) = _BottleCreditTransaction;

  factory BottleCreditTransaction.fromJson(Map<String, dynamic> json) =>
      _$BottleCreditTransactionFromJson(json);
}
