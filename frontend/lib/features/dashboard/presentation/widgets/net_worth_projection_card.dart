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

    return Pressable(
      onTap: () => showProjectionDetailSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Net Worth Projection',
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
            const SizedBox(height: 8),

            // Mini summary
            Text(
              'Today: ${todayValue.toRinggit(showDecimals: false)}  →  In 20 years: ${futureValue.toRinggit(showDecimals: false)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 180,
              child: _ProjectionChart(projection: projection, mode: mode),
            ),
          ],
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
    final teal = theme.colorScheme.primary;

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
    final chartMinY = minY - yRange * 0.1;
    final chartMaxY = maxY + yRange * 0.1;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 20,
        minY: chartMinY,
        maxY: chartMaxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) =>
                theme.colorScheme.inverseSurface.withValues(alpha: 0.9),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Year ${spot.x.toInt()}\n${spot.y.toRinggit(showDecimals: false)}',
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
            color: teal,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                return milestoneSpots.any((m) => m.x == spot.x);
              },
              getDotPainter: (spot, _, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.amber,
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
                  teal.withValues(alpha: 0.15),
                  teal.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
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
