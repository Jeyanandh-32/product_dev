import 'package:freezed_annotation/freezed_annotation.dart';

import '../payment_gateway/payment_gateway_enums.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// Represents a physical or online merchant storefront.
@freezed
abstract class Store with _$Store {
  /// Creates a [Store] instance.
  const factory Store({
    required String id,
    required String merchantId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? storeType,
    required bool isActive,
    @Default(false) bool isOnlineEnabled,
    @Default(false) bool isBottleReturnEnabled,
    @Default(true) bool isOperational,
    @Default(PaymentProvider.phonepe) PaymentProvider? activePaymentProvider,
    String? slug,
  }) = _Store;

  /// Creates a [Store] from a JSON map.
  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);
}
