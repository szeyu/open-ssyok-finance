import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/dashboard/domain/projection_model.dart';
import 'package:ssyok_finance/features/dashboard/presentation/providers/projection_providers.dart';

void showProjectionDetailSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ProjectionDetailSheet(),
  );
}

class _ProjectionDetailSheet extends ConsumerWidget {
  const _ProjectionDetailSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projection = ref.watch(projectionDataProvider);
    final mode = ref.watch(projectionModeProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header with toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Year-by-Year Breakdown',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SegmentedButton<ProjectionMode>(
                      segments: const [
                        ButtonSegment(
                          value: ProjectionMode.nominal,
                          label: Text('Nominal'),
                        ),
                        ButtonSegment(
                          value: ProjectionMode.real,
                          label: Text('Real'),
                        ),
                      ],
                      selected: {mode},
                      onSelectionChanged: (selected) {
                        ref.read(projectionModeProvider.notifier).state =
                            selected.first;
                      },
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: WidgetStatePropertyAll(
                          theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Column headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text('Yr', style: theme.textTheme.labelSmall),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text('Age', style: theme.textTheme.labelSmall),
                    ),
                    Expanded(
                      child: Text('Assets',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right),
                    ),
                    Expanded(
                      child: Text('Debts',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right),
                    ),
                    Expanded(
                      child: Text('Net Worth',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Year rows
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: projection.length,
                  itemBuilder: (context, index) {
                    final p = projection[index];
                    final netWorth = mode == ProjectionMode.nominal
                        ? p.nominalNetWorth
                        : p.realNetWorth;
                    final isCurrentYear = index == 0;

                    return Container(
                      color: isCurrentYear
                          ? theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.3)
                          : index.isOdd
                              ? theme.colorScheme.surfaceContainerLowest
                              : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  '${p.year}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: isCurrentYear
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 32,
                                child: Text(
                                  '${p.age}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  p.totalAssets
                                      .toRinggit(showDecimals: false),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.green.shade700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  p.totalDebts
                                      .toRinggit(showDecimals: false),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.red.shade700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  netWorth.toRinggit(showDecimals: false),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          if (p.milestones.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: p.milestones.map((m) {
                                  final isGoal =
                                      m.type == MilestoneType.goalReached;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isGoal
                                          ? Colors.blue.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isGoal ? Icons.flag : Icons.check_circle,
                                          size: 12,
                                          color: isGoal
                                              ? Colors.blue.shade700
                                              : Colors.green.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          m.label,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: isGoal
                                                ? Colors.blue.shade700
                                                : Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
