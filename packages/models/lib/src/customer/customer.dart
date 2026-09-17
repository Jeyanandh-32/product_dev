import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

/// Represents an individual retail customer registered in the system.
@freezed
abstract class Customer with _$Customer {
  /// Creates a [Customer] instance.
  const factory Customer({
    required String id,
    required String name,
    required String mobileNumber,
    @Default(0.0) double walletBalance,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Customer;

  /// Creates a [Customer] from a JSON map.
  factory Customer.fromJson(Map<String, Object?> json) =>
      _$CustomerFromJson(json);
}
