import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 睡眠 & 温度曲线卡片（双 Y 轴，共用 0-35 范围）
class SleepTempCurve extends StatelessWidget {
  const SleepTempCurve({super.key});

  static const double _yMin = 0;
  static const double _yMax = 35;

  static const double _deepSleep = 4;
  static const double _lightSleep = 10;
  static const double _rem = 16;
  static const double _eyeMove = 24;
  static const double _awake = 30;

  static final _stageKeys = <double, String>{
    _deepSleep: 'deep',
    _lightSleep: 'light',
    _rem: 'rem',
    _eyeMove: 'eyeMove',
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
      case 'eyeMove':
        return l10n.sleepStageEyeMove;
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
            SizedBox(
              height: 200,
              child: LineChart(
                _chartData(
                  sleepStages: MockData.sleepStagesCurve,
                  temperatureData: MockData.temperatureCurve,
                  l10n: l10n,
                ),
                duration: const Duration(milliseconds: 250),
              ),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  LineChartData _chartData({
    required List<double> sleepStages,
    required List<double> temperatureData,
    required AppLocalizations l10n,
  }) {
    final sleepSpots = List.generate(
      sleepStages.length,
      (i) => FlSpot(i.toDouble(), sleepStages[i]),
    );
    final tempSpots = List.generate(
      temperatureData.length,
      (i) => FlSpot(i.toDouble(), temperatureData[i]),
    );

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
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: const Color(0xFFE0E0E0),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: 1,
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
            interval: 5,
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
            interval: 12,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx >= 0 && idx < sleepStages.length && idx % 12 == 0) {
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
    );
  }
}
