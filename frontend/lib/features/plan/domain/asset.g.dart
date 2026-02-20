// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetImpl _$$AssetImplFromJson(Map<String, dynamic> json) => _$AssetImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$AssetTypeEnumMap, json['type']),
  name: json['name'] as String,
  value: (json['value'] as num).toDouble(),
  monthlyContribution: (json['monthlyContribution'] as num?)?.toDouble() ?? 0.0,
  growthRate: (json['growthRate'] as num?)?.toDouble() ?? 0.0,
  isEmergencyFund: json['isEmergencyFund'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AssetImplToJson(_$AssetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'name': instance.name,
      'value': instance.value,
      'monthlyContribution': instance.monthlyContribution,
      'growthRate': instance.growthRate,
      'isEmergencyFund': instance.isEmergencyFund,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AssetTypeEnumMap = {
  AssetType.savings: 'savings',
  AssetType.investment: 'investment',
  AssetType.property: 'property',
  AssetType.retirement: 'retirement',
  AssetType.other: 'other',
};
