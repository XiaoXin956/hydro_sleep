import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/report/daily/bloc/daily_report_cubit.dart';

/// 心率卡片
class HeartRateChart extends StatelessWidget {
  const HeartRateChart({super.key});

  static const double _yMin = 20;
  static const double _yMax = 220;
  // 6 个刻度：20, 60, 100, 140, 180, 220
  static const _yLabels = [20, 60, 100, 140, 180, 220];

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
            Text(l10n.heartRate, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            BlocBuilder<DailyReportCubit, DailyReportState>(
              builder: (context, state) {
                final hrData = state.heartRateCurve;
                final startTime = state.curveStartTime;

                if (hrData.isEmpty || startTime == null) {
                  return SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        l10n.noData,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                final data = hrData.map((e) => e.toDouble()).toList();

                final sum = hrData.reduce((a, b) => a + b);
                final avgHr = (sum / hrData.length).round();
                final minHr = hrData.reduce((a, b) => a < b ? a : b);
                final maxHr = hrData.reduce((a, b) => a > b ? a : b);

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SummaryItem(theme: theme, label: l10n.average, value: '$avgHr', unit: l10n.bpm),
                        _SummaryItem(theme: theme, label: l10n.minimum, value: '$minHr', unit: l10n.bpm),
                        _SummaryItem(theme: theme, label: l10n.maximum, value: '$maxHr', unit: l10n.bpm),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: LineChart(
                        _buildChart(data: data, startTime: startTime),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static LineChartData _buildChart({
    required List<double> data,
    required DateTime startTime,
  }) {
    String xLabel(int index) {
      final t = startTime.add(Duration(minutes: index));
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 40,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Color(0xFFE0E0E0),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (_yLabels.contains(value.toInt())) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 60,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx >= 0 && idx < data.length && idx % 60 == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(xLabel(idx), style: const TextStyle(fontSize: 10)),
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
          spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
          isCurved: true,
          color: AppColors.heartRate,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.heartRate.withValues(alpha: 0.1),
          ),
          dotData: const FlDotData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.white,
          getTooltipItems: (spots) => spots.map((spot) =>
            LineTooltipItem('${spot.y.toInt()} BPM',
              TextStyle(color: AppColors.heartRate, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ).toList(),
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes.map((_) =>
          TouchedSpotIndicatorData(
            FlLine(color: AppColors.heartRate, strokeWidth: 1),
            FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 4, color: AppColors.heartRate,
                strokeWidth: 2, strokeColor: Colors.white,
              ),
            ),
          ),
        ).toList(),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: _yMin,
      maxY: _yMax,
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
            color: AppColors.heartRate,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: theme.textTheme.bodySmall),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
