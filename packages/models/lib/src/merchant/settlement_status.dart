import 'package:freezed_annotation/freezed_annotation.dart';

/// Settlement transaction status lifecycle.
@JsonEnum(fieldRename: FieldRename.snake)
enum SettlementStatus {
  /// Settlement initiated and awaiting payment.
  pending,

  /// Settlement payment successfully completed.
  completed,

  /// Settlement payment failed or rejected.
  failed;

  /// Whether the settlement is pending.
  bool get isPending => this == pending;

  /// Whether the settlement is completed.
  bool get isCompleted => this == completed;

  /// Whether the settlement failed.
  bool get isFailed => this == failed;

  /// Parses from string or wire value safely.
  static SettlementStatus? tryParse(String? value) {
    if (value == null) return null;
    return SettlementStatus.values.asNameMap()[value.toLowerCase().trim()];
  }

  /// Deserializes JSON string value.
  static SettlementStatus? fromJson(dynamic json) =>
      tryParse(json?.toString());
}
