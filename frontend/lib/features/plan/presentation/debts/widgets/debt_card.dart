import 'package:flutter/material.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/plan/domain/debt.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DebtCard({
    super.key,
    required this.debt,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final months = debt.monthsToPayOff;
    final years = months ~/ 12;
    final remainingMonths = months % 12;

    String payoffLabel;
    if (months == 0) {
      payoffLabel = 'Unknown';
    } else if (years > 0) {
      payoffLabel =
          '$years yr${years != 1 ? 's' : ''} ${remainingMonths > 0 ? '$remainingMonths mo' : ''}';
    } else {
      payoffLabel = '$months mo';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _typeIcon(debt.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debt.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          debt.type.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _infoChip(
                      context,
                      label: 'Balance',
                      value: debt.balance.toRinggit(),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _infoChip(
                      context,
                      label: 'Monthly',
                      value: debt.monthlyPayment.toRinggit(),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _infoChip(
                      context,
                      label: 'Interest',
                      value: '${debt.interestRate.toStringAsFixed(1)}%/yr',
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              if (months > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Paid off in $payoffLabel · Interest: ${debt.totalInterest.toRinggit()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
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

  Widget _typeIcon(DebtType type) {
    final (icon, color) = switch (type) {
      DebtType.ptptn => (Icons.school, Colors.indigo),
      DebtType.creditCard => (Icons.credit_card, Colors.red),
      DebtType.personalLoan => (Icons.person, Colors.orange),
      DebtType.carLoan => (Icons.directions_car, Colors.blue),
      DebtType.homeLoan => (Icons.home, Colors.brown),
      DebtType.other => (Icons.receipt_long, Colors.grey),
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

  Widget _infoChip(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          Text(value,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
