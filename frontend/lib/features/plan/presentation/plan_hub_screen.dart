import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/theme/colors.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';
import 'package:ssyok_finance/shared/widgets/animated_list_item.dart';
import 'package:ssyok_finance/shared/widgets/pressable.dart';

class PlanHubScreen extends ConsumerWidget {
  const PlanHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalAssets = ref.watch(totalAssetsProvider);
    final totalMonthlyExpenses = ref.watch(totalMonthlyExpensesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AnimatedListItem(
                index: 0,
                child: Text(
                  'Financial Plan',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary Card
                    AnimatedListItem(
                      index: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Assets',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    totalAssets.toRinggit(),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white24,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monthly Expenses',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${totalMonthlyExpenses.toRinggit()}/mo',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plan Items List — each item staggered with AnimatedListItem
                    AnimatedListItem(
                      index: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _PlanListItem(
                              icon: Icons.account_balance_wallet_outlined,
                              label: 'Assets',
                              subtitle: 'Savings, investments & property',
                              onTap: () => context.push('/plan/assets'),
                              isFirst: true,
                            ),
                            _PlanListItem(
                              icon: Icons.flag_outlined,
                              label: 'Goals',
                              subtitle: 'Financial milestones & targets',
                              onTap: () => context.push('/plan/goals'),
                            ),
                            _PlanListItem(
                              icon: Icons.credit_card_outlined,
                              label: 'Debts',
                              subtitle: 'Loans, mortgages & credit cards',
                              onTap: () => context.push('/plan/debts'),
                            ),
                            _PlanListItem(
                              icon: Icons.receipt_long_outlined,
                              label: 'Expenses',
                              subtitle: 'Monthly spending categories',
                              onTap: () => context.push('/plan/expenses'),
                            ),
                            _PlanListItem(
                              icon: Icons.shield_outlined,
                              label: 'Safety Net',
                              subtitle: 'Emergency fund & insurance',
                              onTap: () => context.push('/plan/safetynet'),
                            ),
                            _PlanListItem(
                              icon: Icons.calculate_outlined,
                              label: 'Calculator',
                              subtitle: 'Compound interest & FIRE',
                              onTap: () => context.go('/calculator'),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanListItem extends StatelessWidget {
  const _PlanListItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Pressable(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(16) : Radius.zero,
              bottom: isLast ? const Radius.circular(16) : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 76,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}
