// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$GoalTypeEnumMap, json['type']),
  name: json['name'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
  targetDate: DateTime.parse(json['targetDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'targetDate': instance.targetDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.emergencyFund: 'emergency_fund',
  GoalType.house: 'house',
  GoalType.education: 'education',
  GoalType.vacation: 'vacation',
  GoalType.retirement: 'retirement',
  GoalType.other: 'other',
};
