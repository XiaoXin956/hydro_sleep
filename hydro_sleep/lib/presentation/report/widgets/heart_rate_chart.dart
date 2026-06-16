import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 心率卡片
class HeartRateChart extends StatelessWidget {
  const HeartRateChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.heartRate,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(
                  theme: theme,
                  label: l10n.average,
                  value: '${MockData.avgHeartRate}',
                  unit: l10n.bpm,
                ),
                _SummaryItem(
                  theme: theme,
                  label: l10n.minimum,
                  value: '${MockData.minHeartRate}',
                  unit: l10n.bpm,
                ),
                _SummaryItem(
                  theme: theme,
                  label: l10n.maximum,
                  value: '${MockData.maxHeartRate}',
                  unit: l10n.bpm,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: LineChart(
                mainChartData(
                  data: MockData.heartRateCurve,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final String value;
  final String unit;

  const _SummaryItem({
    required this.theme,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

LineChartData mainChartData({
  required List<double> data,
}) {
  final dataMin = data.reduce((a, b) => a < b ? a : b);
  final dataMax = data.reduce((a, b) => a > b ? a : b);
  final minVal = dataMin - 20;
  final maxVal = dataMax + 20;

  String xLabel(int index) {
    final totalMin = 23 * 60 + index * 5;
    final h = (totalMin ~/ 60) % 24;
    final m = totalMin % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: (maxVal - minVal) / 4,
      getDrawingHorizontalLine: (value) => FlLine(
        color: const Color(0xFFE0E0E0),
        strokeWidth: 0.5,
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)),
              ),
            );
          },
          interval: 20,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          interval: 12,
          getTitlesWidget: (value, meta) {
            final idx = value.toInt();
            if (idx >= 0 && idx < data.length && idx % 12 == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  xLabel(idx),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: List.generate(
          data.length,
          (i) => FlSpot(i.toDouble(), data[i]),
        ),
        isCurved: true,
        color: AppColors.primary,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
        dotData: const FlDotData(show: false),
      ),
    ],
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: (data.length - 1).toDouble(),
    minY: minVal,
    maxY: maxVal,
  );
}
