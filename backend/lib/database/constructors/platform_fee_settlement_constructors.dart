part of '../schema.dart';

/// Constructs a [PlatformFeeSettlementRow] instance.
PlatformFeeSettlementRow constructPlatformFeeSettlementRow({
  required String id,
  required String merchantId,
  required int amountInPaise,
  required int ordersCount,
  required String paymentGateway,
  required String status,
  required DateTime createdAt,
  String? paymentTransactionId,
  DateTime? settledAt,
}) => _$PlatformFeeSettlementRow._(
  id,
  merchantId,
  amountInPaise,
  ordersCount,
  paymentGateway,
  paymentTransactionId,
  status,
  createdAt,
  settledAt,
);
