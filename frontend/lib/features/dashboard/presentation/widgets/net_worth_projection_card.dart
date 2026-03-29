import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/app/theme/shadows.dart';
import 'package:ssyok_finance/core/extensions/double_extensions.dart';
import 'package:ssyok_finance/features/dashboard/domain/projection_model.dart';
import 'package:ssyok_finance/features/dashboard/presentation/providers/projection_providers.dart';
import 'package:ssyok_finance/features/dashboard/presentation/widgets/projection_detail_sheet.dart';
import 'package:ssyok_finance/shared/widgets/pressable.dart';

class NetWorthProjectionCard extends ConsumerWidget {
  const NetWorthProjectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projection = ref.watch(projectionDataProvider);
    final isLoading = ref.watch(projectionLoadingProvider);
    final mode = ref.watch(projectionModeProvider);

    if (isLoading) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (projection.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.show_chart, size: 40, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Add assets or debts to see your projection',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final today = projection.first;
    final future = projection.last;
    final todayValue = mode == ProjectionMode.nominal
        ? today.nominalNetWorth
        : today.realNetWorth;
    final futureValue = mode == ProjectionMode.nominal
        ? future.nominalNetWorth
        : future.realNetWorth;
    final isPositiveGrowth = futureValue >= todayValue;

    return Pressable(
      onTap: () => showProjectionDetailSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Net Worth Projection',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      buildModeToggle(theme, ref, mode),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Summary row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              todayValue.toRinggit(showDecimals: false),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'In 20 years',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              futureValue.toRinggit(showDecimals: false),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isPositiveGrowth
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Chart
            SizedBox(
              height: 180,
              child: _ProjectionChart(projection: projection, mode: mode),
            ),
            const SizedBox(height: 8),

            // Tap hint
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Tap for full breakdown',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared mode toggle used by both projection card and detail sheet.
Widget buildModeToggle(ThemeData theme, WidgetRef ref, ProjectionMode mode) {
  return Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleChip(
          label: 'Nominal',
          isSelected: mode == ProjectionMode.nominal,
          onTap: () => ref.read(projectionModeProvider.notifier).state =
              ProjectionMode.nominal,
          theme: theme,
        ),
        _ToggleChip(
          label: 'Real',
          isSelected: mode == ProjectionMode.real,
          onTap: () => ref.read(projectionModeProvider.notifier).state =
              ProjectionMode.real,
          theme: theme,
        ),
      ],
    ),
  );
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ProjectionChart extends StatelessWidget {
  final List<ProjectionYear> projection;
  final ProjectionMode mode;

  const _ProjectionChart({required this.projection, required this.mode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartColor = theme.colorScheme.primary;

    final spots = projection.map((p) {
      final value =
          mode == ProjectionMode.nominal ? p.nominalNetWorth : p.realNetWorth;
      return FlSpot(p.year.toDouble(), value);
    }).toList();

    // Find milestone years
    final milestoneSpots = <FlSpot>[];
    for (final p in projection) {
      if (p.milestones.isNotEmpty) {
        final value =
            mode == ProjectionMode.nominal ? p.nominalNetWorth : p.realNetWorth;
        milestoneSpots.add(FlSpot(p.year.toDouble(), value));
      }
    }

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final yRange = maxY - minY;
    final chartMinY = yRange == 0 ? minY - 100 : minY - yRange * 0.1;
    final chartMaxY = yRange == 0 ? maxY + 100 : maxY + yRange * 0.1;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 20,
          minY: chartMinY,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yRange > 0 ? yRange / 3 : 100,
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  if (value % 5 != 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Yr ${value.toInt()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _compactRM(value),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  theme.colorScheme.inverseSurface.withValues(alpha: 0.92),
              tooltipRoundedRadius: 8,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final year = spot.x.toInt();
                  final p = projection[year];
                  return LineTooltipItem(
                    'Year $year (Age ${p.age})\n${spot.y.toRinggit(showDecimals: false)}',
                    TextStyle(
                      color: theme.colorScheme.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: chartColor,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return milestoneSpots.any((m) => m.x == spot.x);
                },
                getDotPainter: (spot, _, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: const Color(0xFFF59E0B),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    chartColor.withValues(alpha: 0.18),
                    chartColor.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _compactRM(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) {
      return '${sign}RM${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      return '${sign}RM${(abs / 1000).toStringAsFixed(0)}K';
    }
    return '${sign}RM${abs.toStringAsFixed(0)}';
  }
}
