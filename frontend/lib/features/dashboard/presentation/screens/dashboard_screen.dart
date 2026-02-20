import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/plan/presentation/assets/asset_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/debts/debt_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/goals/goal_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';
import 'package:ssyok_finance/shared/widgets/animated_list_item.dart';
import 'package:ssyok_finance/shared/widgets/pressable.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).value;
    final profileAsync = ref.watch(userProfileProvider);
    final netWorth = ref.watch(netWorthProvider);

    return Scaffold(
      appBar: AppBar(
        title: profileAsync.when(
          data: (profile) {
            final hour = DateTime.now().hour;
            String greeting;
            if (hour < 12) {
              greeting = 'Good Morning';
            } else if (hour < 17) {
              greeting = 'Good Afternoon';
            } else {
              greeting = 'Good Evening';
            }
            return Text('$greeting, ${profile?.name ?? user?.displayName ?? 'there'}!');
          },
          loading: () => const Text('Dashboard'),
          error: (_, _) => const Text('Dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(assetsProvider);
          ref.invalidate(debtsProvider);
          ref.invalidate(goalsProvider);
          ref.invalidate(expensesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Net Worth Card
              AnimatedListItem(
                index: 0,
                child: _buildNetWorthCard(context, theme, netWorth),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              AnimatedListItem(
                index: 1,
                child: Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedListItem(
                index: 2,
                child: _buildQuickActionsGrid(context, theme),
              ),

              const SizedBox(height: 24),

              // Summary Cards
              AnimatedListItem(
                index: 3,
                child: Text(
                  'Summary',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedListItem(
                index: 4,
                child: _buildSummaryCards(context, theme, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetWorthCard(BuildContext context, ThemeData theme, double netWorth) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              netWorth.toRinggit(showDecimals: false),
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.push('/chat?prompt=net_worth'),
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text(
                '💬 Chat about this',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, ThemeData theme) {
    final actions = [
      _QuickAction(
        icon: Icons.add_circle,
        label: 'Add Asset',
        color: Colors.green,
        onTap: () => showAssetForm(context),
      ),
      _QuickAction(
        icon: Icons.flag,
        label: 'Add Goal',
        color: Colors.blue,
        onTap: () => showGoalForm(context),
      ),
      _QuickAction(
        icon: Icons.credit_card,
        label: 'Add Debt',
        color: Colors.orange,
        onTap: () => showDebtForm(context),
      ),
      _QuickAction(
        icon: Icons.receipt,
        label: 'Expenses',
        color: Colors.purple,
        onTap: () => context.push('/plan/expenses'),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: actions
          .map((action) => _buildQuickActionCard(theme, action))
          .toList(),
    );
  }

  Widget _buildQuickActionCard(ThemeData theme, _QuickAction action) {
    return Pressable(
      onTap: action.onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: 32, color: action.color),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, ThemeData theme, WidgetRef ref) {
    final totalAssets = ref.watch(totalAssetsProvider);
    final totalDebts = ref.watch(totalDebtsProvider);
    final totalExpenses = ref.watch(totalMonthlyExpensesProvider);
    final goalsAsync = ref.watch(goalsProvider);

    final activeGoals = goalsAsync.when(
      data: (goals) => goals.where((g) => !g.isCompleted).length,
      loading: () => 0,
      error: (_, _) => 0,
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Assets',
                totalAssets.toRinggit(showDecimals: false),
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Debts',
                totalDebts.toRinggit(showDecimals: false),
                Icons.credit_card,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Monthly Expenses',
                totalExpenses.toRinggit(showDecimals: false),
                Icons.receipt,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Active Goals',
                '$activeGoals',
                Icons.flag,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
