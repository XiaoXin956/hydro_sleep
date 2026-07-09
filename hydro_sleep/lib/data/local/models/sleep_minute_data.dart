import 'package:isar_community/isar.dart';

part 'sleep_minute_data.g.dart';

/// 0x94 分钟级睡眠数据 — Isar 持久化模型
///
/// 每条记录 = 1 分钟的睡眠状态，由设备自动推送或 0x14 手动触发。
/// 复合唯一约束：(deviceId, timestamp)，相同设备相同分钟覆盖更新。
@collection
class SleepMinuteData {
  Id id = Isar.autoIncrement;

  /// BLE 设备 MAC 地址
  @Index(composite: [CompositeIndex('timestamp')])
  late String deviceId;

  /// 该分钟的起始时间（精确到分钟，秒固定为 0）
  @Index()
  late DateTime timestamp;

  /// 睡眠状态（SleepMinuteStatus 的 dbValue）
  late int status;

  /// 心率（无符号 1 字节，离床时 = 0）
  late int heartRate;

  /// 呼吸率（真实值 × 10 存储，离床时 = 0）
  late int breathRate;

  /// 体动（无符号 1 字节）
  late int bodyMove;
}
