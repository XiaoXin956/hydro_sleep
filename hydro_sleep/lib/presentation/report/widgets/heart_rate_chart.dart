import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';

/// 心率卡片
class HeartRateChart extends StatelessWidget {
  const HeartRateChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 摘要行
            Text(
              'Heart Rate',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(
                  theme: theme,
                  label: '平均',
                  value: '${MockData.avgHeartRate}',
                  unit: 'BPM',
                ),
                _SummaryItem(
                  theme: theme,
                  label: '最低',
                  value: '${MockData.minHeartRate}',
                  unit: 'BPM',
                ),
                _SummaryItem(
                  theme: theme,
                  label: '最高',
                  value: '${MockData.maxHeartRate}',
                  unit: 'BPM',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: LineChart(
                mainChartData(
                  data: MockData.heartRateCurve,
                  minVal: 40.0,
                  maxVal: 100.0,
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
  required double minVal,
  required double maxVal,
}) {
  return LineChartData(
    gridData: FlGridData(show: false),
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
          getTitlesWidget: (value, meta) {
            if (value.toInt() % 10 == 0) {
              final minutes = value.toInt();
              final h = minutes ~/ 60;
              final m = minutes % 60;
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('$h:${m.toString().padLeft(2, '0')}'),
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
