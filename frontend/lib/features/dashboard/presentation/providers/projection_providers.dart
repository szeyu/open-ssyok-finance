import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/dashboard/data/projection_engine.dart';
import 'package:ssyok_finance/features/dashboard/domain/projection_model.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

/// Toggle between nominal and real (inflation-adjusted) projection
final projectionModeProvider =
    StateProvider<ProjectionMode>((_) => ProjectionMode.nominal);

/// Computed 20-year projection — reactive to upstream data changes
final projectionDataProvider = Provider<List<ProjectionYear>>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? [];
  final debts = ref.watch(debtsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
  final profile = ref.watch(userProfileProvider).valueOrNull;

  if (assets.isEmpty && debts.isEmpty) return [];

  return computeProjection(
    assets: assets,
    debts: debts,
    goals: goals,
    expenses: expenses,
    userAge: profile?.age ?? 25,
  );
});

/// Whether projection data is still loading
final projectionLoadingProvider = Provider<bool>((ref) {
  return ref.watch(assetsProvider).isLoading ||
      ref.watch(debtsProvider).isLoading;
});
