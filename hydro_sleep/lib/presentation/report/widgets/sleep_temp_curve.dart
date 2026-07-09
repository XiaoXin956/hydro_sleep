import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/report/daily/bloc/daily_report_cubit.dart';

/// 睡眠 & 温度曲线卡片（双 Y 轴，0-50 范围）
class SleepTempCurve extends StatelessWidget {
  const SleepTempCurve({super.key});

  // 睡眠阶段 → Y 值映射
  static const double _deepSleep = 10;
  static const double _lightSleep = 20;
  static const double _rem = 30;
  static const double _awake = 40;

  static const double _yMin = 0;
  static const double _yMax = 50;

  static final _stageKeys = <double, String>{
    _deepSleep: 'deep',
    _lightSleep: 'light',
    _rem: 'rem',
    _awake: 'awake',
  };

  String _stageLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'deep':
        return l10n.sleepStageDeep;
      case 'light':
        return l10n.sleepStageLight;
      case 'rem':
        return l10n.sleepStageRem;
      case 'awake':
        return l10n.sleepStageAwake;
      default:
        return key;
    }
  }

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
              l10n.sleepTempCurve,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            BlocBuilder<DailyReportCubit, DailyReportState>(
              builder: (context, state) {
                // 优先用真实数据，无数据时用 mock
                final List<double> stageData;
                final DateTime startTime;
                if (state.stageCurve.isNotEmpty) {
                  stageData = state.stageCurve;
                  startTime = state.curveStartTime!;
                } else {
                  stageData = MockData.sleepStagesCurve;
                  // mock 默认 23:00
                  final now = DateTime.now();
                  startTime = DateTime(now.year, now.month, now.day, 23, 0);
                }
                final tempData = state.temperatureCurve.isNotEmpty
                    ? state.temperatureCurve
                    : MockData.temperatureCurve;

                return SizedBox(
                  height: 200,
                  child: LineChart(
                    _buildChart(
                      sleepStages: stageData,
                      temperatureData: tempData,
                      startTime: startTime,
                      l10n: l10n,
                    ),
                    duration: const Duration(milliseconds: 250),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(theme, l10n.sleepLegend, AppColors.primary),
                const SizedBox(width: 24),
                _legendItem(theme, l10n.tempLegend, AppColors.temperatureCurve),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  LineChartData _buildChart({
    required List<double> sleepStages,
    required List<double> temperatureData,
    required DateTime startTime,
    required AppLocalizations l10n,
  }) {
    final sleepSpots = List.generate(
      sleepStages.length,
      (i) => FlSpot(i.toDouble(), sleepStages[i]),
    );
    final tempSpots = <FlSpot>[];
    for (var i = 0; i < temperatureData.length; i++) {
      if (temperatureData[i] > 0) {
        tempSpots.add(FlSpot(i.toDouble(), temperatureData[i]));
      }
    }

    // X 轴标签：基于实际 startTime，每分钟一个点
    String xLabel(int index) {
      final t = startTime.add(Duration(minutes: index));
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Color(0xFFE0E0E0),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 10,
            getTitlesWidget: (value, meta) {
              if (_stageKeys.containsKey(value)) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _stageLabel(_stageKeys[value]!, l10n),
                    style: const TextStyle(fontSize: 9, color: Color(0xFF616161)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 10,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '${value.toInt()}°',
                  style: const TextStyle(fontSize: 9, color: Color(0xFFEF5350)),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 60, // 每小时一个标签
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx >= 0 && idx < sleepStages.length && idx % 60 == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(xLabel(idx), style: const TextStyle(fontSize: 10)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: sleepSpots,
          isCurved: false,
          color: AppColors.primary,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
        ),
        LineChartBarData(
          spots: tempSpots,
          isCurved: true,
          color: AppColors.temperatureCurve,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (sleepStages.length - 1).toDouble(),
      minY: _yMin,
      maxY: _yMax,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.white,
          getTooltipItems: (spots) => spots.map((spot) {
            final isTemp = spot.barIndex == 1;
            final text = isTemp
                ? '${spot.y.toInt()}°C'
                : '${spot.y.toInt()}';
            return LineTooltipItem(
              text,
              TextStyle(
                color: isTemp ? AppColors.temperatureCurve : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes.map((_) =>
          TouchedSpotIndicatorData(
            FlLine(color: barData.color ?? AppColors.primary, strokeWidth: 1),
            FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 4, color: barData.color ?? AppColors.primary,
                strokeWidth: 2, strokeColor: Colors.white,
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }
}
