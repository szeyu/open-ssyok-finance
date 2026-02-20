import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/plan/domain/expense.dart';
import 'package:ssyok_finance/features/plan/presentation/providers/plan_providers.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expensesAsync = ref.watch(expensesProvider);
    final totalExpenses = ref.watch(totalMonthlyExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat about expenses',
            onPressed: () => context.push('/chat?prompt=expenses'),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (expenses) {
          final expenseMap = {
            for (final e in expenses) e.category: e,
          };

          return Column(
            children: [
              // Total bar
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.secondaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Monthly',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          totalExpenses.toRinggit(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${totalExpenses.toRinggit()}/month',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Tap a category to set your monthly amount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...ExpenseCategory.values.map((category) {
                      final existing = expenseMap[category];
                      return _ExpenseCategoryCard(
                        category: category,
                        expense: existing,
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExpenseCategoryCard extends ConsumerStatefulWidget {
  final ExpenseCategory category;
  final Expense? expense;

  const _ExpenseCategoryCard({
    required this.category,
    this.expense,
  });

  @override
  ConsumerState<_ExpenseCategoryCard> createState() =>
      _ExpenseCategoryCardState();
}

class _ExpenseCategoryCardState extends ConsumerState<_ExpenseCategoryCard> {
  bool _isEditing = false;
  late final TextEditingController _amountController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense != null
          ? widget.expense!.monthlyAmount.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(expensesRepositoryProvider);

      final now = DateTime.now();
      if (widget.expense == null) {
        if (amount > 0) {
          await repo.add(Expense(
            id: '',
            userId: user.uid,
            category: widget.category,
            monthlyAmount: amount,
            createdAt: now,
            updatedAt: now,
          ));
        }
      } else {
        if (amount <= 0) {
          await repo.delete(user.uid, widget.expense!.id);
        } else {
          await repo.update(widget.expense!.copyWith(
            monthlyAmount: amount,
            updatedAt: now,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isEditing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = widget.category;
    final expense = widget.expense;
    final hasAmount = expense != null && expense.monthlyAmount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => _isEditing = !_isEditing),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _categoryIcon(category),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          category.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasAmount)
                    Text(
                      expense.monthlyAmount.toRinggit(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    )
                  else
                    Text(
                      'Not set',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _isEditing ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
              if (_isEditing) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Monthly Amount (RM)',
                          hintText: '0.00',
                          prefixText: 'RM ',
                          border: OutlineInputBorder(),
                          helperText: 'Set to 0 to remove',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[\d.,]')),
                        ],
                        autofocus: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryIcon(ExpenseCategory category) {
    final (icon, color) = switch (category) {
      ExpenseCategory.food => (Icons.restaurant, Colors.orange),
      ExpenseCategory.housing => (Icons.home, Colors.brown),
      ExpenseCategory.transport => (Icons.directions_car, Colors.blue),
      ExpenseCategory.education => (Icons.school, Colors.indigo),
      ExpenseCategory.healthcare => (Icons.local_hospital, Colors.red),
      ExpenseCategory.other => (Icons.category, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
