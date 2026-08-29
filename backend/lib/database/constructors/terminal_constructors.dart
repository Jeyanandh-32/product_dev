part of '../schema.dart';

/// Constructs a [TerminalRow] instance.
TerminalRow constructTerminalRow({
  required String code,
  required String merchantId,
  required String storeId,
  required String name,
  required String passwordHash,
  required bool isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$TerminalRow._(code, merchantId, storeId, name, passwordHash, isActive, createdAt, updatedAt);
