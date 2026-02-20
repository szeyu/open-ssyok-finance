// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Debt _$DebtFromJson(Map<String, dynamic> json) {
  return _Debt.fromJson(json);
}

/// @nodoc
mixin _$Debt {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DebtType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double get interestRate => throw _privateConstructorUsedError;
  double get monthlyPayment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Debt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Debt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtCopyWith<Debt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtCopyWith<$Res> {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) then) =
      _$DebtCopyWithImpl<$Res, Debt>;
  @useResult
  $Res call({
    String id,
    String userId,
    DebtType type,
    String name,
    double balance,
    double interestRate,
    double monthlyPayment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$DebtCopyWithImpl<$Res, $Val extends Debt>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Debt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? balance = null,
    Object? interestRate = null,
    Object? monthlyPayment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as DebtType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            interestRate: null == interestRate
                ? _value.interestRate
                : interestRate // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyPayment: null == monthlyPayment
                ? _value.monthlyPayment
                : monthlyPayment // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DebtImplCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$$DebtImplCopyWith(
    _$DebtImpl value,
    $Res Function(_$DebtImpl) then,
  ) = __$$DebtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DebtType type,
    String name,
    double balance,
    double interestRate,
    double monthlyPayment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$DebtImplCopyWithImpl<$Res>
    extends _$DebtCopyWithImpl<$Res, _$DebtImpl>
    implements _$$DebtImplCopyWith<$Res> {
  __$$DebtImplCopyWithImpl(_$DebtImpl _value, $Res Function(_$DebtImpl) _then)
    : super(_value, _then);

  /// Create a copy of Debt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? balance = null,
    Object? interestRate = null,
    Object? monthlyPayment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DebtImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as DebtType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        interestRate: null == interestRate
            ? _value.interestRate
            : interestRate // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyPayment: null == monthlyPayment
            ? _value.monthlyPayment
            : monthlyPayment // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtImpl extends _Debt {
  const _$DebtImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.balance,
    required this.interestRate,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$DebtImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DebtType type;
  @override
  final String name;
  @override
  final double balance;
  @override
  final double interestRate;
  @override
  final double monthlyPayment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Debt(id: $id, userId: $userId, type: $type, name: $name, balance: $balance, interestRate: $interestRate, monthlyPayment: $monthlyPayment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.monthlyPayment, monthlyPayment) ||
                other.monthlyPayment == monthlyPayment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    name,
    balance,
    interestRate,
    monthlyPayment,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Debt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtImplCopyWith<_$DebtImpl> get copyWith =>
      __$$DebtImplCopyWithImpl<_$DebtImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtImplToJson(this);
  }
}

abstract class _Debt extends Debt {
  const factory _Debt({
    required final String id,
    required final String userId,
    required final DebtType type,
    required final String name,
    required final double balance,
    required final double interestRate,
    required final double monthlyPayment,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$DebtImpl;
  const _Debt._() : super._();

  factory _Debt.fromJson(Map<String, dynamic> json) = _$DebtImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DebtType get type;
  @override
  String get name;
  @override
  double get balance;
  @override
  double get interestRate;
  @override
  double get monthlyPayment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Debt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtImplCopyWith<_$DebtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
