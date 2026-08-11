import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
abstract class Store with _$Store {
  const factory Store({
    required String id,
    required String merchantId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? storeType,
    required bool isActive,
    @Default(false) bool isOnlineEnabled,
    String? slug,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
}
