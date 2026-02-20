// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebtImpl _$$DebtImplFromJson(Map<String, dynamic> json) => _$DebtImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$DebtTypeEnumMap, json['type']),
  name: json['name'] as String,
  balance: (json['balance'] as num).toDouble(),
  interestRate: (json['interestRate'] as num).toDouble(),
  monthlyPayment: (json['monthlyPayment'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$DebtImplToJson(_$DebtImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$DebtTypeEnumMap[instance.type]!,
      'name': instance.name,
      'balance': instance.balance,
      'interestRate': instance.interestRate,
      'monthlyPayment': instance.monthlyPayment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DebtTypeEnumMap = {
  DebtType.ptptn: 'ptptn',
  DebtType.creditCard: 'credit_card',
  DebtType.personalLoan: 'personal_loan',
  DebtType.carLoan: 'car_loan',
  DebtType.homeLoan: 'home_loan',
  DebtType.other: 'other',
};
