// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      monthlyAmount: (json['monthlyAmount'] as num).toDouble(),
      inflationRate: (json['inflationRate'] as num?)?.toDouble() ?? 3.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'monthlyAmount': instance.monthlyAmount,
      'inflationRate': instance.inflationRate,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.housing: 'housing',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.education: 'education',
  ExpenseCategory.healthcare: 'healthcare',
  ExpenseCategory.other: 'other',
};
