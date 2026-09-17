import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter.freezed.dart';
part 'counter.g.dart';

/// Represents an operational service or fulfillment counter within a store.
@freezed
abstract class Counter with _$Counter {
  /// Creates a [Counter] instance.
  const factory Counter({
    required String id,
    required String name,
    required String merchantId,
    required String storeId,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? imageUrl,
  }) = _Counter;

  /// Creates a [Counter] from a JSON map.
  factory Counter.fromJson(Map<String, Object?> json) =>
      _$CounterFromJson(json);
}
