import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';

/// 睡眠 & 温度曲线卡片（双 Y 轴，共用 0-35 范围）
class SleepTempCurve extends StatelessWidget {
  const SleepTempCurve({super.key});

  static const double _yMin = 0;
  static const double _yMax = 35;

  // 睡眠阶段 → Y 值
  static const double _deepSleep = 4;
  static const double _lightSleep = 10;
  static const double _rem = 16;
  static const double _eyeMove = 24;
  static const double _awake = 30;

  static final _stageMap = <double, String>{
    _deepSleep: '深睡',
    _lightSleep: '浅睡',
    _rem: 'REM',
    _eyeMove: '眼动',
    _awake: '清醒',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep & Temp Curve',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                _chartData(
                  sleepStages: MockData.sleepStagesCurve,
                  temperatureData: MockData.temperatureCurve,
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(theme, 'Sleep', AppColors.primary),
                const SizedBox(width: 24),
                _legendItem(theme, 'Temp', AppColors.temperatureCurve),
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

  static LineChartData _chartData({
    required List<double> sleepStages,
    required List<double> temperatureData,
  }) {
    final sleepSpots = List.generate(
      sleepStages.length,
      (i) => FlSpot(i.toDouble(), sleepStages[i]),
    );
    final tempSpots = List.generate(
      temperatureData.length,
      (i) => FlSpot(i.toDouble(), temperatureData[i]),
    );

    // X 轴：23:00→06:00, 每点 5 分钟, 共72点
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
        // 左 Y 轴：睡眠阶段标签
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (_stageMap.containsKey(value)) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _stageMap[value]!,
                    style: const TextStyle(fontSize: 9, color: Color(0xFFBDBDBD)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        // 右 Y 轴：温度
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
        // X 轴：时间 23:00→06:00
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 12, // 每小时
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
        // Sleep 曲线（阶梯折线）
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
        // Temperature 曲线（平滑）
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
