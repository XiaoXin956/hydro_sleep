import 'package:isar_community/isar.dart';

part 'sleep_session.model.g.dart';

/// 睡眠会话（代表一次完整睡眠）
@collection
class SleepSession {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startTime;
  late DateTime endTime;
  late int score;
  late int totalSleepMinutes;
  late double efficiency;
  late String longestSleepStart;

  // 各阶段时长（分钟）
  late int deepSleepMinutes;
  late int lightSleepMinutes;
  late int remSleepMinutes;
  late int awakeMinutes;
  late int outOfBedMinutes;

  // 统计
  late int tossCount;
  late int outOfBedCount;
  late int ahi;
  late int totalSnoring;
}
