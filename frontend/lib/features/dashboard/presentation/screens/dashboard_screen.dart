import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/app/theme/shadows.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart';
import 'package:ssyok_finance/features/plan/presentation/assets/asset_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/debts/debt_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/goals/goal_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';
import 'package:ssyok_finance/shared/widgets/animated_list_item.dart';
import 'package:ssyok_finance/features/dashboard/presentation/widgets/net_worth_projection_card.dart';
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
              const SizedBox(height: 16),
              AnimatedListItem(
                index: 1,
                child: const NetWorthProjectionCard(),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              AnimatedListItem(
                index: 2,
                child: Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedListItem(
                index: 3,
                child: _buildQuickActionsGrid(context, theme),
              ),

              const SizedBox(height: 24),

              // Summary Cards
              AnimatedListItem(
                index: 4,
                child: Text(
                  'Summary',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedListItem(
                index: 5,
                child: _buildSummaryCards(context, theme, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetWorthCard(BuildContext context, ThemeData theme, double netWorth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            HSLColor.fromColor(theme.colorScheme.primary)
                .withLightness(0.32)
                .toColor(),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Radial gradient overlay for glass-like depth
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Worth',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  netWorth.toRinggit(showDecimals: false),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push('/chat?prompt=net_worth'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat, color: Colors.white.withValues(alpha: 0.9), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Chat about this',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, size: 24, color: action.color),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                'Total Assets',
                totalAssets.toRinggit(showDecimals: false),
                Icons.trending_up_rounded,
                const Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Total Debts',
                totalDebts.toRinggit(showDecimals: false),
                Icons.credit_card_rounded,
                const Color(0xFFDC2626),
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
                'Monthly Exp.',
                totalExpenses.toRinggit(showDecimals: false),
                Icons.receipt_long_rounded,
                const Color(0xFFD97706),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                theme,
                'Active Goals',
                '$activeGoals',
                Icons.flag_rounded,
                const Color(0xFF2563EB),
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
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
        border: Border(
          left: BorderSide(color: color, width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
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
