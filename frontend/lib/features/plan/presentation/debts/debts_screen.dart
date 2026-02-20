import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/plan/presentation/debts/debt_form_modal.dart';
import 'package:ssyok_finance/features/plan/presentation/debts/widgets/debt_card.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';
import 'package:ssyok_finance/shared/widgets/empty_state.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final debtsAsync = ref.watch(debtsProvider);
    final totalDebts = ref.watch(totalDebtsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat about debts',
            onPressed: () => context.push('/chat?prompt=debts'),
          ),
        ],
      ),
      body: debtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (debts) {
          if (debts.isEmpty) {
            return EmptyState(
              icon: Icons.credit_card_off,
              title: 'No debts tracked',
              message:
                  'Track your loans and credit cards to see payoff timelines and total interest costs.',
              actionLabel: 'Add Debt',
              onAction: () => showDebtForm(context),
            );
          }

          // Sort by interest rate descending (highest first — avalanche method)
          final sorted = [...debts]
            ..sort((a, b) => b.interestRate.compareTo(a.interestRate));

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.errorContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Debt',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                        Text(
                          totalDebts.toRinggit(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${debts.length} debt${debts.length != 1 ? 's' : ''}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          'Sorted by interest rate',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    final debt = sorted[index];
                    return DebtCard(
                      debt: debt,
                      onEdit: () => showDebtForm(context, debt: debt),
                      onDelete: () =>
                          _confirmDelete(context, ref, debt.userId, debt.id, debt.name),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDebtForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Debt'),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String userId, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Debt'),
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
      await ref.read(debtsRepositoryProvider).delete(userId, id);
    }
  }
}
