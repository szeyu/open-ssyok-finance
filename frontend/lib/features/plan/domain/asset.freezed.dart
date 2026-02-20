// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  AssetType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get monthlyContribution => throw _privateConstructorUsedError;
  double get growthRate => throw _privateConstructorUsedError;
  bool get isEmergencyFund => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Asset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call({
    String id,
    String userId,
    AssetType type,
    String name,
    double value,
    double monthlyContribution,
    double growthRate,
    bool isEmergencyFund,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? value = null,
    Object? monthlyContribution = null,
    Object? growthRate = null,
    Object? isEmergencyFund = null,
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
                      as AssetType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            monthlyContribution: null == monthlyContribution
                ? _value.monthlyContribution
                : monthlyContribution // ignore: cast_nullable_to_non_nullable
                      as double,
            growthRate: null == growthRate
                ? _value.growthRate
                : growthRate // ignore: cast_nullable_to_non_nullable
                      as double,
            isEmergencyFund: null == isEmergencyFund
                ? _value.isEmergencyFund
                : isEmergencyFund // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
    _$AssetImpl value,
    $Res Function(_$AssetImpl) then,
  ) = __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    AssetType type,
    String name,
    double value,
    double monthlyContribution,
    double growthRate,
    bool isEmergencyFund,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
    _$AssetImpl _value,
    $Res Function(_$AssetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? value = null,
    Object? monthlyContribution = null,
    Object? growthRate = null,
    Object? isEmergencyFund = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AssetImpl(
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
                  as AssetType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        monthlyContribution: null == monthlyContribution
            ? _value.monthlyContribution
            : monthlyContribution // ignore: cast_nullable_to_non_nullable
                  as double,
        growthRate: null == growthRate
            ? _value.growthRate
            : growthRate // ignore: cast_nullable_to_non_nullable
                  as double,
        isEmergencyFund: null == isEmergencyFund
            ? _value.isEmergencyFund
            : isEmergencyFund // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$AssetImpl implements _Asset {
  const _$AssetImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.value,
    this.monthlyContribution = 0.0,
    this.growthRate = 0.0,
    this.isEmergencyFund = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final AssetType type;
  @override
  final String name;
  @override
  final double value;
  @override
  @JsonKey()
  final double monthlyContribution;
  @override
  @JsonKey()
  final double growthRate;
  @override
  @JsonKey()
  final bool isEmergencyFund;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Asset(id: $id, userId: $userId, type: $type, name: $name, value: $value, monthlyContribution: $monthlyContribution, growthRate: $growthRate, isEmergencyFund: $isEmergencyFund, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution) &&
            (identical(other.growthRate, growthRate) ||
                other.growthRate == growthRate) &&
            (identical(other.isEmergencyFund, isEmergencyFund) ||
                other.isEmergencyFund == isEmergencyFund) &&
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
    value,
    monthlyContribution,
    growthRate,
    isEmergencyFund,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(this);
  }
}

abstract class _Asset implements Asset {
  const factory _Asset({
    required final String id,
    required final String userId,
    required final AssetType type,
    required final String name,
    required final double value,
    final double monthlyContribution,
    final double growthRate,
    final bool isEmergencyFund,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AssetImpl;

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  AssetType get type;
  @override
  String get name;
  @override
  double get value;
  @override
  double get monthlyContribution;
  @override
  double get growthRate;
  @override
  bool get isEmergencyFund;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
