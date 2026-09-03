part of '../schema.dart';

@PrimaryKey(['id'])
abstract final class PlatformFeeSettlementRow extends Row {
  @DefaultValue('gen_random_uuid()')
  String get id;

  @References(table: 'merchants', field: 'id', onDelete: .cascade)
  String get merchantId;

  int get amountInPaise;

  @DefaultValue(0)
  int get ordersCount;

  @DefaultValue('phonepe')
  String get paymentGateway;

  String? get paymentTransactionId;

  @DefaultValue('pending')
  String get status;

  @DefaultValue.now
  DateTime get createdAt;

  DateTime? get settledAt;
}
