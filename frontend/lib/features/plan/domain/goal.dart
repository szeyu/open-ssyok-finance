import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

/// Types of financial goals
enum GoalType {
  @JsonValue('emergency_fund')
  emergencyFund,
  @JsonValue('house')
  house,
  @JsonValue('education')
  education,
  @JsonValue('vacation')
  vacation,
  @JsonValue('retirement')
  retirement,
  @JsonValue('other')
  other,
}

extension GoalTypeExtension on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.emergencyFund:
        return 'Emergency Fund';
      case GoalType.house:
        return 'House / Property';
      case GoalType.education:
        return 'Education';
      case GoalType.vacation:
        return 'Vacation';
      case GoalType.retirement:
        return 'Retirement';
      case GoalType.other:
        return 'Other';
    }
  }
}

@freezed
class Goal with _$Goal {
  const Goal._();

  const factory Goal({
    required String id,
    required String userId,
    required GoalType type,
    required String name,
    required double targetAmount,
    @Default(0.0) double currentAmount,
    required DateTime targetDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Goal;

  /// Calculate progress percentage (0-100)
  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return ((currentAmount / targetAmount) * 100).clamp(0, 100);
  }

  /// Calculate days remaining until target date
  int get daysRemaining {
    final now = DateTime.now();
    return targetDate.difference(now).inDays;
  }

  /// Check if goal is completed
  bool get isCompleted => currentAmount >= targetAmount;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
