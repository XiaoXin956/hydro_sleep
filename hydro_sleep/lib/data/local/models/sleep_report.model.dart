import 'package:isar_community/isar.dart';

part 'sleep_report.model.g.dart';

/// 日报摘要
@collection
class SleepReport {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  late int score;
  late double efficiency;
  late int totalSleepMinutes;
  late int tossCount;
  late int outOfBedCount;
  late int ahi;
  late int totalSnoring;
  late String longestSleepStart;
}
