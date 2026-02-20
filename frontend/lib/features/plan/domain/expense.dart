import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// Fixed expense categories
enum ExpenseCategory {
  @JsonValue('food')
  food,
  @JsonValue('housing')
  housing,
  @JsonValue('transport')
  transport,
  @JsonValue('education')
  education,
  @JsonValue('healthcare')
  healthcare,
  @JsonValue('other')
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food & Dining';
      case ExpenseCategory.housing:
        return 'Housing';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.healthcare:
        return 'Healthcare';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get description {
    switch (this) {
      case ExpenseCategory.food:
        return 'Groceries, mamak, restaurants';
      case ExpenseCategory.housing:
        return 'Rent, utilities, maintenance';
      case ExpenseCategory.transport:
        return 'Petrol, Grab, public transport';
      case ExpenseCategory.education:
        return 'Courses, books, certifications';
      case ExpenseCategory.healthcare:
        return 'Medical, insurance, supplements';
      case ExpenseCategory.other:
        return 'Entertainment, shopping, etc.';
    }
  }
}

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String userId,
    required ExpenseCategory category,
    required double monthlyAmount,
    @Default(3.0) double inflationRate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
