import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

/// Types of debts
enum DebtType {
  @JsonValue('ptptn')
  ptptn,
  @JsonValue('credit_card')
  creditCard,
  @JsonValue('personal_loan')
  personalLoan,
  @JsonValue('car_loan')
  carLoan,
  @JsonValue('home_loan')
  homeLoan,
  @JsonValue('other')
  other,
}

extension DebtTypeExtension on DebtType {
  String get displayName {
    switch (this) {
      case DebtType.ptptn:
        return 'PTPTN';
      case DebtType.creditCard:
        return 'Credit Card';
      case DebtType.personalLoan:
        return 'Personal Loan';
      case DebtType.carLoan:
        return 'Car Loan';
      case DebtType.homeLoan:
        return 'Home Loan';
      case DebtType.other:
        return 'Other';
    }
  }
}

@freezed
class Debt with _$Debt {
  const Debt._();

  const factory Debt({
    required String id,
    required String userId,
    required DebtType type,
    required String name,
    required double balance,
    required double interestRate,
    required double monthlyPayment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Debt;

  /// Calculate months to pay off (simple calculation)
  int get monthsToPayOff {
    if (monthlyPayment <= 0 || balance <= 0) return 0;
    final monthlyInterest = interestRate / 100 / 12;
    if (monthlyInterest == 0) {
      return (balance / monthlyPayment).ceil();
    }
    // Using amortization formula
    final numerator = log((monthlyPayment / (monthlyPayment - balance * monthlyInterest)).abs());
    final denominator = log(1 + monthlyInterest);
    final months = numerator / denominator;
    return months.isFinite && months > 0 ? months.ceil() : 0;
  }

  /// Calculate total interest paid
  double get totalInterest {
    final total = monthlyPayment * monthsToPayOff;
    return (total - balance).clamp(0, double.infinity);
  }

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
}
