// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_return_session_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleReturnSessionResult _$BottleReturnSessionResultFromJson(
  Map<String, dynamic> json,
) => _BottleReturnSessionResult(
  totalBottlesReturned: (json['totalBottlesReturned'] as num).toInt(),
  totalRewardAmount: (json['totalRewardAmount'] as num).toInt(),
  rewardMode: $enumDecode(_$BottleRewardModeEnumMap, json['rewardMode']),
  customerPhone: json['customerPhone'] as String?,
  physicalCoupon: json['physicalCoupon'] == null
      ? null
      : BottlePhysicalCoupon.fromJson(
          json['physicalCoupon'] as Map<String, dynamic>,
        ),
  message: json['message'] as String,
);

Map<String, dynamic> _$BottleReturnSessionResultToJson(
  _BottleReturnSessionResult instance,
) => <String, dynamic>{
  'totalBottlesReturned': instance.totalBottlesReturned,
  'totalRewardAmount': instance.totalRewardAmount,
  'rewardMode': _$BottleRewardModeEnumMap[instance.rewardMode]!,
  'customerPhone': instance.customerPhone,
  'physicalCoupon': instance.physicalCoupon,
  'message': instance.message,
};

const _$BottleRewardModeEnumMap = {
  BottleRewardMode.digital: 'digital',
  BottleRewardMode.physical: 'physical',
};
