import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/plan/data/assets_repository.dart';
import 'package:ssyok_finance/features/plan/data/debts_repository.dart';
import 'package:ssyok_finance/features/plan/data/expenses_repository.dart';
import 'package:ssyok_finance/features/plan/data/goals_repository.dart';
import 'package:ssyok_finance/features/plan/domain/asset.dart';
import 'package:ssyok_finance/features/plan/domain/debt.dart';
import 'package:ssyok_finance/features/plan/domain/expense.dart';
import 'package:ssyok_finance/features/plan/domain/goal.dart';

// Repository providers
final assetsRepositoryProvider = Provider<AssetsRepository>((ref) {
  return AssetsRepository();
});

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository();
});

final debtsRepositoryProvider = Provider<DebtsRepository>((ref) {
  return DebtsRepository();
});

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepository();
});

// Assets providers
final assetsProvider = StreamProvider<List<Asset>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(assetsRepositoryProvider);
  return repository.watchAll(user.uid);
});

final totalAssetsProvider = Provider<double>((ref) {
  final assetsAsync = ref.watch(assetsProvider);
  return assetsAsync.when(
    data: (assets) => assets.fold(0.0, (sum, asset) => sum + asset.value),
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

// Goals providers
final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(goalsRepositoryProvider);
  return repository.watchAll(user.uid);
});

final totalGoalsTargetProvider = Provider<double>((ref) {
  final goalsAsync = ref.watch(goalsProvider);
  return goalsAsync.when(
    data: (goals) => goals.fold(0.0, (sum, goal) => sum + goal.targetAmount),
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

final totalGoalsCurrentProvider = Provider<double>((ref) {
  final goalsAsync = ref.watch(goalsProvider);
  return goalsAsync.when(
    data: (goals) => goals.fold(0.0, (sum, goal) => sum + goal.currentAmount),
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

// Debts providers
final debtsProvider = StreamProvider<List<Debt>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(debtsRepositoryProvider);
  return repository.watchAll(user.uid);
});

final totalDebtsProvider = Provider<double>((ref) {
  final debtsAsync = ref.watch(debtsProvider);
  return debtsAsync.when(
    data: (debts) => debts.fold(0.0, (sum, debt) => sum + debt.balance),
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

// Expenses providers
final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(expensesRepositoryProvider);
  return repository.watchAll(user.uid);
});

final totalMonthlyExpensesProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expensesProvider);
  return expensesAsync.when(
    data: (expenses) =>
        expenses.fold(0.0, (sum, expense) => sum + expense.monthlyAmount),
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

// Net worth provider
final netWorthProvider = Provider<double>((ref) {
  final totalAssets = ref.watch(totalAssetsProvider);
  final totalDebts = ref.watch(totalDebtsProvider);
  return totalAssets - totalDebts;
});
