import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter.freezed.dart';
part 'counter.g.dart';

@freezed
abstract class Counter with _$Counter {
  const factory Counter({
    required String id,
    required String name,
    required String merchantId,
    required String storeId,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Counter;

  factory Counter.fromJson(Map<String, Object?> json) =>
      _$CounterFromJson(json);
}
