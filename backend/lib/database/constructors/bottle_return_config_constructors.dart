part of '../schema.dart';

/// Constructs a [BottleReturnConfigRow] instance.
BottleReturnConfigRow constructBottleReturnConfigRow({
  required String storeId,
  required bool isEnabled,
  required int rewardAmountInRupees,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? iotApiKey,
}) => _$BottleReturnConfigRow._(storeId, isEnabled, rewardAmountInRupees, iotApiKey, createdAt, updatedAt);

/// Constructs a [BottleReturnProductRow] instance.
BottleReturnProductRow constructBottleReturnProductRow({
  required String productId,
  required String storeId,
  required bool isReturnable,
  required DateTime createdAt,
}) => _$BottleReturnProductRow._(productId, storeId, isReturnable, createdAt);
