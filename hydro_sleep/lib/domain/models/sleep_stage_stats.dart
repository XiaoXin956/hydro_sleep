import 'package:equatable/equatable.dart';

/// 睡眠阶段统计（日/周/月报告共用）
class SleepStageStats extends Equatable {
  final int deepMinutes;
  final int lightMinutes;
  final int remMinutes;
  final int awakeMinutes; // 清醒 + 离床 + 坐起
  final int totalMinutes;

  const SleepStageStats({
    required this.deepMinutes,
    required this.lightMinutes,
    required this.remMinutes,
    required this.awakeMinutes,
    required this.totalMinutes,
  });

  double get deepPct => totalMinutes > 0 ? deepMinutes / totalMinutes * 100 : 0;
  double get lightPct => totalMinutes > 0 ? lightMinutes / totalMinutes * 100 : 0;
  double get remPct => totalMinutes > 0 ? remMinutes / totalMinutes * 100 : 0;
  double get awakePct => totalMinutes > 0 ? awakeMinutes / totalMinutes * 100 : 0;

  static String formatMinutes(int m) {
    final h = m ~/ 60;
    final min = m % 60;
    if (h > 0) return '${h}h ${min}m';
    return '${min}m';
  }

  @override
  List<Object?> get props => [deepMinutes, lightMinutes, remMinutes, awakeMinutes, totalMinutes];
}