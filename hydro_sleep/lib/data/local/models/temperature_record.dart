import 'package:isar_community/isar.dart';

part 'temperature_record.g.dart';

/// 温度记录（A5 5A 实际温度，每 10 秒一条）
@collection
class TemperatureRecord {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('timestamp')])
  late String deviceId;

  @Index()
  late DateTime timestamp;

  /// 实际温度（整数，单位°C）
  late int temperature;
}
