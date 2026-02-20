import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

/// Types of assets
enum AssetType {
  @JsonValue('savings')
  savings,
  @JsonValue('investment')
  investment,
  @JsonValue('property')
  property,
  @JsonValue('retirement')
  retirement,
  @JsonValue('other')
  other,
}

extension AssetTypeExtension on AssetType {
  String get displayName {
    switch (this) {
      case AssetType.savings:
        return 'Savings Account';
      case AssetType.investment:
        return 'Investment (ASB, Stocks, etc.)';
      case AssetType.property:
        return 'Property';
      case AssetType.retirement:
        return 'Retirement (EPF, PRS)';
      case AssetType.other:
        return 'Other';
    }
  }
}

@freezed
class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String userId,
    required AssetType type,
    required String name,
    required double value,
    @Default(0.0) double monthlyContribution,
    @Default(0.0) double growthRate,
    @Default(false) bool isEmergencyFund,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
