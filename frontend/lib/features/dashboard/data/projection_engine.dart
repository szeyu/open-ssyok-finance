import 'dart:math';

import 'package:ssyok_finance/features/dashboard/domain/projection_model.dart';
import 'package:ssyok_finance/features/plan/domain/asset.dart';
import 'package:ssyok_finance/features/plan/domain/debt.dart';
import 'package:ssyok_finance/features/plan/domain/expense.dart';
import 'package:ssyok_finance/features/plan/domain/goal.dart';

List<ProjectionYear> computeProjection({
  required List<Asset> assets,
  required List<Debt> debts,
  required List<Goal> goals,
  required List<Expense> expenses,
  required int userAge,
  int years = 20,
}) {
  final totalAssetValue = assets.fold(0.0, (sum, a) => sum + a.value);
  final totalMonthlyExpenses =
      expenses.fold(0.0, (sum, e) => sum + e.monthlyAmount);

  // Weighted growth rate from assets
  final weightedGrowthRate = totalAssetValue > 0
      ? assets.fold(0.0, (sum, a) => sum + a.value * a.growthRate / 100) /
          totalAssetValue
      : 0.0;

  // Yearly contributions from all assets
  final yearlyContributions =
      assets.fold(0.0, (sum, a) => sum + a.monthlyContribution) * 12;

  // Personal inflation rate from expenses
  final personalInflation = totalMonthlyExpenses > 0
      ? expenses.fold(
              0.0,
              (sum, e) =>
                  sum + e.monthlyAmount * e.inflationRate / 100) /
          totalMonthlyExpenses
      : 0.03;

  final currentCalendarYear = DateTime.now().year;

  // Track individual debt balances
  final debtBalances = <String, double>{};
  final debtPaidOff = <String, bool>{};
  for (final debt in debts) {
    debtBalances[debt.id] = debt.balance;
    debtPaidOff[debt.id] = false;
  }

  var currentAssets = totalAssetValue;
  final projection = <ProjectionYear>[];

  for (var year = 0; year <= years; year++) {
    final milestones = <Milestone>[];

    if (year > 0) {
      // Grow assets
      currentAssets =
          currentAssets * (1 + weightedGrowthRate) + yearlyContributions;

      // Reduce each debt individually
      for (final debt in debts) {
        if (debtPaidOff[debt.id]!) continue;

        var balance = debtBalances[debt.id]!;
        final monthlyInterest = debt.interestRate / 100 / 12;

        // Simulate 12 months of payments
        for (var m = 0; m < 12; m++) {
          balance += balance * monthlyInterest;
          balance -= debt.monthlyPayment;
          if (balance <= 0) {
            balance = 0;
            break;
          }
        }

        // Detect debt paid off
        if (balance <= 0 && !debtPaidOff[debt.id]!) {
          debtPaidOff[debt.id] = true;
          milestones.add(Milestone(
            label: '${debt.name} paid off',
            type: MilestoneType.debtPaidOff,
          ));
        }

        debtBalances[debt.id] = balance;
      }
    }

    final totalDebtsNow =
        debtBalances.values.fold(0.0, (sum, b) => sum + b);
    final nominalNetWorth = currentAssets - totalDebtsNow;
    final realNetWorth =
        nominalNetWorth / pow(1 + personalInflation, year);
    final calendarYear = currentCalendarYear + year;

    // Goal milestone detection
    if (year > 0) {
      for (final goal in goals) {
        if (goal.targetDate.year <= calendarYear &&
            nominalNetWorth >= goal.targetAmount) {
          milestones.add(Milestone(
            label: '${goal.name} reachable',
            type: MilestoneType.goalReached,
          ));
        }
      }
    }

    projection.add(ProjectionYear(
      year: year,
      calendarYear: calendarYear,
      age: userAge + year,
      totalAssets: currentAssets,
      totalDebts: totalDebtsNow,
      nominalNetWorth: nominalNetWorth,
      realNetWorth: realNetWorth,
      milestones: milestones,
    ));
  }

  return projection;
}
