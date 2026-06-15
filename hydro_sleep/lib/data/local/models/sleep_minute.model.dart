import 'package:isar_community/isar.dart';

part 'sleep_minute.model.g.dart';

/// 每分钟数据点
@collection
class SleepMinute {
  Id id = Isar.autoIncrement;

  late DateTime timestamp;
  late int state; // 1=离床, 2=体动, 3=坐起, 4=睡眠, 5=清醒, 6=重物, 11=深睡, 12=浅睡, 13=REM, 14=清醒, 15=离床
  late int heartRate;
  late int breathRate;
  late int movement;
  late int snoring;
  late int ahi;
}
