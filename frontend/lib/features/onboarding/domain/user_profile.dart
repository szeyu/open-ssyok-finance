import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User type categories for personalized financial advice
enum UserType {
  @JsonValue('debt_payer')
  debtPayer,
  @JsonValue('fresh_start')
  freshStart,
  @JsonValue('building_wealth')
  buildingWealth,
  @JsonValue('fire_focused')
  fireFocused,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.debtPayer:
        return 'Debt Payer';
      case UserType.freshStart:
        return 'Fresh Start';
      case UserType.buildingWealth:
        return 'Building Wealth';
      case UserType.fireFocused:
        return 'FIRE Focused';
    }
  }

  String get description {
    switch (this) {
      case UserType.debtPayer:
        return 'Paying off PTPTN or credit cards';
      case UserType.freshStart:
        return 'Just started earning, building habits';
      case UserType.buildingWealth:
        return 'Growing savings and investments';
      case UserType.fireFocused:
        return 'Aiming for Financial Independence';
    }
  }
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String name,
    required int age,
    required UserType userType,
    @Default('MYR') String currency,
    @Default(false) bool hasCompletedOnboarding,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
