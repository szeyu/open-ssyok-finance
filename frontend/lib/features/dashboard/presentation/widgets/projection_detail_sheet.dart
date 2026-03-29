import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/dashboard/domain/projection_model.dart';
import 'package:ssyok_finance/features/dashboard/presentation/providers/projection_providers.dart';
import 'package:ssyok_finance/features/dashboard/presentation/widgets/net_worth_projection_card.dart';

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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                    buildModeToggle(theme, ref, mode),
                  ],
                ),
              ),

              // Column headers
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text('Yr',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text('Age',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                    ),
                    Expanded(
                      child: Text('Assets',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right),
                    ),
                    Expanded(
                      child: Text('Debts',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right),
                    ),
                    Expanded(
                      child: Text('Net Worth',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
              ),

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
                      decoration: BoxDecoration(
                        color: isCurrentYear
                            ? theme.colorScheme.primary.withValues(alpha: 0.06)
                            : index.isOdd
                                ? theme.colorScheme.surfaceContainerLowest
                                : null,
                        border: isCurrentYear
                            ? Border(
                                left: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                ),
                              )
                            : null,
                      ),
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
                                width: 36,
                                child: Text(
                                  '${p.age}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  p.totalAssets
                                      .toRinggit(showDecimals: false),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF059669),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  p.totalDebts
                                      .toRinggit(showDecimals: false),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w500,
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
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: p.milestones.map((m) {
                                  final isGoal =
                                      m.type == MilestoneType.goalReached;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isGoal
                                          ? const Color(0xFF3B82F6)
                                              .withValues(alpha: 0.1)
                                          : const Color(0xFF059669)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isGoal
                                              ? Icons.flag_rounded
                                              : Icons.check_circle_rounded,
                                          size: 12,
                                          color: isGoal
                                              ? const Color(0xFF2563EB)
                                              : const Color(0xFF059669),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          m.label,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: isGoal
                                                ? const Color(0xFF1D4ED8)
                                                : const Color(0xFF047857),
                                            fontWeight: FontWeight.w600,
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
