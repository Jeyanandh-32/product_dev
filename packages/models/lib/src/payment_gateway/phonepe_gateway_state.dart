import 'package:freezed_annotation/freezed_annotation.dart';

part 'phonepe_gateway_state.g.dart';

/// PhonePe gateway transaction lifecycle states.
@JsonEnum(alwaysCreate: true)
enum PhonePeGatewayState {
  /// Transaction has completed successfully.
  @JsonValue('COMPLETED')
  completed,

  /// Gateway reported success state.
  @JsonValue('SUCCESS')
  success,

  /// Transaction failed.
  @JsonValue('FAILED')
  failed,

  /// Transaction was cancelled.
  @JsonValue('CANCELLED')
  cancelled,

  /// Transaction is pending processing.
  @JsonValue('PENDING')
  pending,

  /// Checkout sheet concluded by user.
  @JsonValue('CONCLUDED')
  concluded;

  /// Whether this state represents a successful terminal state.
  bool get isSuccess => this == completed || this == success;

  /// Whether this state represents a failed terminal state.
  bool get isFailed => this == failed || this == cancelled;

  /// Whether the checkout modal was concluded.
  bool get isConcluded => this == concluded;

  /// Deserializes a string value into [PhonePeGatewayState] using the generated enum map.
  static PhonePeGatewayState? fromJson(dynamic json) =>
      tryParse(json?.toString());

  /// Serializes to the `@JsonValue` string representation.
  String toJson() => _$PhonePeGatewayStateEnumMap[this]!;

  /// Parses a string into [PhonePeGatewayState] safely, ignoring case.
  static PhonePeGatewayState? tryParse(String? value) {
    if (value == null) return null;
    final upper = value.toUpperCase().trim();
    for (final entry in _$PhonePeGatewayStateEnumMap.entries) {
      if (entry.value.toUpperCase() == upper ||
          entry.key.name.toUpperCase() == upper) {
        return entry.key;
      }
    }
    return null;
  }
}

