import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';

/// 睡眠 & 温度曲线卡片（双 Y 轴，数据层面映射）
class SleepTempCurve extends StatelessWidget {
  const SleepTempCurve({super.key});

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
                _dualAxisChartData(
                  sleepStages: MockData.sleepStagesCurve,
                  temperatureData: MockData.temperatureCurve,
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            const SizedBox(height: 12),
            // 图例
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
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// 将值归一化到 [0, 1]
double _normalize(double value, double min, double max) {
  if (max == min) return 0;
  return ((value - min) / (max - min)).clamp(0.0, 1.0);
}

/// 睡眠阶段标签
final _stageLabels = <double, String>{
  5: '5-深睡',
  4: '4-浅睡',
  3: '3-REM',
  2: '2-眼动',
  1: '1-醒',
};

LineChartData _dualAxisChartData({
  required List<double> sleepStages,
  required List<double> temperatureData,
}) {
  // 温度范围
  final tempMin = temperatureData.reduce((a, b) => a < b ? a : b);
  final tempMax = temperatureData.reduce((a, b) => a > b ? a : b);

  // 两条曲线都映射到 0~1 显示范围
  final sleepSpots = List.generate(
    sleepStages.length,
    (i) => FlSpot(
      i.toDouble(),
      _normalize(sleepStages[i].clamp(1.0, 5.0), 1, 5),
    ),
  );

  final tempSpots = List.generate(
    temperatureData.length,
    (i) => FlSpot(
      i.toDouble(),
      _normalize(temperatureData[i], tempMin, tempMax),
    ),
  );

  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      // 左 Y 轴：睡眠阶段（显示 1-5）
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, meta) {
            // value 是 0~1，映射回睡眠阶段
            final stage = (value * 4 + 1).round().toDouble();
            if (_stageLabels.containsKey(stage)) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  _stageLabels[stage]!,
                  style: const TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          interval: 0.25, // 4 等分 = 1~5
        ),
      ),
      // 右 Y 轴：温度（显示实际温度值）
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 34,
          getTitlesWidget: (value, meta) {
            // value 是 0~1，映射回实际温度
            final displayTemp = tempMin + value * (tempMax - tempMin);
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '${displayTemp.toStringAsFixed(0)}°',
                style: const TextStyle(fontSize: 10, color: Color(0xFFEF5350)),
              ),
            );
          },
          interval: 0.25,
        ),
      ),
      // X 轴：时间
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
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineBarsData: [
      // Sleep 曲线（阶梯折线，1-5 归一化到 0~1）
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
      // Temperature 曲线（归一化到 0~1）
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
    minY: 0,
    maxY: 1,
  );
}
