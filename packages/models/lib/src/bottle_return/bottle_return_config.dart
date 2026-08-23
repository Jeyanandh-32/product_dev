import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle_return_config.freezed.dart';
part 'bottle_return_config.g.dart';

/// Developer-configured store activation settings for the bottle return module.
@freezed
abstract class BottleReturnConfig with _$BottleReturnConfig {
  const factory BottleReturnConfig({
    required String storeId,
    @Default(true) bool isEnabled,
    @Default(10) int rewardAmountInRupees,
    String? iotApiKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BottleReturnConfig;

  factory BottleReturnConfig.fromJson(Map<String, dynamic> json) =>
      _$BottleReturnConfigFromJson(json);
}
