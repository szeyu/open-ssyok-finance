import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/plan/presentation/goals/goal_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/goals/widgets/goal_card.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';
import 'package:ssyok_finance/shared/widgets/empty_state.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);
    final totalTarget = ref.watch(totalGoalsTargetProvider);
    final totalCurrent = ref.watch(totalGoalsCurrentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat about goals',
            onPressed: () => context.push('/chat?prompt=goals'),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyState(
              icon: Icons.flag,
              title: 'No goals yet',
              message:
                  'Set financial goals to stay focused — emergency fund, house, education, and more.',
              actionLabel: 'Add First Goal',
              onAction: () => showGoalForm(context),
            );
          }

          final completed = goals.where((g) => g.isCompleted).length;
          final overallProgress =
              totalTarget > 0 ? (totalCurrent / totalTarget * 100) : 0.0;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.primaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Progress',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              '${totalCurrent.toRinggit()} / ${totalTarget.toRinggit()}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$completed/${goals.length} complete',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (overallProgress / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${overallProgress.toStringAsFixed(0)}% overall',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GoalCard(
                      goal: goal,
                      onEdit: () => showGoalForm(context, goal: goal),
                      onDelete: () =>
                          _confirmDelete(context, ref, goal.userId, goal.id, goal.name),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showGoalForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Goal'),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String userId, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Delete "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(goalsRepositoryProvider).delete(userId, id);
    }
  }
}
