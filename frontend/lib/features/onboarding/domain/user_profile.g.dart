// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      currency: json['currency'] as String? ?? 'MYR',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'age': instance.age,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'currency': instance.currency,
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
    };

const _$UserTypeEnumMap = {
  UserType.debtPayer: 'debt_payer',
  UserType.freshStart: 'fresh_start',
  UserType.buildingWealth: 'building_wealth',
  UserType.fireFocused: 'fire_focused',
};
