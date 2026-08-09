import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_settings.freezed.dart';
part 'merchant_settings.g.dart';

@freezed
abstract class MerchantSettings with _$MerchantSettings {
  const factory MerchantSettings({
    required String merchantId,
    @Default(true) bool waNotifications,
    @Default(true) bool lowStockAlerts,
    @Default(false) bool dailyReports,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MerchantSettings;

  factory MerchantSettings.fromJson(Map<String, Object?> json) =>
      _$MerchantSettingsFromJson(json);
}
